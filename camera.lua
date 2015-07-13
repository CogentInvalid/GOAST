local gamera = require "libs/gamera" --game camera lib
camera = class:new()

function camera:init(parent)
	self.id = "camera"
	self.game = parent

	self.camBorder = 0
	self.cam = gamera.new(0-self.camBorder,0-self.camBorder,1600,600)
	self.cam:setScale(1)
	self.cam:setPosition(0,0)
	self.screenShake = 0

	self.zooming = false

	self.x = self.cam.x
	self.y = self.cam.y

	self.target = nil

	self.active = true

end

function camera:update(dt)

	if self.target == nil then self.target = self.game.p end

	local p1 = self.game.p
	local p2 = self.target

	tx = (p1.phys.x+p2.phys.x)/2
	ty = (p1.phys.y+p2.phys.y)/2

	if self.active then
		self.x = self.x - (self.x-tx)*5*dt
		self.y = self.y - (self.y-ty)*5*dt

		local s = self.cam:getScale()
		if self.zooming then
			self.cam:setScale(s + (2-s)*dt)
		end
		if s < 1 then self.cam:setScale(s+(0.8-s)*0.5*dt) end

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
	self.x = self.game.p.phys.x
	self.y = self.game.p.phys.y
	self.cam:setPosition(math.floor(self.x), math.floor(self.y))
end

function camera:levelLoaded(x,y,w,h)
	self.cam:setWorld(x,y,w,h)
end

function camera:levelChanged()

end