require "comp/physics"

objective = class:new()

function objective:init(args)
	local x=args[1]; local y=args[2]

	self.num = args[3]

	self.id = "objective"
	--self.drawLayer = "front"

	self.component = {}

	--phys component
	self.phys = physics:new(self, x, y, 20, 20)
	self.component[#self.component+1] = self.phys
	self.phys.col = false

	self.die = false --should this entity be destroyed next frame?
end

function objective:update(dt)

	--update all components
	for i,comp in ipairs(self.component) do
		comp:update(dt)
	end

end

function objective:draw()

	love.graphics.setColor(0,0,255)
	love.graphics.rectangle("fill", self.phys.x, self.phys.y, self.phys.w, self.phys.h)

end

function objective:resolveCollision(entity, dir)

end