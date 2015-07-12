objectiveManager = class:new()

function objectiveManager:init(parent)
	self.id = "objectiveManager"

	self.obj1 = 90
	self.obj2 = 90

	self.parent = parent
end

function objectiveManager:update(dt)

	self.obj1 = self.obj1 - dt
	self.obj2 = self.obj2 - dt

end

function objectiveManager:draw()
	love.graphics.setColor(255,0,0)
	love.graphics.rectangle("fill", 30 + 360-(self.obj1/90)*360, 570, (self.obj1/90)*360, 20)
	love.graphics.rectangle("fill", 410, 570, (self.obj2/90)*360, 20)
end

function objectiveManager:addCharge(num)
	if num == 1 then self.obj1 = 90 end
	if num == 2 then self.obj2 = 90 end
end