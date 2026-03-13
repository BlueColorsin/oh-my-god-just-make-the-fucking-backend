local json = require "json"

---designed to store and hold data for rendering frames of an atlas
local atlas = {
	ROTATION_0 = 0,
	ROTATION_90 = 90,
	ROTATION_180 = 180,
	ROTATION_270 = 270,
}

---@class atlas

---@alias atlasConstructor fun(data:table, texture:love.Image):atlas

function atlas.getRotation(frame)
	
end

--[[BASIC WAY OF RENDERING A FRAME!
	local fx, fy = frame.ox, frame.oy
	local x,y,sx,sy,ox,oy,r = 200,200,2,2,100,100,20

	love.graphics.applyTransform(x+ox, y+oy, math.rad(r), sx, sy, ox+fx, oy+fy)
	love.graphics.rotate(math.rad(atlas.rotation))
--]]

function atlas.fromJson(data, texture)
	return {
		__type = "atlas",

		maxW=0,
		maxH=0,

		tags = {},
		texture = texture
	}
end

local max = math.max
local new_quad = love.graphics.newQuad
local table_insert = table.insert

---@type atlasConstructor
function atlas.fromSparrow(data, texture)
	local function is_tag(list, tag)
		return type(list) == "table" and list.label == tag
	end

	local textureAtlas
	for _,value in ipairs(data) do
		if is_tag(value, "TextureAtlas") then
			textureAtlas = value
		end
	end

	---used to detect and store identical quads to not waste memory
	local quadhash = {}

	---used to store indices of exactly identical frames
	local framehash = {}

	local frames = {
		__type = "atlas",

		maxW=0,
		maxH=0,

		tags = {},
		texture = texture
	}

	local tags = frames.tags

	table.sort(textureAtlas, function (a,b)
		return (is_tag(a, "SubTexture") and is_tag(b, "SubTexture")) and (a.arg.name < b.arg.name)
	end)

	local index
	for frame in function()
		local frame
		index,frame=next(textureAtlas, index)
		::retry::
		if is_tag(frame, "SubTexture") then
			return frame.arg
		elseif index then
			index,frame = next(textureAtlas, index)
			goto retry
		end
	end do
		local quad, key, name
		key = frame.x..","..frame.y..","..frame.width..","..frame.height
		if quadhash[key] then
			quad = quadhash[key]
		else
			quad = new_quad(frame.x,frame.y,frame.width,frame.height,texture)
			quadhash[key] = quad
		end

		name = string.sub(frame.name, 0, #frame.name-4)
		if not tags[name] then
			tags[name] = {}
		end

		---because of the fact that we know that there are no 2 identical quads we can just use the memory address
		key = tostring(frame.rotated)..","..tostring(frame.frameX)..","..tostring(frame.frameY)
			..","..tostring(frame.frameWidth)..","..tostring(frame.frameHeight)..tostring(quad)

		if framehash[key] then
			table_insert(tags[name], framehash[key])
			goto continue
		end

		framehash[key] = #frames+1
		table_insert(tags[name], #frames+1)

		table_insert(frames, {
			__type = "frame",

			quad = quad,

			ox = frame.frameX or 0,
			oy = (frame.frameY or 0) - (frame.rotated and frame.width or 0),

			w = frame.width, h = frame.height,

			rotation = frame.rotated and atlas.ROTATION_270 or atlas.ROTATION_0,

			---width of the source frame
			sw = frame.frameWidth or frame.width,
			sh = frame.frameHeight or frame.height,

			texture = texture,
		})

		frames.maxW = max(frames[#frames].w, frames.maxW)
		frames.maxH = max(frames[#frames].h, frames.maxH)

		::continue::
	end

	return frames
end

---@type table<string, table<atlasConstructor, string>>
atlas.types = {
	sparrow = {atlas.fromSparrow, "xml"},
}

return atlas
