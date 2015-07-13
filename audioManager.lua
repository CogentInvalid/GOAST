audioManager = class:new()

function audioManager:init()
	--load all sounds from /resources

	local soundFiles = love.filesystem.getDirectoryItems("/snd/")

	sfx = {} --load sfx
	for i,name in ipairs(soundFiles) do
		if string.find(name, ".ogg") then
			name = string.gsub(name, ".ogg", "")
			sfx[name] = love.audio.newSource("/snd/" .. name .. ".ogg", "stream")
		end
	end

	--self.currentTrack = sfx['bgm']
end

function audioManager:update(dt)

end

function audioManager:switchMusic(source)
	self.currentTrack:stop()
	self.currentTrack = source
	self.currentTrack:setLooping(true)
	self.currentTrack:play()
end