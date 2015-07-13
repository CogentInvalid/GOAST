startMenu = class:new()

function startMenu:init()
	self.lol = 0
	self.haha = 0
	self.rofl = 0
	love.graphics.setBackgroundColor(255,255,255)
end

function startMenu:update(dt)
	self.lol = self.lol + 1.8*dt
	self.haha = math.sin(self.lol)
	self.rofl = self.rofl - dt
	if self.rofl < 0 then self.rofl = 0 end
end

function startMenu:draw()
	love.graphics.setColor(255,0,0)
	love.graphics.print("UR GOIGN TO START A VIDEO GAME\nPRESS THE RETURN BUTTON", 320, 300, self.haha*0.6)
end

function startMenu:keypressed(key)
	if key == "return" then
		gameMode:start()
		currentMode = gameMode
	else
		self.rofl = 1
	end
end

function startMenu:mousepressed(x, y, button)

end