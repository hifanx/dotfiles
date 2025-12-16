local profiler = {}

local sections = {}
local total_start = vim.uv.hrtime()

---Start measuring a section
---@param name string
function profiler.start(name) sections[name] = vim.uv.hrtime() end

---End measuring a section
---@param name string
function profiler.stop(name)
  local start = sections[name]
  if not start then
    vim.notify('Profiler: "' .. name .. '" was never started', vim.log.levels.WARN)
    return
  end
  sections[name] = (vim.uv.hrtime() - start) / 1e6
end

---Display all recorded section times
function profiler.report()
  local total_duration = (vim.uv.hrtime() - total_start) / 1e6
  local results = {}

  for name, duration in pairs(sections) do
    table.insert(results, { name = name, duration = duration })
  end

  table.sort(results, function(a, b) return a.duration > b.duration end)

  local sep =
    '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
  local lines = { sep, '󰄧 TIMER', sep }

  for _, r in ipairs(results) do
    table.insert(lines, string.format('  %.2f ms - %s', r.duration, r.name))
  end

  table.insert(lines, sep)
  table.insert(lines, string.format('  Total : %.2f ms', total_duration))
  table.insert(lines, sep)

  vim.schedule(function() vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO, { title = 'Startup Profile' }) end)
end

return profiler
