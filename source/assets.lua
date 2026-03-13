local atlas = require("atlas")
local xml = require("xml")

---asset helper and cache system
local assets = {
	images = {},
	atlases = {},
}

function assets.get(path)
	return "assets/"..path
end
local get = assets.get


local new_texture = love.graphics.newTexture
function assets.texture(path)
	path = get(path..".png")
	if assets.images[path] then
		return assets.images[path]
	end

	assets.images[path] = new_texture(path)
	return assets.images[path]
end

local fs_read = love.filesystem.read
function assets.xml(path)
	return xml.decode(fs_read(get(path..".xml")))
end

function assets.atlas(path, type)
	if assets.atlases[path] then
		return assets.atlases[path]
	end

	type = atlas.types[type or "sparrow"]

	if not (type and assets[type[2]]) then
		return
	end

	local data = assets[type[2]](path)
	local texture = assets.texture(path)

	if not (data or texture) then
		return
	end

	assets.atlases[path] = type[1](data, texture)
	return assets.atlases[path]
end

return assets