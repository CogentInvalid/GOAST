spawnManager = class:new()

function spawnManager:init(parent)

	self.id = "spawnManager"
	self.parent = parent

	self.spawnPoints = {}
	--self:addSpawnPoint(25, 25)
	--self:addSpawnPoint(800, 200)

	self.totalTime = 0

	self.enemies = 0

	self.spawnTimer = 5

end

function spawnManager:update(dt)

	self.totalTime = self.totalTime + dt

	--spawn rate calculations
	local easing = math.pow((self.totalTime+20)/20, -1)
	local difficulty = (math.cos(math.pi*self.totalTime/45))
	local a = (0.035 * difficulty + 0.165) * (math.pow(1.01, -0.2*self.totalTime)+0.2)
	local c = (0.5 * difficulty + 1) * (math.pow(1.01, -0.2*self.totalTime)+0.2)
	local spawnRate = (a*self.enemies*self.enemies - 0.0166667*self.enemies + c)*(1+easing)

	--difficulty = 1
	--a = 0.23 * 1.2 = 0.276
	--c = 1 * 1.2 = 1.2
	--spawnRate = 0.276x^2 - 0.016x + 1.2

	self.spawnTimer = self.spawnTimer - dt
	if self.spawnTimer <= 0 then
		self:spawn()
		self.spawnTimer = spawnRate
	end

end

function spawnManager:addSpawnPoint(x, y)
	self.spawnPoints[#self.spawnPoints+1] = {x=x, y=y}
end

function spawnManager:spawn()
	local found = false
	while not found do
		local i = math.random(#self.spawnPoints)
		local p = self.spawnPoints[i]
		if magnitude(p.x - gameMode.p.phys.x, p.y - gameMode.p.phys.y) > 350 then
			self.parent:addEnt(enemy, {self.spawnPoints[i].x, self.spawnPoints[i].y})
			self.enemies = self.enemies + 1
			found = true
		end
	end
end