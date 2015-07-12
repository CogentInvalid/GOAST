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
				if r==0 then
					self.parent:addEnt(tile, {x*20, y*20})
				end
			end
		end
	end
	self.l = left; self.r = right; self.t = top; self.b = bottom
end