local gamera = require "libs/gamera" --game camera lib
camera = class:new()

function camera:init(parent)
	self.id = "camera"
	self.game = parent

	self.camBorder = 0
	self.cam = gamera.new(0-self.camBorder,0-self.camBorder,2000,1750)
	self.cam:setScale(1)
	self.cam:setPosition(0,0)
	self.screenShake = 0

	self.x = self.cam.x
	self.y = self.cam.y

	self.active = false

end

function camera:update(dt)
	local p = self.game.p
	if self.active then
		self.x = self.x - (self.x-p.physics.x)*5*dt
		self.y = self.y - (self.y-p.physics.y)*5*dt

		local s = self.cam:getScale()
		if s < 1 then self.cam:setScale(s+(0.8-s)*0.5*dt) end

		if love.keyboard.isDown("z") then
			local amt = 0.2
			if (s-1) <= 0.2 then amt = (s-1) end
			self.cam:setScale(s-amt*dt)
		end
	end
	if self.screenShake > 0 then
		self.x = self.x + math.random()*30*20*dt-(30*10*dt)
		 self.y = self.y + math.random()*30*20*dt-(30*10*dt)
	end
	self.screenShake = self.screenShake - dt
	if self.screenShake < 0 then self.screenShake = 0 end
	self.cam:setPosition(math.floor(self.x), math.floor(self.y))

	--if love.keyboard.isDown("r") then self.cam:setScale(0.2) end
end

function camera:zoomOut(amt)
	self.cam:setScale(self.cam:getScale()-(0.06*amt))
end

function camera:focus(dt)
	self.x = self.game.p.physics.x
	self.y = self.game.p.physics.y
	self.cam:setPosition(math.floor(self.x), math.floor(self.y))
end

function camera:levelLoaded(x,y,w,h)
	self.cam:setWorld(x,y,w,h)
end

function camera:levelChanged()

end