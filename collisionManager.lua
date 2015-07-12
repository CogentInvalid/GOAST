--functions for identifying certain kinds of object.

local bump = require "libs/bump"

collisionManager = class:new()

function collisionManager:init(parent)

	self.id = "collisionManager"
	self.game = parent

	self.world = bump.newWorld() --a "world" to keep track of all objects and detect collisions.

end

function collisionManager:resetWorld()
	self.world = {}
	self.world = bump.newWorld()
end

function collisionManager:addEnt(entity, x, y, w, h)
	--add an entity to the world
	self.world:add(entity, x, y, w, h)
end

function collisionManager:removeEnt(entity)
	self.world:remove(entity)
end

function collisionManager:moveEnt(entity, x, y, w, h)
	self.world:move(entity, x, y, w, h)
end

function collisionManager:update(dt)

end

function collisionManager:isReal(ent)
	return true
end

--collision functions
function collisionManager:collide(ent1, collideOrder)
	for n,cond in ipairs(collideOrder) do
		col = self:detectCollisions(ent1, cond)
		for i=1, #col do
			local dir = col[i][1]
			local ent2 = col[i][2]
			--do collisions
			if ent1.resolveCollision ~= nil then ent1:resolveCollision(ent2, dir) end
			--for i, comp in ipairs(ent1.component) do
			--	if comp.resolveCollision ~= nil then comp:resolveCollision(comp, ent2, dir) end
			--end
		end
	end
end

function collisionManager:detectCollisions(e1, cond) --collisions for all the things* (*that are rectangles)
	local all = {}
	local counter = {}
	local cols, len = self.world:queryRect(e1.phys.x-8, e1.phys.y-8, e1.phys.w+16, e1.phys.h+16)
	for i,e2 in ipairs(cols) do
		counter[i] = 0
		if cond(e2) and e1 ~= e2 then

			--find collision direction
			if e1.phys.y+e1.phys.h>e2.phys.y and e1.phys.y<e2.phys.y+e2.phys.h then --left/right
				if e1.phys.px+e1.phys.w <= e2.phys.px and e1.phys.x+e1.phys.w > e2.phys.x then --left
					all[i] = ({"left",e2})
					counter[i] = counter[i] + 1
				end
				if e1.phys.px >= e2.phys.px+e2.phys.w and e1.phys.x < e2.phys.x+e2.phys.w then --right
					all[i] = ({"right",e2})
					counter[i] = counter[i] + 1
				end
			end
			if e1.phys.x+e1.phys.w>e2.phys.x and e1.phys.x<e2.phys.x+e2.phys.w then --up/down
				if e1.phys.py+e1.phys.h <= e2.phys.py and e1.phys.y+e1.phys.h > e2.phys.y then --from above
					all[i] = ({"up",e2})
					counter[i] = counter[i] + 1
				end
				if e1.phys.py >= e2.phys.py+e2.phys.h and e1.phys.y < e2.phys.y+e2.phys.h then --below
					all[i] = ({"down",e2})
					counter[i] = counter[i] + 1
				end
			end
			if counter[i] == 0 then --already inside
				if e1.phys.y+e1.phys.h>e2.phys.y and e1.phys.y<e2.phys.y+e2.phys.h and e1.phys.x+e1.phys.w>e2.phys.x and e1.phys.x<e2.phys.x+e2.phys.w then
					all[i] = ({"in",e2})
					counter[i] = counter[i] + 1
				end
			end
		end
	end

	local priority = false
	for i=1, len do
		if counter[i] == 1 then priority = true end
		--ignore all double collisions as long as there is at least one single collision
		--also, ignore all single collisions as long as there is at least one slope collision??????
	end
	local finalCols = {}
	for i=1, len do
		if counter[i] == 1 then finalCols[#finalCols+1] = all[i] end
		if counter[i] > 1 and priority == false then finalCols[#finalCols+1] = all[i] end
	end
	
	return finalCols
end