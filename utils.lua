local lume = require "libraries.lume.lume"
local json = require "libraries.json.json"

-- local Tile = require "objects.Tile"

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
	-- minus 1 bcs it ranges then from 0 to x - 1 instead of 1 to x
	local stage_width = utils.stagew()
	return (game.width - stage_width) / 2 +
	(x - 1) * (game.tile.width + game.CONST.spacing)
end

utils.ypos = function(y) -- in tile number
	-- minus 1 bcs it ranges then from 0 to y - 1 instead of 1 to y
	local stage_height = utils.stageh()
	return (game.height -  stage_height) / 2 +
	(y - 1) * (game.tile.width + game.CONST.spacing)
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

utils.drawTile = function(tile, v) -- vector for position in tile numbers
	love.graphics.draw(game.tileset.image,
		game.quads[tile],
		utils.xpos(v.x),
		utils.ypos(v.y)
	)
end

utils.isPlayer = function(tile)
	return tile == game.CONST.zeroHeart or tile == game.CONST.oneHeart
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
	-- player position
	m.x = pos % m.height; if m.x == 0 then m.x = m.width end
	m.y = lume.round(pos / m.height)
	-- player color
	m.color = data.layers[2].data[pos]
	data.layers[2].data[pos] = 0 -- delete the player number from the map
	m.layers = {}
	for i, v in ipairs(data.layers) do
		m.layers[i] = utils.array1Dto2D(v.data, v.width, v.height)
		-- m.layers[i].hide = false -- for future versions
	end
	return m
end

return utils