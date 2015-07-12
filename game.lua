require "camera"
require "/ent/player"
require "/ent/tile"
require "collisionManager"
require "levelManager"

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

	self.component = {}
	self.component[#self.component+1] = camera:new(self)
	self.cam = self:getComp("camera")
	self.component[#self.component+1] = collisionManager:new(self)
	self.colMan = self:getComp("collisionManager")
	self.component[#self.component+1] = levelManager:new(self)
	self.levMan = self:getComp("levelManager")

	self.ent = {}

	self.p = self:addEnt(player, {10, 10})

	self.levMan:loadLevel("level")

	--self:addEnt(tile, {50, 50})

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

		--collide stuff
		for i=1, #self.ent do
			if self.ent[i].phys.col then self.colMan:collide(self.ent[i], self.ent[i].phys.collideOrder) end
		end

		accum = accum - 0.01
	end
	if accum>0.1 then accum = 0 end

end

function game:draw()
	self.cam.cam:draw(function(l,t,w,h)
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
end

function game:keypressed(key)

end

function game:mousepressed(x, y, button)

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
	table.remove(ent, i)
	--table.remove(rcol, i)
end

function game:getComp(name) --locate a component by name.
	for i=1, #self.component do
		if self.component[i].id == name then
			return self.component[i]
		end
	end
	return false
end