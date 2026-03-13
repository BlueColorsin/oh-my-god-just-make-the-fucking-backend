local assets = require("assets")

local index = 1
function love.load()
	johnatlas = assets.atlas("BOYFRIEND")

end

local timer = 0

-- function love.update(dt)
-- 	if timer >= 1/24 then
-- 		index = (index%(#johnatlas))+1
-- 		timer = 0
-- 	end
-- 	timer = timer + dt
-- end

---@type love.keypressed
function love.keypressed(key)
	if key == "right" then
		index = (index%(#johnatlas))+1
	elseif key == "left" then
		index = (index%(#johnatlas))-1
	end
end

local rad = math.rad
function love.draw()
	local frame = johnatlas[index]
	local r = (frame.rotation == 4) and rad(270) or 0

	local fx, fy = frame.ox, frame.oy
	local x,y,sx,sy,ox,oy = 200,200,2,2,100,100

	local graphics = love.graphics

	---valid code I guess?
	graphics.applyTransform(0, 0, 0, 1, 1, fx, fy)
	graphics.rotate(r)

	---graphics.applyTransform(x+ox, y+oy, rad(angle), sx, sy, ox+fx, oy+fy)
	---graphics.rotate(r)

	love.graphics.draw(johnatlas.texture, frame.quad)
end

