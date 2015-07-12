--stuff that has position, width, height, and motion should have a physics component.

physics = class:new()

function physics:init(parent, x, y, w, h)
	self.parent = parent
	self.collideOrder = {self.isReal}

	self.x = x; self.y = y
	self.px = self.x; self.py = self.y
	self.w = w; self.h = h

	self.vx = 0
	self.vy = 0

	self.col = true --collisions enabled by default
end

function physics:isReal()
	return true
end

function physics:update(dt)
	self.px = self.x
	self.py = self.y
	
	self.x = self.x + self.vx*dt
	self.y = self.y + self.vy*dt

end

--change position by x and y pixels
function physics:addPos(x,y)
	self.x = self.x + x
	self.y = self.y + y
end

--change velocity by x and y pixels/second
function physics:addVel(x,y)
	self.vx = self.vx + x
	self.vy = self.vy + y
end

--set velocity directly
function physics:setVel(x,y)
	self.vx = x
	self.vy = y
end

--this just goes back to the parent's resolveCollision function.
function physics:resolveCollision(entity, dir)
	self.parent:resolveCollision(entity, dir)
end

--basic collision resolution
function physics:hitSide(ent, dir)
	if dir == "left" then self.x = ent.phys.x-self.w; self.vx = 0 end --hit from left
	if dir == "right" then self.x = ent.phys.x+ent.phys.w; self.vx = 0 end --from right
	if dir == "up" then self.y = ent.phys.y-self.h; self.vy = 0 end --hit from above
	if dir == "down" then self.y = ent.phys.y+ent.phys.h; self.vy = 0 end --below
end

function physics:bounceSide(ent, dir, c)
	if dir == "left" then self.x = ent.phys.x-self.w; self.vx = -self.vx*c end --hit from left
	if dir == "right" then self.x = ent.phys.x+ent.phys.w; self.vx = -self.vx*c end --from right
	if dir == "up" then self.y = ent.phys.y-self.h; self.vy = -self.vy*c end --hit from above
	if dir == "down" then self.y = ent.phys.y+ent.phys.h; self.vy = -self.vy*c end --below
end