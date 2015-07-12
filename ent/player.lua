require "comp/physics"

player = class:new()

function player:init(args)
	local x=args[1]; local y=args[2]

	self.id = "player"
	--self.drawLayer = "front"

	self.component = {}

	--phys component
	self.phys = physics:new(self, x, y, 24, 24)
	self.component[#self.component+1] = self.phys

	self.alive = true --is not a ghoooost?

	self.img = img["player-spritesheet"]
	self.quad = {}
	self.quad["d"] = love.graphics.newQuad(0, 0, 16, 16, 64, 16)
	self.quad["u"] = love.graphics.newQuad(16, 0, 16, 16, 64, 16)
	self.quad["l"] = love.graphics.newQuad(32, 0, 16, 16, 64, 16)
	self.quad["r"] = love.graphics.newQuad(48, 0, 16, 16, 64, 16)
	self.dir = "d"

	self.die = false --should this entity be destroyed next frame?
end

function player:update(dt)

	if self.alive then gameMode.cam.target = self end

	--update all components
	for i,comp in ipairs(self.component) do
		comp:update(dt)
	end

	local speed = 200; local accel = 5

	--movement
	local xMove = 0; local yMove = 0

	if self.alive then
		if keyDown("up") then yMove = -(self.phys.vy+speed)*accel*dt end
		if keyDown("down") then yMove = -(self.phys.vy-speed)*accel*dt end
		if keyDown("left") then xMove = -(self.phys.vx+speed)*accel*dt end
		if keyDown("right") then xMove = -(self.phys.vx-speed)*accel*dt end
	end
	self.phys:addVel(xMove, yMove)

	--friction
	self.phys:addVel(-self.phys.vx*3*dt, -self.phys.vy*3*dt, 0)

	if math.abs(self.phys.vx) > math.abs(self.phys.vy) then
		if self.phys.vx > 0 then self.dir = "r" end
		if self.phys.vx < 0 then self.dir = "l" end
	end
	if math.abs(self.phys.vy) > math.abs(self.phys.vx) then
		if self.phys.vy > 0 then self.dir = "d" end
		if self.phys.vy < 0 then self.dir = "u" end
	end

	if not self.alive then self.img = img["player-spritesheet-sleep"]
		else self.img = img["player-spritesheet"] end

end

function player:draw()

	love.graphics.setColor(0,255,0)
	if not self.alive then love.graphics.setColor(20,100,20) end
	--love.graphics.rectangle("fill", self.phys.x, self.phys.y, self.phys.w, self.phys.h)

	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.img, self.quad[self.dir], math.floor(self.phys.x-4), math.floor(self.phys.y-4), 0, 2, 2)

end

function player:resolveCollision(entity, dir)
	if (entity.id == "tile" or entity.id == "objective") and (not keyDown("e")) then self.phys:hitSide(entity, dir) end
	if entity.id == "bullet" then
		if not entity.friendly then crash("YA DONE DIED SON") end
	end
	if entity.id == "enemy" then
		crash("YA DONE DIED SON")
	end
	if entity.id == "objective" then
		gameMode.objMan:addCharge(entity.num)
	end
end