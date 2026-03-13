---ugh I fucking hate needing to do this in every damn project 
love.filesystem.setRequirePath(
	love.filesystem.getRequirePath()..
	";source/?.lua;source/?/init.lua;"..
	"libraries/?.lua;libraries/?/init.lua;"
)

---@type love.conf
function love.conf(t)
	t.window.resizable = true
end

function math.lerp(a, b, t)
	return a + (b - a) * t
end

math.larp = math.lerp