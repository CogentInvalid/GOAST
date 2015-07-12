function loadImages()

	local imgFiles = love.filesystem.getDirectoryItems("/img/")

	--load all images from /resources
	img = {} --load images from img folder
	for i,name in ipairs(imgFiles) do
		if string.find(name, ".png") then
			name = string.gsub(name, ".png", "")
			img[name] = love.graphics.newImage("/img/" .. name .. ".png")
		end
	end

end