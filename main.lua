local assets = require("assets")
local camera = require("camera")

local defaultCamera
local sprite
local i_heart_boys
local frameIndex = 1

local stage
function love.load()
	stage = love.filesystem.load("source/stage.lua")()
	stage:load()

	sprite = assets.atlas("furblue")
	i_heart_boys = assets.texture("I heart boys")
end

local timer = 0

local get_time = love.timer.getTime
function love.update(dt)
	-- if timer >= 1/12 then
	-- 	frameIndex = (frameIndex%#sprite)+1
	-- 	timer = 0
	-- end
	-- timer = timer + dt

	camera.default.ox = math.sin(get_time()*(math.pi/5)) * 500
	-- camera.default.oy = math.tan(get_time()*(math.pi/5)) * 100

	stage:update(dt)

	camera.default.zoom = .25
end

---@type love.keypressed
function love.keypressed(key)
end

function love.draw()
	camera.push()

	love.graphics.clear(.15,.15,.15)

	local cam = camera.default
	love.graphics.setColor(.25,.25,.25)
	love.graphics.rectangle("fill", -4000 - cam.ox, -4000 - cam.oy, 8000, 8000)
	love.graphics.setColor(1,1,1,1)

	stage:draw(camera.default)
	
	camera.pop()
	-- love.graphics.draw(i_heart_boys, 0, 0, 0, 1.5, 1.5)

	-- local frame = sprite[frameIndex]
	-- love.graphics.draw(frame.texture, frame.quad, -frame.ox - cam.ox*.5, -frame.oy - cam.oy*.5, math.rad(frame.rotation))


end

---@type love.resize
function love.resize(h, w)
	camera.letterbox(h, w)
end
