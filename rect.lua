local rect = {}

function rect.bottom(self, value)
	if value then
		self.h = value - self.y
	end

	return self.y+self.h
end

function rect.XYXY(self)
	return self.x,self.y,self.w+self.x,self.h+self.y
end