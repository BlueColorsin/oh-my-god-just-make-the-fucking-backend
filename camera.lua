local camera = {
	cameras = {}
}

function camera.new(x,y,w,h)
	return {
		__type = "camera",

		x = x or 0, y = y or 0,

		w = w or 960,
		h = h or 720
	}
end



return camera