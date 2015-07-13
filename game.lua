require "camera"
require "collisionManager"
require "levelManager"
require "spawnManager"
require "objectiveManager"
require "image"
require "/ent/player"
require "/ent/ghost"
require "/ent/enemy"
require "/ent/tile"
require "/ent/objective"
require "/ent/bullet"

game = class:new()

function game:init()

	--timestep related stuff
	dt = 0.01
	accum = 0
	frame = 0
	pause = false

	self:start()

end

function game:start()

	loadImages()

	self.component = {}

	self.cam = self:addComp(camera)
	self.colMan = self:addComp(collisionManager)
	self.levMan = self:addComp(levelManager)
	self.spawnMan = self:addComp(spawnManager)
	self.objMan = self:addComp(objectiveManager)

	self.ent = {}

	self.playing = true
	self.endTimer = 3

	self.p = self:addEnt(player, {25, 25})

	self.levMan:loadLevel("level")

	for i=1, 5 do
		self.spawnMan:spawn(250)
	end

end

function game:update(delta)

	if pause == false then accum = accum + delta end
	if accum > 0.05 then accum = 0.05 end
	while accum >= delta do

		--update components
		for i,comp in ipairs(self.component) do
			comp:update(dt)
		end

		--update entities
		for i,entity in ipairs(self.ent) do
			entity:update(dt)
			self.colMan:moveEnt(entity, entity.phys.px, entity.phys.py, entity.phys.w, entity.phys.h)
			if entity.die then self:removeEnt(entity, i) end
		end

		--update shader
		effect:send("x", self.p.phys.x-self.cam.cam.x+400)
		effect:send("y", 600-self.p.phys.y-self.cam.cam.y+300)
		effect:send("amt", self.objMan:getBrightness())

		--collide stuff
		for i=1, #self.ent do
			if self.ent[i].phys.col then self.colMan:collide(self.ent[i], self.ent[i].phys.collideOrder) end
		end

		--end game
		if not self.playing then
			self.endTimer = self.endTimer - dt
			if self.endTimer <= 0 then
				currentMode = lose
			end
		end

		accum = accum - 0.01
	end
	if accum>0.1 then accum = 0 end

end

function game:lose()
	self.cam.target = self.p
	self.cam.zooming = true
	for i,entity in ipairs(self.ent) do

		if entity.id == "ghost" then entity.die = true end
		if entity.id == "enemy" then entity.possessed = false end

	end
	self.playing = false
end

function game:draw()
	love.graphics.setShader(effect)
	self.cam.cam:draw(function(l,t,w,h)
		love.graphics.setColor(255,255,255)
		for i=1, 5 do
			for j=1, 2 do
				love.graphics.draw(img["tile-floor"], (i-1)*320, (j-1)*320, 0, 2, 2)
			end
		end
		--for i,layer in ipairs(self.drawOrder) do
			for j,entity in ipairs(self.ent) do
				--if entity.drawLayer == layer then
					if entity.phys.x ~= nil then
						if entity.phys.x+entity.phys.w > l and entity.phys.y+entity.phys.h > t
							and entity.phys.x < l+w and entity.phys.y < t+h then
							if entity.draw ~= nil then entity:draw() end
						end
					end
				--end
			end
		--end

	end)
	love.graphics.setShader()
	self.objMan:draw()
end

function game:keypressed(key)
	--become a goast
	if key == "z" then
		--leave player
		if self.p.alive then
			self.p.alive = false
			local g = self:addEnt(ghost, {self.p.phys.x, self.p.phys.y})
			g.phys.vx = self.p.phys.vx * 2
			g.phys.vy = self.p.phys.vy * 2
		end
		--leave possessed enemy
		for i,entity in ipairs(self.ent) do
			if entity.id == "enemy" then
				if entity.possessed then
					entity.possessed = false
					entity.lifeTimer = 20
					local g = self:addEnt(ghost, {entity.phys.x, entity.phys.y})
					g.phys.vx = entity.phys.vx * 2
					g.phys.vy = entity.phys.vy * 2
				end
			end
		end
	end
end

function game:mousepressed(x, y, button)
	self:addEnt(enemy, {x, y})
end

function game:addEnt(type, args)
	local entity = type:new(args)
	self.ent[#self.ent+1] = entity
	self.colMan:addEnt(entity, entity.phys.x, entity.phys.y, entity.phys.w, entity.phys.h)
	return entity
end

function game:removeEnt(entity, i)
	--for i, comp in ipairs(entity.component) do comp:die(entity) end
	self.colMan:removeEnt(entity)
	table.remove(self.ent, i)
	--table.remove(rcol, i)
end

function game:addComp(comp)
	self.component[#self.component+1] = comp:new(self)
	return self.component[#self.component]
end

function game:getComp(name) --locate a component by name.
	for i=1, #self.component do
		if self.component[i].id == name then
			return self.component[i]
		end
	end
	return false
end