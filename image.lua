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

	effect = love.graphics.newShader [[
		extern float x;
		extern float y;
		extern float amt;
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
        {	
			vec4 color1 = texture2D(texture, gl_TexCoord[0].st);
			number r = color1[0]*color[0];
			number g = color1[1]*color[1];
			number b = color1[2]*color[2];
			number a = color1[3]*color[3];
			number x2 = pixel_coords[0];
			number y2 = pixel_coords[1];
			number dist = sqrt((x-x2)*(x-x2)+(y-y2)*(y-y2));
			if(dist > 400)
			{
				r = r*amt*amt;
				g = g*amt*amt;
				b = b*amt*amt;
			}
			if(dist > 200)
			{
				r = r*amt;
				g = g*amt;
				b = b*amt;
			}
            return vec4(r, g, b, a);
        }
    ]]

end