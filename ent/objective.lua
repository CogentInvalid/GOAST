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

	self.img = "generator"
	self.seq = {"generator", "generator2", "generator3", "generator4", "generator3", "generator2"}
	self.seqPos = 1
	self.animTimer = 0.15

	self.die = false --should this entity be destroyed next frame?
end

function objective:update(dt)

	--update all components
	for i,comp in ipairs(self.component) do
		comp:update(dt)
	end

	self.animTimer = self.animTimer - dt
	if self.animTimer < 0 then
		self.seqPos = self.seqPos + 1
		if self.seqPos > #self.seq then self.seqPos = 1 end
		self.img = self.seq[self.seqPos]
		self.animTimer = 0.15
	end

end

function objective:draw()

	love.graphics.setColor(0,0,255)
	--love.graphics.rectangle("fill", self.phys.x, self.phys.y, self.phys.w, self.phys.h)

	love.graphics.setColor(255,255,255)
	love.graphics.draw(img[self.img], self.phys.x-2, self.phys.y-2)

end

function objective:resolveCollision(entity, dir)

end