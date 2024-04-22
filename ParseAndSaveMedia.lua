local json = require('dkjson')

pzPath = arg[1]

function loadMediaLuaFile()
	mediaLuaPath = pzPath .. "\\media\\lua\\shared\\RecordedMedia\\recorded_media.lua"
	dofile(mediaLuaPath)
end

function saveMediaTable()
	local js = json.encode(RecMedia, {indent = true})
	
	local output = io.open(arg[2] .. "\\intermediate.out", 'w')
	output:write(js)
	output:close()
end



loadMediaLuaFile()
saveMediaTable()