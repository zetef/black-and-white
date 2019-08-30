local lume = require "libraries.lume.lume"
local json = require "libraries.json.json"

local utils = {}

utils.joystick_details = function(joystick) -- print some joystick info
	if not joystick then
		print("No joystick connected!")
		print()
		return nil
	end
	
	print("Name: " .. joystick:getName())
	print("GUID, ID: " .. joystick:getGUID() .. ", " .. joystick:getID())
	print("Button Count: " .. joystick:getButtonCount())
	print("Axis Count: " .. joystick:getAxisCount())
	print("Direction of each axis:")
	for k, v in pairs({joystick:getAxes()}) do
		print("Axis " .. k .. ": " .. v)
	end
	print("Hat Count: " .. joystick:getHatCount())
	print("Is Connected: " .. tostring(joystick:isConnected()))
	print("Is Gamepad: " .. tostring(joystick:isGamepad()))
	print("Is Vibration supported: " .. tostring(joystick:isVibrationSupported()))
	print("Gamepad Mappings: " .. love.joystick.saveGamepadMappings())
	print()
end

--we have to recalculate stagew and stageh bcs we call them
--many times in different stages

utils.stagew = function() -- the current stage width
	return game.rooms.RGame.current_stage.width *
	(game.tile.width + game.CONST.spacing)
end

utils.stageh = function() -- the current stage height
	return game.rooms.RGame.current_stage.height * 
	(game.tile.height + game.CONST.spacing)
end

utils.xpos = function(x) -- in tile number
	local stage_width = utils.stagew()
	return (game.width - stage_width) / 2 +
	x * (game.tile.width + game.CONST.spacing)
end

utils.ypos = function(y) -- in tile number
	local stage_height = utils.stageh()
	return (game.height -  stage_height) / 2 +
	y * (game.tile.width + game.CONST.spacing)
end

utils.inbound = function(v) -- a vector
	return v.x >= 1 and v.x <= game.rooms.RGame.current_stage.width and
		v.y >= 1 and v.y <= game.rooms.RGame.current_stage.height
end

utils.pingpong = function(v, s, d) -- a more suited pingpong in my case
	if v == s then
		return d
	else
		return s
	end
end

utils.either = function(a, b) -- returns the var one that is not nil
	if a then
		return a
	else
		return b
	end
end

utils.drawTile = function(tile, x, y) -- x and y in tile numbers
	love.graphics.draw(game.tileset.image,
		game.quads[tile],
		utils.xpos(x),
		utils.ypos(y)
	)
end

utils.fileData = function(file) -- returns the whole contents of a file
	local f = assert(io.open(file, "rb"))
	local data = f:read("*all")
	f:close()
	return data
end

utils.array1Dto2D = function(array, w, h) -- returns a 2D arr from 1D
	local m = {}
	for i = 1, h do
		m[i] = {}
		for j = 1, w do
			m[i][j] = array[(i - 1) * h + j]
		end
	end
	return m
end

utils.getMap = function(mapname) -- returns a map from a json file by tiled
	local m = {}
	local f = "resources/maps/" .. mapname .. ".json"
	local data = utils.fileData(f)
	data = json.decode(data)
	local zeroHeartPos = lume.find(data.layers[2].data,
		game.CONST.zeroHeart
	)
	local oneHeartPos = lume.find(data.layers[2].data,
		game.CONST.oneHeart
	)
	local pos = utils.either(zeroHeartPos, oneHeartPos)
	
	m.name = mapname
	m.width = data.width
	m.height = data.height
	m.x = pos % m.height
	m.y = math.floor(pos / m.height) + 1
	m.heart = data.layers[2].data[pos]
	m.layers = {}
	for i, v in ipairs(data.layers) do
		m.layers[i] = utils.array1Dto2D(v.data, v.width, v.height)
	end
	return m
end

return utils