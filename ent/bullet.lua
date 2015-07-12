require "comp/physics"

bullet = class:new()

function bullet:init(args)
	local x=args[1]; local y=args[2]

	self.id = "bullet"
	--self.drawLayer = "front"

	self.component = {}

	--phys component
	self.phys = physics:new(self, x, y, 8, 8)
	self.component[#self.component+1] = self.phys
	self.phys:setVel(args[3], args[4])

	self.friendly = args[5] --does it damage enemies or the player?

	self.die = false --should this entity be destroyed next frame?
end

function bullet:update(dt)

	--update all components
	for i,comp in ipairs(self.component) do
		comp:update(dt)
	end

end

function bullet:draw()

	love.graphics.setColor(255,255,255)
	love.graphics.rectangle("fill", self.phys.x, self.phys.y, self.phys.w, self.phys.h)

end

function bullet:resolveCollision(entity, dir)
	if entity.id == "tile" or entity.id == "objective" then self.die = true end
end