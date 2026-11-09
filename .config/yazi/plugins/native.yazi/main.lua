-- Previews through macOS built-ins, replacing ImageMagick and poppler.
-- `--pdf`: PDFKit, `--sips`: sips, otherwise Quick Look.

-- Prints the page count instead of rendering when the page is past the end.
local PDF = [[
ObjC.import("AppKit"); ObjC.import("Quartz");
function run([src, idx, out, maxW, maxH]) {
	const doc = $.PDFDocument.alloc.initWithURL($.NSURL.fileURLWithPath(src));
	if (doc.isNil() || doc.isLocked) throw new Error("cannot open PDF");
	if (+idx >= doc.pageCount) return doc.pageCount;
	const page = doc.pageAtIndex(+idx), box = page.boundsForBox($.kPDFDisplayBoxCropBox), turned = page.rotation % 180 != 0;
	const w = turned ? box.size.height : box.size.width, h = turned ? box.size.width : box.size.height, k = Math.min(maxW / w, maxH / h);
	const img = page.thumbnailOfSizeForBox($.NSMakeSize(w * k, h * k), $.kPDFDisplayBoxCropBox);
	const data = $.NSBitmapImageRep.imageRepWithData(img.TIFFRepresentation).representationUsingTypeProperties($.NSBitmapImageFileTypeJPEG, $.NSDictionary.dictionary);
	if (!data.writeToFileAtomically(out, true)) throw new Error("cannot write preview");
}
]]

-- Peek can read the cache while preload writes it, so publish it with a single `mv`.
-- qlmanage names its output after the source and exits 0 on failure, so `mv` is also the real check.
local SH = [[
d=$(mktemp -d) || exit
if [ "$1" = sips ]; then
	sips -s format jpeg -s formatOptions "$5" -Z "$4" "$2" --out "$d/out"
else
	qlmanage -t -s "$4" -o "$d" "$2"
fi >/dev/null 2>&1
mv "$d"/* "$3"; s=$?
rm -rf "$d"; exit $s
]]

local M = {}

function M:peek(job)
	local start, cache = os.clock(), ya.file_cache(job)
	if not cache then
		return
	end

	local ok, err, bound = self:preload(job)
	if bound and bound > 0 then
		return ya.emit("peek", { bound - 1, only_if = job.file.url, upper_bound = true })
	elseif not ok or err then
		return ya.preview_widget(job, err)
	end

	ya.sleep(math.max(0, rt.preview.image_delay / 1000 + start - os.clock()))

	local _, err = ya.image_show(cache, job.area)
	ya.preview_widget(job, err)
end

function M:seek(job)
	local h = cx.active.current.hovered
	if job.mime == "application/pdf" and h and h.url == job.file.url then
		local step = ya.clamp(-1, job.units, 1)
		ya.emit("peek", { math.max(0, cx.active.preview.skip + step), only_if = job.file.url })
	end
end

function M:preload(job)
	local cache = ya.file_cache(job)
	if not cache or fs.cha(cache) then
		return true
	end

	local src, dst = tostring(job.file.path), tostring(cache)
	local w, h = rt.preview.max_width, rt.preview.max_height
	local cmd
	if job.args.pdf then
		cmd = Command("osascript"):arg({ "-l", "JavaScript", "-e", PDF, src, job.skip, dst, w, h })
	else
		local tool = job.args.sips and "sips" or "ql"
		cmd = Command("sh"):arg({ "-c", SH, "sh", tool, src, dst, math.max(w, h), rt.preview.image_quality })
	end

	local output, err = cmd:output()
	if not output then
		return true, Err("Failed to start preview command, error: %s", err)
	elseif not output.status.success then
		return true, Err("Failed to render preview, stderr: %s", output.stderr)
	end
	return true, nil, tonumber(output.stdout)
end

return M
