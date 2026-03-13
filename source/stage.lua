local assets = require("assets")

love.graphics.setPointSize(4)

local graphics = love.graphics
local rad = math.rad
local function draw_frame(frame, camera, sfx, sfy)
	graphics.push()

	sfx, sfy = 1-(sfx or 1), 1-(sfy or 1)

	graphics.applyTransform(-camera.ox*sfx, -camera.oy*sfy, 0, 1, 1, frame.ox, frame.oy)
	graphics.rotate(rad(frame.rotation))

	graphics.draw(frame.texture, frame.quad)

	graphics.pop()
end

return {
	__type = "stage",

	atlas = nil,

	santaIndex = 1,
	santaIndices = nil,

	timer = 0,

	load = function (self)
		self.atlas = assets.atlas("mall-atlas")

		self.santaIndices = self.atlas.tags["santa"]
	end,

	update = function (self, dt)
		if self.timer >= 1/24 then
			self.santaIndex = (self.santaIndex%#self.santaIndices)+1
			self.timer = 0
		end

		self.timer = self.timer + dt
	end,

	draw = function (self, camera)
		local framehash = self.atlas.hash

		draw_frame(framehash["bgWalls"], camera, .9, .9)

		draw_frame(framehash["bgEscalator"], camera, .95, .95)

		draw_frame(framehash["fgSnow"], camera)

		draw_frame(framehash["christmasTree"], camera)

		draw_frame(self.atlas[self.santaIndices[self.santaIndex]], camera, 1.05, 1.05)
	end
}