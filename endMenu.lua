endMenu = class:new()

function endMenu:init()
	self.lol = 0
	self.haha = 0
	self.rofl = 0
	love.graphics.setBackgroundColor(255,255,255)
end

function endMenu:update(dt)
	self.lol = self.lol + 1.8*dt
	self.haha = math.sin(self.lol)
	self.rofl = self.rofl - dt
	if self.rofl < 0 then self.rofl = 0 end
end

function endMenu:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(img["deathscreen"], 400, 300, self.haha*(0.6+self.rofl*20), 1, 1, 400, 300)
	love.graphics.draw(img["enter"], 190, 380)
	love.graphics.setColor(255,0,0)
	love.graphics.print("SCORE: " .. gameMode.objMan.score, 350, 700)
end

function endMenu:keypressed(key)
	if key == "return" then
		gameMode:start()
		currentMode = gameMode
	else
		self.rofl = 1
	end
end

function endMenu:mousepressed(x, y, button)

end