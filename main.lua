require "libs/class"
require "libs/angle"
anim8 = require "libs/anim8"
require "game"

function love.load()

	--math.randomseed(os.time())

	love.window.setMode(800, 600) --set window dimensions
	love.window.setTitle("GÖAST")

	--imgManager = imageManager:new()
	--audioManager = audioManager:new()

	--different classes for different "modes" of gameplay.
	gameMode = game:new()
	--menu = mainMenu:new()
	--lose = endMenu:new()
	currentMode = gameMode

end

function love.update(dt)

	currentMode:update(dt)

end

function love.draw()

	currentMode:draw()

end

function love.keypressed(key)

	currentMode:keypressed(key)

	if key == "m" then --mute audio
		if love.audio.getVolume() == 1 then love.audio.setVolume(0)
			else love.audio.setVolume(1) end
	end

end

function love.mousepressed(x, y, button)

	currentMode:mousepressed(x, y, button)

end

function keyDown(key)
	return love.keyboard.isDown(key)
end

function string:split(delimiter) --definitely not stolen from anything else
	local result = {}
	local from  = 1
	local delim_from, delim_to = string.find( self, delimiter, from  )
	while delim_from do
		table.insert( result, string.sub( self, from , delim_from-1 ) )
		from = delim_to + 1
		delim_from, delim_to = string.find( self, delimiter, from  )
	end
	table.insert( result, string.sub( self, from  ) )
	return result
end

function randSign()
	if math.random(2) == 1 then return -1 else return 1 end
end

function crash(message) --ghetto debugs yo
	message = message or "crash() called"
	assert(false, message)
end

function magnitude(x,y)
	return math.sqrt(x*x+y*y)
end