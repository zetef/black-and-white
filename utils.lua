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

--we have to recalculate level_width and level_height bcs we call them
--many times in different rooms

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

utils.pingpong = function(v, s, d) -- a more suited pingpong in my case
	if v == s then
		return d
	else
		return s
	end
end

utils.drawTile = function(tile, x, y) -- x and y in tile numbers
	love.graphics.draw(game.tileset.image,
		game.quads[tile],
		utils.xpos(x),
		utils.ypos(y)
	)
end

return utils