local graphics = love.graphics

local width, height = 0,0

local camera = {
	cameras = {},

	current = nil,
}

---it's been awhile since I've last made a camera system lol

function camera.new(x,y,w,h)
	return {
		__type = "camera",

		---external viewport
		x = x or 0, y = y or 0,

		w = w or 960,
		h = h or 720,

		kx = 1,ky = 1,

		---internal viewport
		ox = 0, oy = 0,

		zoom = 1,
		angle = 0,

		---rendering

		cx = 0, cy = 0,

		scale = 1,

		transform = love.math.newTransform()
	}
end

function camera.insert(...)
	table.insert(camera.cameras, ...)
end

function camera.remove(...)
	table.remove(camera.cameras, ...)
end

function camera.update()
	
end

function camera.letterbox(w,h)
	width, height = w, h

	local sx, sy
	for index, cam in ipairs(camera.cameras) do
		sx = w / cam.w
		sy = h / cam.h

		if sx > sy then
			cam.scale = sy
			cam.cx, cam.cy = (w - cam.w * sy) / 2, 0
		else
			cam.scale = sx
			cam.cx, cam.cy = 0, (h - cam.h * sx) / 2
		end
	end
end

function camera.resize(self, w, h)

end

---todo:
local stack = {}

function camera.mouse()
	
end

--[[Small example that uses camera.updateTransform

	local get_position = love.mouse.getGlobalPosition
	local transform = camera.default.transform

	if love.mouse.isDown(3) then
		local mouseX,mouseY = transform:inverseTransformPoint(get_position())
		local x,y = transform:inverseTransformPoint(lastX, lastY)

		camera.default.ox = camera.default.ox + (x - mouseX)
		camera.default.oy = camera.default.oy + (y - mouseY)

		camera.updateTransform(camera.default)
	end

	lastX, lastY = get_position()

--]]

local rad = math.rad
function camera.updateTransform(self)
	self = self or camera.default
	---@type love.Transform
	local transform = self.transform

	---translate : cx, cy
	---scale	 : scale
	---translate : w/2, h/2
	---rotate	 : self.rotation
	---scale	 : zoom
	---translate : -w/2+ox, -h/2+oy

	transform:reset()
	local w,h,zoom,scale = self.w/2,self.h/2, self.zoom, self.scale
	transform:translate(self.cx+scale*(w-zoom), self.cy+scale*h)
	transform:scale(scale*zoom)
	transform:rotate(rad(self.angle))
	transform:translate(-w - self.ox, -h - self.oy)

	-- graphics.points()
end

function camera.push(self)
	self = self or camera.default

	camera.current = self

	graphics.push()
	graphics.intersectScissor(self.cx, self.cy, width - 2*self.cx, height - 2*self.cy)
	graphics.applyTransform(self.transform)
end

function camera.pop(self)
	self = self or camera.default

	graphics.setScissor()
	graphics.pop()
end

camera.default = camera.new()
camera.insert(camera.default)

return camera