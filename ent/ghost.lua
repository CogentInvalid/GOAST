require "comp/physics"

ghost = class:new()

function ghost:init(args)
	local x=args[1]; local y=args[2]

	self.id = "ghost"
	--self.drawLayer = "front"

	self.component = {}

	--phys component
	self.phys = physics:new(self, x, y, 16, 16)
	self.component[#self.component+1] = self.phys

	self.possessTimer = 0.8

	self.alive = true --is not a ghoooost?

	self.die = false --should this entity be destroyed next frame?
end

function ghost:update(dt)

	--update all components
	for i,comp in ipairs(self.component) do
		comp:update(dt)
	end

	self.possessTimer = self.possessTimer - dt
	if self.possessTimer < 0 then self.possessTimer = 0 end

	local speed = 180; local accel = 2

	--movement
	local xMove = 0; local yMove = 0

	if self.alive then
		if keyDown("up") then yMove = -(self.phys.vy+speed)*accel*dt end
		if keyDown("down") then yMove = -(self.phys.vy-speed)*accel*dt end
		if keyDown("left") then xMove = -(self.phys.vx+speed)*accel*dt end
		if keyDown("right") then xMove = -(self.phys.vx-speed)*accel*dt end
	end
	self.phys:addVel(xMove, yMove)

	--possession
	if keyDown("z") then
		local x = gameMode.p.phys.x; local y = gameMode.p.phys.y
		if magnitude(self.phys.x - x, self.phys.y - y) < 80 and self.possessTimer <= 0 then
			local ang = angle:new({x-self.phys.x, y-self.phys.y})
			self.phys:addVel(ang.xPart*150*dt, ang.yPart*150*dt)
			self.phys:addPos(ang.xPart*20*dt, ang.yPart*20*dt)

			if magnitude(self.phys.x - x, self.phys.y - y) < 2 then
				self.die = true
				gameMode.p.alive = true
			end
		end
	end

	--restrict to level bounds
	if self.phys.x < 0 then self.phys.x = 0 end
	if self.phys.x+self.phys.w > 800 then self.phys.x = 800-self.phys.w end
	if self.phys.y < 0 then self.phys.y = 0 end
	if self.phys.y+self.phys.h > 600 then self.phys.y = 600-self.phys.h end

	--friction
	self.phys:addVel(-self.phys.vx*2*dt, -self.phys.vy*2*dt, 0)

end

function ghost:draw()

	love.graphics.setColor(80,200,200,200)
	love.graphics.rectangle("fill", self.phys.x, self.phys.y, self.phys.w, self.phys.h)

end

function ghost:resolveCollision(entity, dir)
	--if entity.id == "tile" and (not keyDown("e")) then self.phys:hitSide(entity, dir) end
end