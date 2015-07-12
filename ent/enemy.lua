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
	self.fov = fov:new(self, 0, math.pi*2, 200)
	self.component[#self.component+1] = self.fov

	self.speed = 200
	self.moveTimer = 4
	self.moveDir = angle:new({1,0})

	self.possessed = false

	self.die = false --should this entity be destroyed next frame?
end

function enemy:update(dt)

	--update all components
	for i,comp in ipairs(self.component) do
		comp:update(dt)
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

	--die if you see the player
	if self.fov:isInFOV(gameMode.p) then
		local x = gameMode.p.phys.x; local y = gameMode.p.phys.y
		local ang = angle:new({x - self.phys.x, y - self.phys.y})
		gameMode:addEnt(bullet, {self.phys.x, self.phys.y, ang.xPart*200, ang.yPart*200, false})
	end

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
end