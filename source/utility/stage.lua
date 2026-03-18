local camera = require("camera")

local stage = {
}

local rad = math.rad
local graphics = love.graphics

---utility for stages that draws a singular frame
---meant to be for stage atlases where the frames are parts of the stage
function stage.drawFrame(frame, x,y,scrollFactorX, scrollFactorY,angle,sx,sy,ox,oy)
	---used for scroll factoring
	local current = camera.current or camera.default

	ox,oy = ox or frame.sw/2, oy or frame.sw/2
	x = (x or 0) - current.ox*(1 - (scrollFactorX or 1)) + ox
	y = (y or 0) - current.oy*(1 - (scrollFactorY or 1)) + oy

	graphics.push()

	graphics.applyTransform(x, y, rad(angle or 0), sx, sy, frame.ox + ox, frame.oy + oy)
	graphics.rotate(rad(frame.rotation))

	graphics.draw(frame.texture, frame.quad)

	graphics.pop()
end

return stage