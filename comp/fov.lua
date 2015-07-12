--component for field of view calculations.
fov = class:new()

function fov:init(parent, dir, fov, range)
	self.parent = parent
	local ang = angle:new({1,1})
	ang:setTheta(dir)
	self.ang = ang
	self.fov = fov
	self.range = range
end

function fov:update(dt)

end

function fov:setAngle(ang)
	self.ang = ang
end

function fov:isInFOV(ent)

	if ent == false then return false end

	--calculate if player is out of range
	local p1 = self.parent.phys
	local x = p1.x+p1.w/2; local y = p1.y+p1.h/2
	local p2 = ent.phys
	local x2 = p2.x+p2.w/2; local y2 = p2.y+p2.h/2
	local ang = angle:new({x2-x, y2-y})
	local dist = math.sqrt((x2-x)*(x2-x) + (y2-y)*(y2-y))
	if dist > self.range then return false end

	--calculate if player is in correct angle range
	if getAngleDistance(ang.theta, self.ang.theta) > self.fov/2 then
		return false
	end

	--calculate if any walls are in the way
	local progress = 0
	while progress < dist do
		progress = progress + 4
		x = x + ang.xPart*4
		y = y + ang.yPart*4
		local cols, len = gameMode.colMan.world:queryRect(x, y, 1, 1)
		for i,ent in ipairs(cols) do
			if ent.id == "tile" then
				return false
			end
		end
	end

	return true
end