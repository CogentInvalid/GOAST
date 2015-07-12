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

	self.die = false --should this entity be destroyed next frame?
end

function ghost:update(dt)

	--update all components
	for i,comp in ipairs(self.component) do
		comp:update(dt)
	end

	--wait a second before repossessing something
	self.possessTimer = self.possessTimer - dt
	if self.possessTimer < 0 then self.possessTimer = 0 end

	--movement
	local speed = 180; local accel = 2
	local xMove = 0; local yMove = 0

	if keyDown("up") then yMove = -(self.phys.vy+speed)*accel*dt end
	if keyDown("down") then yMove = -(self.phys.vy-speed)*accel*dt end
	if keyDown("left") then xMove = -(self.phys.vx+speed)*accel*dt end
	if keyDown("right") then xMove = -(self.phys.vx-speed)*accel*dt end
	self.phys:addVel(xMove, yMove)

	--possession
	if keyDown("z") then

		--find target
		local nearest = 9999
		local t = false
		for i,entity in ipairs(gameMode.ent) do
			if entity.id == "enemy" or entity.id == "player" then
				local x = entity.phys.x; local y = entity.phys.y
				if magnitude(self.phys.x - x, self.phys.y - y) < nearest then
					t = entity
					nearest = magnitude(self.phys.x - x, self.phys.y - y)
				end
			end
		end

		--move to target
		local x = t.phys.x; local y = t.phys.y
		if magnitude(self.phys.x - x, self.phys.y - y) < 80 and self.possessTimer <= 0 then
			local ang = angle:new({x-self.phys.x, y-self.phys.y})
			self.phys:addVel(ang.xPart*150*dt, ang.yPart*150*dt)
			self.phys:addPos(ang.xPart*20*dt, ang.yPart*20*dt)

			--possess target
			if magnitude(self.phys.x - x, self.phys.y - y) < 2 then
				self.die = true
				if t.id == "player" then t.alive = true end
				if t.id == "enemy" then t.possessed = true end
			end
		end
	end

	--tether to player
	local x = gameMode.p.phys.x; local y = gameMode.p.phys.y
	local dist = magnitude(self.phys.x - x, self.phys.y - y)
	if dist > 350 then
		local ang = angle:new({x-self.phys.x, y-self.phys.y})
		self.phys:addVel(ang.xPart*dist*0.8*dt, ang.yPart*dist*0.8*dt)
	end

	--restrict to level bounds
	if self.phys.x < 0 then self.phys.x = 0 end
	if self.phys.x+self.phys.w > 800 then self.phys.x = 800-self.phys.w end
	if self.phys.y < 0 then self.phys.y = 0 end
	if self.phys.y+self.phys.h > 600 then self.phys.y = 600-self.phys.h end

	--friction
	self.phys:addVel(-self.phys.vx*1.8*dt, -self.phys.vy*1.8*dt, 0)

end

function ghost:draw()

	love.graphics.setColor(80,200,200,200)
	love.graphics.rectangle("fill", self.phys.x, self.phys.y, self.phys.w, self.phys.h)

end

function ghost:resolveCollision(entity, dir)
	--if entity.id == "tile" and (not keyDown("e")) then self.phys:hitSide(entity, dir) end
end