local rect = {}

---todo:
---ehhh we don't need this until we need cliprect
---even then the math for that could just be inlined?
---although it is needed at some point smh

function rect.bottom(self, value)
	if value then
		self.h = value - self.y
	end

	return self.y+self.h
end

function rect.XYXY(self)
	return self.x,self.y,self.w+self.x,self.h+self.y
end