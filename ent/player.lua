require "comp/physics"

player = class:new()

function player:init(args)
	local x=args[1]; local y=args[2]

	self.id = "player"
	--self.drawLayer = "front"

	self.component = {}

	--phys component
	self.phys = physics:new(self, x, y, 16, 16)
	self.component[#self.component+1] = self.phys

	self.alive = true --is not a ghoooost?

	self.die = false --should this entity be destroyed next frame?
end

function player:update(dt)

	--update all components
	for i,comp in ipairs(self.component) do
		comp:update(dt)
	end

	local speed = 180; local accel = 5

	--movement
	local xMove = 0; local yMove = 0

	if self.alive then
		if keyDown("w") then yMove = -(self.phys.vy+speed)*accel*dt end
		if keyDown("s") then yMove = -(self.phys.vy-speed)*accel*dt end
		if keyDown("a") then xMove = -(self.phys.vx+speed)*accel*dt end
		if keyDown("d") then xMove = -(self.phys.vx-speed)*accel*dt end
	end
	self.phys:addVel(xMove, yMove)

	--friction
	self.phys:addVel(-self.phys.vx*3*dt, -self.phys.vy*3*dt, 0)

end

function player:draw()

	love.graphics.setColor(0,255,0)
	if not self.alive then love.graphics.setColor(20,100,20) end
	love.graphics.rectangle("fill", self.phys.x, self.phys.y, self.phys.w, self.phys.h)

end

function player:resolveCollision(entity, dir)
	if entity.id == "tile" and (not keyDown("e")) then self.phys:hitSide(entity, dir) end
end