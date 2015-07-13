objectiveManager = class:new()

function objectiveManager:init(parent)
	self.id = "objectiveManager"

	self.obj1 = 70
	self.obj2 = 80

	self.score = 0
	self.time = 0

	self.parent = parent
end

function objectiveManager:update(dt)

	if gameMode.playing then self.time = self.time + dt end
	self.score = math.floor(self.time)

	self.obj1 = self.obj1 - 0.75*dt
	self.obj2 = self.obj2 - 0.75*dt

	if self.obj1 <= 0 or self.obj2 <= 0 then self.parent.p:death() end

end

function objectiveManager:draw()
	love.graphics.setColor(255,0,0, 200)
	love.graphics.rectangle("fill", 30 + 365-(self.obj1/120)*360, 575, (self.obj1/120)*360, 20)
	love.graphics.rectangle("fill", 410, 575, (self.obj2/120)*360, 20)

	love.graphics.setColor(0,0,0)
	love.graphics.print(self.score, 400+2, 20+2, 0, 1, 1)
	love.graphics.setColor(255,0,0)
	love.graphics.print(self.score, 400, 20, 0, 1, 1)
end

function objectiveManager:getBrightness()
	local x = self.obj1
	if self.obj2 < self.obj1 then
		x = self.obj2
	end
	x = x/120+0.2
	if x > 1 then x = 1 end
	return x
end

function objectiveManager:addCharge(num)
	if num == 1 then
		self.obj1 = self.obj1 + 30*0.05
		if self.obj1 > 120 then self.obj1 = 120 end
	end
	if num == 2 then
		self.obj2 = self.obj2 + 30*0.05
		if self.obj2 > 120 then self.obj2 = 120 end
	end
end