local camera = require("camera")
local graphics = love.graphics

local stage, paws
function love.load()
	-- stage = love.filesystem.load("assets/mall.lua")()
	-- stage:load()

	paws = love.filesystem.load("source/paws.lua")({"wasup gang!", "it's a me", "mexican luigi"})
	-- camera.default.oy = 500
end

local timer = 0

local target = 1

local lastX, lastY = 0,0

local camera_transform = nil
local totalX, totalY = 0,0

local get_position = love.mouse.getGlobalPosition
local get_time = love.timer.getTime
function love.update(dt)
	-- camera.default.ox = 500 + math.abs(math.sin(get_time()*(math.pi/10)) * 700)
	-- camera.default.zoom = math.larp(target, camera.default.zoom, math.exp(-dt * 4));

	-- camera.updateTransform()

	local transform = camera.default.transform

	

	if camera_transform then
		local mouseX,mouseY = camera_transform:inverseTransformPoint(get_position())
		local x,y = camera_transform:inverseTransformPoint(lastX, lastY)

		totalX, totalY = totalX-(x-mouseX), totalY-(y-mouseY)

		camera.default.transform = camera_transform:clone():translate(totalX, totalY)
	end

	lastX, lastY = get_position()
end

---@type love.mousepressed
function love.mousepressed(x,y,button)
	camera_transform = camera.default.transform:clone()
	totalX, totalY = 0,0
end

---@type love.mousereleased
function love.mousereleased(x,y,button)
	camera_transform = nil
end

---@type love.keypressed
function love.keypressed(key)
end

local x1, y1 = 0,0
local x2, y2 = 0,0

---@type love.wheelmoved
function love.wheelmoved(_, scrollY)
	-- paws.applyForce(y*10)

	--center transformation
	--translate	: w/2, h/2
	--scale 	: zoom
	--translate : -w/2,-h/2

	local cam = camera.default

	cam.zoom = cam.zoom + scrollY*.1

	local cx,cy = cam.cx + cam.w/2*cam.scale, cam.cy + cam.h/2*cam.scale

	cam.transform:scale(1 + scrollY*.1)
end

graphics.setPointSize(4)
function love.draw()
	camera.push()

	love.graphics.clear(.15,.15,.15)

	local cam = camera.default
	graphics.setColor(.25,.25,.25, 1)
	-- love.graphics.rectangle("fill", -4000 - cam.ox, -4000 - cam.oy, 8000, 8000)
	graphics.setColor(1,1,1,1)

	-- stage:draw(function() end)

	paws:draw()

	camera.pop()
	
	graphics.points(x1, y1, x2, y2)
	graphics.points(cam.cx + cam.w/2*cam.scale, cam.cy + cam.h/2*cam.scale)
end

---@type love.resize
function love.resize(h, w)
	camera.letterbox(h, w)
end
