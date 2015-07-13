endMenu = class:new()

function endMenu:init()

end

function endMenu:update(dt)

end

function endMenu:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(img["deathscreen"], 0, 0)
end

function endMenu:keypressed(key)
	if key == "return" then
		gameMode:start()
		currentMode = gameMode
	end
end

function endMenu:mousepressed(x, y, button)

end