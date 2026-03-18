local graphics = love.graphics

local arg = {...}

local paws = {
	w = 390, h = 520,

	oy = 0,

	padding = 20,
	selW = 15*2,

	selectionPadding = 20,
	curSelection = 0,
	selections = (function(list)
		list = list or {"Resume", "Restart", "Options", "Quit"}
		local options = {}

		for index, value in pairs(list) do
			options[index] = {
				name = value,

				state = 0,

				x1=0,y1=0,
				x2=0,y2=0,

				width = 0,
			}
		end

		return options
	end)(arg[1]),

	---@type love.Font
	font = graphics.setNewFont(50),
	---@type love.Font
	optionFont = graphics.setNewFont(30),
}

function paws:onSelection()
		
end

function paws:applyForce(dy)
	
end

function paws:drawSelections(w, h)
	local font = self.optionFont

	local selections = self.selections
	local padding = self.selectionPadding

	local font_h = font:getHeight()
	if ((#selections-1)*font_h + (#selections-1)*padding) > h then

	end

	for index, text in ipairs(selections) do
		graphics.print(text.name, font, (w - font:getWidth(text.name))/2, ((index-1)*font_h + (index-1)*padding))
	end
end

function paws:draw()
	local r,g,b,a = graphics.getColor()

	graphics.push()

	graphics.setColor(1,1,1,.25)

	graphics.rectangle("fill", 0, 0, self.w, self.h)

	local pausedW = self.font:getWidth("Paused")

	graphics.setColor(1,1,1,1)
	graphics.print("Paused", self.font, (self.w-pausedW)/2, self.padding)

	do
		local sizX,sizY,sizW,sizH = graphics.getScissor()

		local selW = (self.w-self.padding*2) - self.selW

		local x1,y1 = (self.w-selW)/2,self.font:getHeight()+self.padding*2
		local x2,y2 = x1 + selW, y1 + (self.h-y1-self.padding)

		local x,y,w,h = x1, y1, x2-x1, y2-y1

		x1, y1 = graphics.transformPoint(x1,y1)
		x2, y2 = graphics.transformPoint(x2,y2)
		graphics.intersectScissor(x1,y1,math.abs(x2-x1),math.abs(y2-y1))

		graphics.setColor(1,1,1,.25)

		graphics.translate(x,y)
		graphics.rectangle("fill", 0,0,w,h)

		graphics.setColor(1,1,1,1)
		self:drawSelections(w,h)

		graphics.setScissor(sizX,sizY,sizW,sizH)
	end

	graphics.setColor(r,g,b,a)

	graphics.pop()
end

return paws