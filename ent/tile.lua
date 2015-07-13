require "comp/physics"

tile = class:new()

function tile:init(args)
	local x=args[1]; local y=args[2]

	imgn = args[3] or 0
	self.img = img["tile-wall-mid"]

	if imgn == 1 then self.img = img["tile-column-mid"] end

	self.id = "tile"
	--self.drawLayer = "front"

	self.component = {}

	--phys component
	self.phys = physics:new(self, x, y, 20, 20)
	self.component[#self.component+1] = self.phys
	self.phys.col = false

	self.die = false --should this entity be destroyed next frame?
end

function tile:update(dt)

	--update all components
	for i,comp in ipairs(self.component) do
		comp:update(dt)
	end

end

function tile:draw()

	love.graphics.setColor(255,255,255)
	love.graphics.rectangle("fill", self.phys.x, self.phys.y, self.phys.w, self.phys.h)

	love.graphics.draw(self.img, self.phys.x, self.phys.y)

end

function tile:resolveCollision(entity, dir)

end