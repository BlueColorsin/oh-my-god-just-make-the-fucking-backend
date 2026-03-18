local assets = require("assets")
local camera = require("camera")
local stage = require("utility.stage")

local graphics = love.graphics
local rad = math.rad
local function draw_frame(frame, sfx, sfy)
	local cam = camera.current
	graphics.push()

	sfx, sfy = 1-(sfx or 1), 1-(sfy or 1)

	graphics.applyTransform(-cam.ox*sfx, -cam.oy*sfy, 0, 1, 1, frame.ox, frame.oy)
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

	draw = function (self, yield)
		local framehash = self.atlas.hash

		yield("background")

		local angle = 0
		stage.drawFrame(framehash["bgWalls"], 0,0, .9, 1, angle)

		stage.drawFrame(framehash["bgEscalator"], 0,0, .95, 1, angle)

		stage.drawFrame(framehash["christmasTree"], 0,0, 1, angle)

		yield("spectator")
		yield("opponent")
		yield("player")

		stage.drawFrame(framehash["fgSnow"], 0,0, 1, 1, angle)

		stage.drawFrame(self.atlas[self.santaIndices[self.santaIndex]], 0,0, 1.05, 1, angle)

		yield("foreground")
	end
}
