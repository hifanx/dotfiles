---Utilities for opening the home note in an Obsidian vault.
local M = {}

---@class VaultOptions
---@field roots string[] Vault directories.
---@field keymaps? table<string, string|table> action lhs or { lhs, desc = '...' }.

---@type string[]
local roots = {}

---Find the deepest configured vault containing path.
---@param path? string Defaults to the current buffer's path, or cwd for an unnamed buffer.
---@return string? root
local function vault_root(path)
    path = path or vim.api.nvim_buf_get_name(0)
    if path == '' then path = vim.fn.getcwd() end
    local found
    for _, root in ipairs(roots) do
        if vim.fs.relpath(root, path) and (not found or #root > #found) then
            found = root
        end
    end
    return found
end

---Open Home.md or focus a window already displaying it.
---Warn and do nothing when the current buffer or cwd is outside every vault.
function M.open_home()
    local root = vault_root()
    if not root then
        return vim.notify('vaultpal: not inside a vault', vim.log.levels.WARN)
    end
    local path = root .. '/Home.md'

    --  unlike bufwinid, this lookup is not limited to the current tab
    local win = vim.fn.win_findbuf(vim.fn.bufnr(path))[1]

    if win then
        -- selecting a window also switches to its tab when necessary
        vim.api.nvim_set_current_win(win)
    else
        -- no window currently displays Home.md, so open it here
        vim.cmd.edit(vim.fn.fnameescape(path))
    end
end

---Open the current note in Obsidian.
---Warn and do nothing when the note is unnamed, unsaved, missing, or outside every vault.
function M.open_in_obsidian()
    local path = vim.api.nvim_buf_get_name(0)
    if path == '' then
        return vim.notify('vaultpal: name the note first', vim.log.levels.WARN)
    end
    if not vault_root(path) then
        return vim.notify('vaultpal: not inside a vault', vim.log.levels.WARN)
    end
    if vim.bo.modified then
        return vim.notify('vaultpal: save the note first', vim.log.levels.WARN)
    end
    if vim.fn.filereadable(path) ~= 1 then
        return vim.notify('vaultpal: note is not on disk', vim.log.levels.WARN)
    end
    local job, err =
        vim.ui.open('obsidian://open?path=' .. vim.uri_encode(path))
    if not job then
        vim.notify(
            'vaultpal: cannot open Obsidian: ' .. (err or 'unknown error'),
            vim.log.levels.ERROR
        )
    end
end

local function read_macos_files(done)
    done = vim.schedule_wrap(done)
    local script = [[
        use framework "AppKit"
        use scripting additions
        set board to current application's NSPasteboard's generalPasteboard()
        set initialChange to board's changeCount() as integer
        set boardItems to board's pasteboardItems()
        if boardItems is missing value then error "cannot read pasteboard items"
        set paths to current application's NSMutableArray's array()
        set fileType to current application's NSPasteboardTypeFileURL
        repeat with entry in boardItems
            if (entry's types()'s containsObject:fileType) as boolean then
                set urlText to entry's stringForType:fileType
                if urlText is missing value then error "cannot read file URL"
                set fileURL to current application's NSURL's URLWithString:urlText
                if fileURL is missing value then error "invalid file URL"
                if not (fileURL's isFileURL() as boolean) then error "not a file URL"
                set hostName to fileURL's |host|()
                if hostName is not missing value then
                    if {"", "localhost"} does not contain (hostName as text) then error "non-local file URL"
                end if
                set sourcePath to fileURL's |path|()
                if sourcePath is missing value then error "file URL has no path"
                paths's addObject:sourcePath
            end if
        end repeat
        if (board's changeCount() as integer) is not initialChange then error "clipboard changed; retry paste"
        set reply to current application's NSMutableDictionary's dictionary()
        reply's setObject:paths forKey:"paths"
        reply's setObject:initialChange forKey:"change"
        set jsonData to current application's NSJSONSerialization's dataWithJSONObject:reply ¬
            options:0 |error|:(missing value)
        if jsonData is missing value then error "cannot encode file paths"
        return (current application's NSString's alloc()'s initWithData:jsonData ¬
            encoding:(current application's NSUTF8StringEncoding)) as text

    ]]
    local ok, err = pcall(
        vim.system,
        { '/usr/bin/osascript', '-e', script },
        { text = true, timeout = 3000 },
        function(result)
            if result.code ~= 0 then
                return done(
                    nil,
                    'file clipboard failed ('
                        .. result.code
                        .. '): '
                        .. vim.trim(result.stderr or '')
                )
            end
            local decoded, reply = pcall(vim.json.decode, result.stdout or '')
            if not decoded or type(reply) ~= 'table' or vim.islist(reply) then
                return done(nil, 'invalid file clipboard reply')
            end
            local paths, change = reply.paths, reply.change
            if
                type(paths) ~= 'table'
                or not vim.islist(paths)
                or type(change) ~= 'number'
                or change < 0
                or change % 1 ~= 0
            then
                return done(nil, 'invalid file clipboard reply')
            end

            for _, path in ipairs(paths) do
                if
                    type(path) ~= 'string'
                    or path:sub(1, 1) ~= '/'
                    or path:find('\0', 1, true)
                then
                    return done(nil, 'invalid file clipboard path')
                end
            end
            done(paths, nil, change)
        end
    )
    if not ok then done(nil, 'cannot start osascript: ' .. tostring(err)) end
end

local function parse_uri_list(text)
    local paths = {}
    for _, line in ipairs(vim.split(text, '\n', { plain = true })) do
        line = line:gsub('\r$', '')
        if line ~= '' and line:sub(1, 1) ~= '#' then
            local scheme, encoded = line:match('^([%a][%w+.-]*):(.*)$')
            if not scheme or scheme:lower() ~= 'file' then
                return nil, 'clipboard URI is not a file URI'
            end
            if encoded:sub(1, 2) == '//' then
                local host, path = encoded:match('^//([^/]*)(/.*)$')
                if not host or (host ~= '' and host:lower() ~= 'localhost') then
                    return nil, 'clipboard file URI is not local'
                end
                encoded = path
            end
            if encoded:sub(1, 1) ~= '/' or encoded:find('[%c%s?#]') then
                return nil, 'invalid clipboard file URI path'
            end
            if encoded:gsub('%%[%x][%x]', ''):find('%', 1, true) then
                return nil, 'invalid clipboard URI percent escape'
            end
            local path = vim.uri_decode(encoded)
            if path:find('\0', 1, true) then
                return nil, 'clipboard file path contains NUL'
            end
            paths[#paths + 1] = path
        end
    end
    return paths
end

local function read_wayland_files(done)
    done = vim.schedule_wrap(done)
    local executable = vim.fn.exepath('wl-paste')
    if executable == '' then return done(nil, 'wl-paste unavailable') end

    -- shortcut: separate CLI reads cannot pin clipboard ownership; use a native bridge if required.
    local ok, err = pcall(
        vim.system,
        { executable, '--list-types' },
        { text = true, timeout = 3000 },
        vim.schedule_wrap(function(result)
            if result.code ~= 0 then
                return done(
                    nil,
                    'Wayland type discovery failed ('
                        .. result.code
                        .. '): '
                        .. vim.trim(result.stderr or '')
                )
            end
            local types = {}
            for _, mime in
                ipairs(vim.split(result.stdout or '', '\n', { plain = true }))
            do
                mime = mime:gsub('\r$', '')
                if mime ~= '' then types[mime] = true end
            end
            if not types['text/uri-list'] then return done({}, nil, types) end

            local started, read_err = pcall(
                vim.system,
                { executable, '--no-newline', '--type', 'text/uri-list' },
                { text = true, timeout = 3000 },
                function(reply)
                    if reply.code ~= 0 then
                        return done(
                            nil,
                            'Wayland file read failed ('
                                .. reply.code
                                .. '): '
                                .. vim.trim(reply.stderr or '')
                        )
                    end
                    local paths, parse_err = parse_uri_list(reply.stdout or '')
                    done(paths, parse_err, types)
                end
            )
            if not started then
                done(nil, 'cannot start wl-paste: ' .. tostring(read_err))
            end
        end)
    )
    if not ok then done(nil, 'cannot start wl-paste: ' .. tostring(err)) end
end

local function read_x11_files(done)
    done = vim.schedule_wrap(done)
    local executable = vim.fn.exepath('xclip')
    if executable == '' then return done(nil, 'xclip unavailable') end

    -- shortcut: separate CLI reads cannot pin clipboard ownership; use a native bridge if required.
    local ok, err = pcall(
        vim.system,
        { executable, '-selection', 'clipboard', '-out', '-target', 'TARGETS' },
        { text = true, timeout = 3000 },
        vim.schedule_wrap(function(result)
            if result.code ~= 0 then
                return done(
                    nil,
                    'X11 type discovery failed ('
                        .. result.code
                        .. '): '
                        .. vim.trim(result.stderr or '')
                )
            end
            local types = {}
            for _, mime in
                ipairs(vim.split(result.stdout or '', '\n', { plain = true }))
            do
                mime = mime:gsub('\r$', '')
                if mime ~= '' then types[mime] = true end
            end
            if not types['text/uri-list'] then return done({}, nil, types) end

            local started, read_err = pcall(vim.system, {
                executable,
                '-selection',
                'clipboard',
                '-out',
                '-target',
                'text/uri-list',
            }, { text = true, timeout = 3000 }, function(reply)
                if reply.code ~= 0 then
                    return done(
                        nil,
                        'X11 file read failed ('
                            .. reply.code
                            .. '): '
                            .. vim.trim(reply.stderr or '')
                    )
                end
                local paths, parse_err = parse_uri_list(reply.stdout or '')
                done(paths, parse_err, types)
            end)
            if not started then
                done(nil, 'cannot start xclip: ' .. tostring(read_err))
            end
        end)
    )
    if not ok then done(nil, 'cannot start xclip: ' .. tostring(err)) end
end

local function copy_file(source, destination, done)
    done = vim.schedule_wrap(done)
    local request, err = vim.uv.fs_copyfile(
        source,
        destination,
        { excl = true },
        function(copy_err)
            if copy_err then
                return done(nil, 'cannot copy asset: ' .. tostring(copy_err))
            end
            done(destination)
        end
    )
    if not request then
        done(nil, 'cannot start asset copy: ' .. tostring(err))
    end
end

local function file_kind(source, done)
    done = vim.schedule_wrap(done)
    local stat, stat_err = vim.uv.fs_stat(source)
    if not stat then
        return done(nil, 'cannot inspect source: ' .. tostring(stat_err))
    end
    if stat.type ~= 'file' then
        return done(nil, 'source is not a regular file')
    end

    local fd, open_err = vim.uv.fs_open(source, 'r', 0)
    if not fd then
        return done(nil, 'cannot read source: ' .. tostring(open_err))
    end

    local closed, close_err = vim.uv.fs_close(fd)
    if not closed then
        return done(nil, 'cannot close source: ' .. tostring(close_err))
    end

    local ok, err = pcall(
        vim.system,
        { 'file', '-b', '-L', '--mime-type', '--', source },
        { text = true, timeout = 3000 },
        function(result)
            if result.code ~= 0 then
                return done(
                    nil,
                    'content probe failed ('
                        .. result.code
                        .. '): '
                        .. vim.trim(result.stderr or '')
                )
            end

            local mime = vim.trim(result.stdout or '')
            local kind = ({
                ['image/png'] = 'png',
                ['image/gif'] = 'gif',
                ['application/pdf'] = 'pdf',
            })[mime]
            if kind then return done(kind) end

            if mime:match('^image/[%w.+%-]+$') then return done('image') end
            done(nil, 'unsupported attachment content: ' .. mime)
        end
    )

    if not ok then done(nil, 'cannot start file: ' .. tostring(err)) end
end

local function convert_image(source, destination, done)
    done = vim.schedule_wrap(done)
    local magick = vim.fn.exepath('magick')
    if magick == '' then
        return done(nil, 'ImageMagick unavailable; PNG/GIF/PDF still work')
    end

    local directory, temp_err =
        vim.uv.fs_mkdtemp(vim.fn.tempname() .. '-XXXXXX')
    if not directory then
        return done(
            nil,
            'cannot create conversion directory: ' .. tostring(temp_err)
        )
    end

    local function finish(saved, message)
        local cleaned, cleanup_err =
            pcall(vim.fs.rm, directory, { recursive = true })
        if not cleaned then
            local warning = 'cannot clean conversion directory '
                .. directory
                .. ': '
                .. tostring(cleanup_err)
            message = message and (message .. '; ' .. warning) or warning
        end
        done(saved, message)
    end

    -- Fixed input name avoids ImageMagick interpreting source names as frame selectors.
    copy_file(source, directory .. '/input', function(staged, stage_err)
        if not staged then return finish(nil, stage_err) end
        local ok, spawn_err = pcall(
            vim.system,
            {
                magick,
                '-regard-warnings',
                'input',
                '+adjoin',
                'PNG:output-%d.png',
            },
            { cwd = directory, text = true, timeout = 30000 },
            vim.schedule_wrap(function(result)
                if result.code ~= 0 then
                    return finish(
                        nil,
                        'image conversion failed ('
                            .. result.code
                            .. '): '
                            .. vim.trim(result.stderr or '')
                    )
                end

                local outputs = {}
                for name, kind, scan_err in
                    vim.fs.dir(directory, { err = true, plain = true })
                do
                    if scan_err then
                        return finish(
                            nil,
                            'cannot inspect conversion output: '
                                .. tostring(scan_err)
                        )
                    end
                    if name ~= 'input' then
                        if
                            kind ~= 'file'
                            or not name:match('^output%-%d+%.png$')
                        then
                            return finish(
                                nil,
                                'unexpected conversion output: ' .. name
                            )
                        end
                        outputs[#outputs + 1] = directory .. '/' .. name
                    end
                end
                if #outputs ~= 1 then
                    return finish(
                        nil,
                        'conversion must produce exactly one image; got '
                            .. #outputs
                    )
                end
                copy_file(outputs[1], destination, finish)
            end)
        )
        if not ok then
            finish(nil, 'cannot start magick: ' .. tostring(spawn_err))
        end
    end)
end

local function save_files(root, paths, stem, done)
    done = vim.schedule_wrap(done)
    local links, messages = {}, {}
    if #paths == 0 then return done(links, messages) end

    local directory = root .. '/assets'
    local prefix = stem .. '-' .. os.date('%Y%m%d-%H%M%S')
    local made, mkdir_err = pcall(vim.fs.mkdir, directory, { parents = true })
    if not made then
        return done({}, { 'cannot create assets: ' .. tostring(mkdir_err) })
    end

    local index = 0
    local function next_file()
        index = index + 1
        local source = paths[index]
        if not source then return done(links, messages) end

        file_kind(source, function(kind, kind_err)
            if not kind then
                messages[#messages + 1] = source .. ': ' .. kind_err
                return next_file()
            end
            local extension = kind == 'image' and 'png' or kind
            local suffix = ''
            if #paths > 1 then suffix = string.format('-%03d', #links + 1) end
            local name = prefix .. suffix .. '.' .. extension
            local relative = 'assets/' .. name
            local save = kind == 'image' and convert_image or copy_file
            save(source, directory .. '/' .. name, function(saved, message)
                if saved then
                    local marker = kind == 'pdf' and '' or '!'
                    links[#links + 1] = marker .. '[[' .. relative .. ']]'
                end
                if message then
                    messages[#messages + 1] = source .. ': ' .. message
                end
                next_file()
            end)
        end)
    end
    next_file()
end

local function save_unix_image(root, types, stem, done, wayland)
    done = vim.schedule_wrap(done)
    local mime
    for _, candidate in ipairs({ 'image/gif', 'application/pdf', 'image/png' }) do
        if types[candidate] then
            mime = candidate
            break
        end
    end
    if not mime then
        local candidates = {}
        for candidate in pairs(types) do
            if candidate:match('^image/') then
                candidates[#candidates + 1] = candidate
            end
        end
        table.sort(candidates)
        mime = candidates[1]
    end
    if not mime then return done({}, { 'no image or PDF on clipboard' }) end

    local reader = wayland and 'wl-paste' or 'xclip'
    local executable = vim.fn.exepath(reader)
    if executable == '' then return done({}, { reader .. ' unavailable' }) end
    local command = wayland and { executable, '--no-newline', '--type', mime }
        or { executable, '-selection', 'clipboard', '-out', '-target', mime }
    -- shortcut: buffered bytes and sync staging; stream if large pastes pause Neovim.
    local ok, err = pcall(
        vim.system,
        command,
        { text = false, timeout = 3000 },
        vim.schedule_wrap(function(result)
            if result.code ~= 0 then
                return done({}, {
                    'clipboard attachment read failed ('
                        .. result.code
                        .. '): '
                        .. vim.trim(result.stderr or ''),
                })
            end
            local bytes = result.stdout or ''
            if bytes == '' then
                return done({}, { 'empty clipboard attachment' })
            end

            local fd, temporary =
                vim.uv.fs_mkstemp(vim.fn.tempname() .. '-XXXXXX')
            if not fd then
                return done(
                    {},
                    { 'cannot stage clipboard: ' .. tostring(temporary) }
                )
            end
            local function finish(links, messages)
                local removed, remove_err = vim.uv.fs_unlink(temporary)
                if not removed then
                    messages[#messages + 1] = 'cannot clean clipboard stage '
                        .. temporary
                        .. ': '
                        .. tostring(remove_err)
                end
                done(links, messages)
            end

            local written, write_err = vim.uv.fs_write(fd, bytes, 0)
            local closed, close_err = vim.uv.fs_close(fd)
            local messages = {}
            if written ~= #bytes then
                messages[#messages + 1] = 'cannot stage complete clipboard bytes: '
                    .. tostring(write_err or 'short write')
            end
            if not closed then
                messages[#messages + 1] = 'cannot close clipboard stage: '
                    .. tostring(close_err)
            end
            if #messages > 0 then return finish({}, messages) end
            save_files(root, { temporary }, stem, finish)
        end)
    )
    if not ok then
        done({}, { 'cannot start ' .. reader .. ': ' .. tostring(err) })
    end
end

local function save_macos_image(root, change, stem, done)
    done = vim.schedule_wrap(done)
    local fd, temporary = vim.uv.fs_mkstemp(vim.fn.tempname() .. '-XXXXXX')
    if not fd then
        return done({}, { 'cannot stage clipboard: ' .. tostring(temporary) })
    end
    local function finish(links, messages)
        local removed, remove_err = vim.uv.fs_unlink(temporary)
        if not removed then
            messages[#messages + 1] = 'cannot clean clipboard stage '
                .. temporary
                .. ': '
                .. tostring(remove_err)
        end
        done(links, messages)
    end
    local closed, close_err = vim.uv.fs_close(fd)
    if not closed then
        return finish(
            {},
            { 'cannot close clipboard stage: ' .. tostring(close_err) }
        )
    end

    local script = [[
        use framework "AppKit"
        use framework "UniformTypeIdentifiers"
        use scripting additions
        on run argv
            set board to current application's NSPasteboard's generalPasteboard()
            set expectedChange to (item 2 of argv) as integer
            if (board's changeCount() as integer) is not expectedChange then error "clipboard changed; retry paste"
            set offered to board's types()
            if offered is missing value then error "cannot read clipboard types"
            set selectedType to missing value
            repeat with candidate in {"com.compuserve.gif", "com.adobe.pdf", "public.png"}
                if (offered's containsObject:candidate) as boolean then
                    set selectedType to candidate as text
                    exit repeat
                end if
            end repeat
            if selectedType is missing value then
                set imageType to current application's UTType's typeWithIdentifier:"public.image"
                set sortedTypes to offered's sortedArrayUsingSelector:"compare:"
                repeat with candidate in sortedTypes
                    set candidateType to current application's UTType's typeWithIdentifier:(candidate as text)
                    if candidateType is not missing value then
                        if (candidateType's conformsToType:imageType) as boolean then
                            set selectedType to candidate as text
                            exit repeat
                        end if
                    end if
                end repeat
            end if
            if selectedType is missing value then return "none"
            set attachmentData to board's dataForType:selectedType
            if attachmentData is missing value then error "cannot read clipboard attachment"
            if (attachmentData's |length|() as integer) is 0 then error "empty clipboard attachment"
            if (board's changeCount() as integer) is not expectedChange then error "clipboard changed; retry paste"
            if not (attachmentData's writeToFile:(item 1 of argv) atomically:false) as boolean then error "cannot stage clipboard attachment"
            return "saved"
        end run
    ]]
    local ok, err = pcall(
        vim.system,
        { '/usr/bin/osascript', '-e', script, temporary, tostring(change) },
        { text = true, timeout = 3000 },
        vim.schedule_wrap(function(result)
            if result.code ~= 0 then
                return finish({}, {
                    'clipboard attachment read failed ('
                        .. result.code
                        .. '): '
                        .. vim.trim(result.stderr or ''),
                })
            end
            local reply = vim.trim(result.stdout or '')
            if reply == 'saved' then
                return save_files(root, { temporary }, stem, finish)
            end
            local message = reply == 'none' and 'no image or PDF on clipboard'
                or ('unexpected clipboard reply: ' .. reply)
            finish({}, { message })
        end)
    )
    if not ok then
        finish({}, { 'cannot start osascript: ' .. tostring(err) })
    end
end

function M.save_assets()
    local buf = vim.api.nvim_get_current_buf()
    local path = vim.api.nvim_buf_get_name(buf)

    if path == '' then
        return vim.notify('vaultpal: name the note first', vim.log.levels.WARN)
    end
    local root = vault_root(path)
    if vim.bo.filetype ~= 'markdown' or not root then
        return vim.notify(
            'vaultpal: use a vault markdown note',
            vim.log.levels.WARN
        )
    end

    -- :t keeps the filename; :r removes its final extension
    -- e.g. "Project draft.md" --> "Project draft"
    local stem = vim.fn.fnamemodify(path, ':t:r')

    -- reject characters that would change the link's meaning:
    -- # heading, ^ block, | display options, [ and ] link boundaries
    -- \r\n line breaks
    -- This is a lua pattern character set, not regular expression
    -- %^ %[ %] means match literally
    if stem:find('[#%^|%[%]\r\n]') then
        return vim.notify(
            'vaultpal: note name contains characters unsafe in an Obsidian embed',
            vim.log.levels.WARN
        )
    end

    local pos = vim.api.nvim_win_get_cursor(0)
    local row, col = pos[1] - 1, pos[2]
    local tick = vim.api.nvim_buf_get_changedtick(buf)

    local function finish(links, messages)
        if #links == 0 then
            local message = #messages > 0 and table.concat(messages, '\n')
                or 'no attachments saved'
            return vim.notify('vaultpal: ' .. message, vim.log.levels.WARN)
        end

        local text = table.concat(links, '\n')
        local message = 'saved and inserted ' .. #links .. ' attachment(s)'
        local level = vim.log.levels.INFO
        if
            not vim.api.nvim_buf_is_loaded(buf)
            or vim.api.nvim_buf_get_name(buf) ~= path
            or vim.api.nvim_buf_get_changedtick(buf) ~= tick
            or vim.bo[buf].filetype ~= 'markdown'
            or vault_root(path) ~= root
        then
            message = 'saved assets; insertion skipped: note changed, unloaded, or outside vault; insert:\n'
                .. text
            level = vim.log.levels.WARN
        else
            local inserted, insert_err =
                pcall(vim.api.nvim_buf_set_text, buf, row, col, row, col, links)
            if not inserted then
                message = 'saved assets; insertion failed: '
                    .. tostring(insert_err)
                    .. '; insert: \n'
                    .. text
                level = vim.log.levels.ERROR
            end
        end
        if #messages > 0 then
            message = message
                .. '\nAttachment messages:\n'
                .. table.concat(messages, '\n')
            if level == vim.log.levels.INFO then level = vim.log.levels.WARN end
        end
        vim.notify('vaultpal: ' .. message, level)
    end

    if vim.fn.has('mac') == 0 then
        if vim.fn.has('unix') == 0 then
            return finish({}, { 'unsupported clipboard platform' })
        end
        local display = vim.env.WAYLAND_DISPLAY
        local wayland = display ~= nil and display ~= ''
        local x11 = vim.env.DISPLAY
        if not wayland and (not x11 or x11 == '') then
            return finish({}, { 'no supported local clipboard session' })
        end
        local read_files = wayland and read_wayland_files or read_x11_files
        read_files(function(paths, read_err, types)
            if not paths then return finish({}, { read_err }) end
            if #paths > 0 then return save_files(root, paths, stem, finish) end
            save_unix_image(root, types, stem, finish, wayland)
        end)
        return
    end

    read_macos_files(function(paths, read_err, change)
        if not paths then return finish({}, { read_err }) end
        if #paths > 0 then return save_files(root, paths, stem, finish) end
        save_macos_image(root, change, stem, finish)
    end)
end

function M.toggle_todo()
    if vim.bo.filetype ~= 'markdown' or not vault_root() then return end

    local line = vim.api.nvim_get_current_line()
    local prefix, state = line:match('^(%s*[-*+]%s+%[)([ xX])%]%f[%s%z]')
    if not prefix then
        prefix, state = line:match('^(%s*%d+[.)]%s+%[)([ xX])%]%f[%s%z]')
    end
    if not prefix then return end

    local cursor = vim.api.nvim_win_get_cursor(0)
    local row = cursor[1] - 1

    vim.api.nvim_buf_set_text(
        0,
        row,
        #prefix,
        row,
        #prefix + 1,
        { state == ' ' and 'x' or ' ' }
    )

    vim.api.nvim_win_set_cursor(0, cursor)
end

---@param opts? VaultOptions
function M.setup(opts)
    opts = opts or {}
    vim.validate('opts', opts, 'table')
    vim.validate('roots', opts.roots, 'table', true)
    vim.validate('keymaps', opts.keymaps, 'table', true)

    roots = {}
    assert(vim.islist(opts.roots or {}), 'vaultpal: roots must be a list')
    for _, root in ipairs(opts.roots or {}) do
        assert(
            type(root) == 'string' and root ~= '',
            'vaultpal: root must be a non-empty string'
        )
        roots[#roots + 1] =
            vim.fs.normalize(vim.fs.abspath(vim.fn.expand(root)))
    end
    if #roots == 0 then
        return vim.notify(
            'vaultpal: setup needs at least one vault root',
            vim.log.levels.WARN
        )
    end

    if vault_root() then
        local actions = {
            open_home = M.open_home,
            save_assets = M.save_assets,
            open_in_obsidian = M.open_in_obsidian,
            toggle_todo = M.toggle_todo,
        }
        for name, map in pairs(opts.keymaps or {}) do
            assert(actions[name], 'vaultpal: unknown keymap ' .. tostring(name))
            if type(map) == 'string' then map = { map } end
            vim.validate('keymap', map, 'table')
            vim.validate('mapping', map[1], 'string')
            assert(map[1] ~= '', 'vaultpal: mapping must not be empty')
            vim.validate('description', map.desc, 'string', true)
            vim.keymap.set('n', map[1], actions[name], { desc = map.desc })
        end
    end
end

return M
