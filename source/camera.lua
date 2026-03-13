local camera = {
	cameras = {}
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

		scale = 1
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

function camera.push(self)
	self = self or camera.default

	love.graphics.push()
	love.graphics.translate(self.cx, self.cy)
	love.graphics.setScissor(self.cx, self.cy, love.graphics.getWidth() - 2 * self.cx, love.graphics.getHeight() - 2 * self.cy)
	love.graphics.scale(self.scale)
	love.graphics.translate(self.w/2, self.h/2)
	love.graphics.scale(self.zoom)
	love.graphics.translate(-self.w/2-self.ox, -self.h/2-self.oy)
end

function camera.pop(self)
	self = self or camera.default
	love.graphics.setScissor()
	love.graphics.pop()
end

camera.default = camera.new()
camera.insert(camera.default)

return camera