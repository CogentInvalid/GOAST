require "comp/physics"

ghost = class:new()

function ghost:init(args)
	local x=args[1]; local y=args[2]

	self.id = "ghost"
	--self.drawLayer = "front"

	self.component = {}

	--phys component
	self.phys = physics:new(self, x, y, 24, 24)
	self.component[#self.component+1] = self.phys

	self.possessTimer = 0.8

	self.img = img["player-ghost-spritesheet"]
	self.quad = {}
	self.quad["d"] = love.graphics.newQuad(0, 0, 16, 16, 64, 16)
	self.quad["u"] = love.graphics.newQuad(16, 0, 16, 16, 64, 16)
	self.quad["l"] = love.graphics.newQuad(32, 0, 16, 16, 64, 16)
	self.quad["r"] = love.graphics.newQuad(48, 0, 16, 16, 64, 16)
	self.dir = "d"

	self.die = false --should this entity be destroyed next frame?
end

function ghost:update(dt)

	gameMode.cam.target = self

	--update all components
	for i,comp in ipairs(self.component) do
		comp:update(dt)
	end

	--wait a second before repossessing something
	self.possessTimer = self.possessTimer - dt
	if self.possessTimer < 0 then self.possessTimer = 0 end

	--movement
	local speed = 180; local accel = 2.5
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
		if magnitude(self.phys.x - x, self.phys.y - y) < 120 and self.possessTimer <= 0 then
			local ang = angle:new({x-self.phys.x, y-self.phys.y})
			self.phys:addVel(ang.xPart*180*dt, ang.yPart*180*dt)
			self.phys:addPos(ang.xPart*30*dt, ang.yPart*50*dt)

			if magnitude(self.phys.x - x, self.phys.y - y) < 20 then
				self.phys:addPos(ang.xPart*30*dt, ang.yPart*50*dt)
			end

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
	if self.phys.x+self.phys.w > 1600 then self.phys.x = 1600-self.phys.w end
	if self.phys.y < 0 then self.phys.y = 0 end
	if self.phys.y+self.phys.h > 600 then self.phys.y = 600-self.phys.h end

	--friction
	self.phys:addVel(-self.phys.vx*1.5*dt, -self.phys.vy*1.5*dt, 0)

	--animation
	if math.abs(self.phys.vx) > math.abs(self.phys.vy) then
		if self.phys.vx > 0 then self.dir = "r" end
		if self.phys.vx < 0 then self.dir = "l" end
	end
	if math.abs(self.phys.vy) > math.abs(self.phys.vx) then
		if self.phys.vy > 0 then self.dir = "d" end
		if self.phys.vy < 0 then self.dir = "u" end
	end

end

function ghost:draw()

	love.graphics.setColor(80,200,200,200)
	--love.graphics.rectangle("fill", self.phys.x, self.phys.y, self.phys.w, self.phys.h)

	love.graphics.setColor(255,255,255,150)
	love.graphics.draw(self.img, self.quad[self.dir], math.floor(self.phys.x-4), math.floor(self.phys.y-4), 0, 2, 2)

end

function ghost:resolveCollision(entity, dir)
	--if entity.id == "tile" and (not keyDown("e")) then self.phys:hitSide(entity, dir) end
end