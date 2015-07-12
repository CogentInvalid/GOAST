require "comp/physics"
require "comp/fov"

enemy = class:new()

function enemy:init(args)
	local x=args[1]; local y=args[2]

	self.id = "enemy"
	--self.drawLayer = "front"

	self.component = {}

	--phys component
	self.phys = physics:new(self, x, y, 16, 16)
	self.component[#self.component+1] = self.phys
	self.fov = fov:new(self, 0, math.pi*2, 300)
	self.component[#self.component+1] = self.fov

	self.speed = 200
	self.moveTimer = 4
	self.moveDir = angle:new({1,0})
	self.moveDir:setTheta(math.random()*2*math.pi)

	self.shotsFired = 0
	self.shootTimer = 0.25
	self.burstTimer = 1.5

	self.possessed = false

	self.die = false --should this entity be destroyed next frame?
end

function enemy:update(dt)

	--update all components
	for i,comp in ipairs(self.component) do
		comp:update(dt)
	end

	--shooting
	local target = gameMode.p
	if self.possessed then
		--find target
		local nearest = 9999
		target = false
		for i,entity in ipairs(gameMode.ent) do
			if entity.id == "enemy" and entity ~= self then
				local x = entity.phys.x; local y = entity.phys.y
				if magnitude(self.phys.x - x, self.phys.y - y) < nearest then
					target = entity
					nearest = magnitude(self.phys.x - x, self.phys.y - y)
				end
			end
		end
	end

	if self.fov:isInFOV(target) then
		self.burstTimer = self.burstTimer - dt
	end
	if self.burstTimer <= 0 then
		self.shootTimer = self.shootTimer - dt
		if self.shotsFired >= 3 then self.burstTimer = 1.5; self.shotsFired = 0 end
	end
	if self.shootTimer <= 0 then
		self:shoot(target)
		self.shotsFired = self.shotsFired + 1
		self.shootTimer = 0.25
	end

	local speed = self.speed; local accel = 5

	--movement
	local xMove = 0; local yMove = 0

	if not self.possessed then
		xMove = self.moveDir.xPart * speed * dt
		yMove = self.moveDir.yPart * speed * dt
	else
		if keyDown("up") then yMove = -(self.phys.vy+speed)*accel*dt end
		if keyDown("down") then yMove = -(self.phys.vy-speed)*accel*dt end
		if keyDown("left") then xMove = -(self.phys.vx+speed)*accel*dt end
		if keyDown("right") then xMove = -(self.phys.vx-speed)*accel*dt end
	end
	self.phys:addVel(xMove, yMove)

	--self.moveDir = angle:new({self.phys.vx, self.phys.vy})

	--"ai"
	self.moveTimer = self.moveTimer - dt
	if self.moveTimer < 0 then
		self:changeMovement()
	end

	--friction
	self.phys:addVel(-self.phys.vx*3*dt, -self.phys.vy*3*dt, 0)

	--spawn ghost if possessed/dead
	if self.die and self.possessed then
		local g = gameMode:addEnt(ghost, {self.phys.x, self.phys.y})
		g.phys.vx = self.phys.vx * 2
		g.phys.vy = self.phys.vy * 2
	end

end

function enemy:shoot(target)
	local x = target.phys.x; local y = target.phys.y
	local ang = angle:new({x - self.phys.x, y - self.phys.y})
	ang:addTheta((math.random()-0.5)*0.5)
	local friendly = false
	local speed = 150
	if self.possessed then friendly = true; speed = 200 end
	gameMode:addEnt(bullet, {self.phys.x+4, self.phys.y+4, ang.xPart*speed, ang.yPart*speed, friendly})
end

function enemy:changeMovement()
	self.moveTimer = math.random(2,6)
	self.moveDir:addTheta((math.random()-0.5)*2*math.pi)
	self.speed = 200
end

function enemy:draw()

	love.graphics.setColor(255,0,0)
	if self.possessed then love.graphics.setColor(200, 20, 20) end
	love.graphics.rectangle("fill", self.phys.x, self.phys.y, self.phys.w, self.phys.h)

end

function enemy:resolveCollision(entity, dir)
	if entity.id == "tile" then
		if math.random(1,10) == 1 then
			self.phys:bounceSide(entity,dir,0.1)
		else
			self.phys:hitSide(entity, dir)
		end
		self.moveDir = angle:new({self.phys.vx, self.phys.vy})
		self.moveDir:addTheta((math.random()-0.5)*0.1)
		--self:changeMovement()
	end
	if entity.id == "bullet" then
		if entity.friendly and (not self.possessed) then
			self.die = true
			gameMode.spawnMan.enemies = gameMode.spawnMan.enemies - 1
		end
	end
end