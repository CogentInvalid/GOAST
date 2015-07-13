levelManager = class:new()

function levelManager:init(parent)
	self.id = "levelManager"

	self.l = 0; self.r = 0
	self.t = 0; self.b = 0

	self.parent = parent
end

function levelManager:update(dt)

end

function levelManager:loadLevel(name)
	local objectiveCount = 1
	local left = 99999; local top = 99999
	local right = 0; local bottom = 0
	if love.filesystem.exists(name..".png") then
		local level = love.image.newImageData(name..".png")
		local r = 0
		local g = 0
		local b = 0
		for i=1, level:getWidth() do
			for j=1, level:getHeight() do
				local x = i-1; local y = j-1
				r, g, b = level:getPixel(x,y)
				if r==0 and g==0 and b==0 then
					self.parent:addEnt(tile, {x*20, y*20, 0})
				end
				if r==255 and g==0 and b==0 then
					local spawn = self.parent.spawnMan
					spawn:addSpawnPoint(x*20+4, y*20+4)
				end
				if r==0 and g==0 and b==255 then
					self.parent:addEnt(objective, {x*20, y*20, objectiveCount})
					objectiveCount = objectiveCount + 1
				end
			end
		end
	end
	self.l = left; self.r = right; self.t = top; self.b = bottom
end