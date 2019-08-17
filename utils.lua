local utils = {}

utils.joystick_details = function(joystick)
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

utils.width_position = function(w) -- in tile number
	local level_width = game.rooms.RGame.current_stage.width *
	(game.tile.width + game.CONST.spacing)
	return (game.width - level_width) / 2 +
	w * (game.tile.width + game.CONST.spacing)
end

utils.height_position = function(h) -- in tile number
	local level_height = game.rooms.RGame.current_stage.height * 
	(game.tile.height + game.CONST.spacing)
	return (game.height -  level_height) / 2 +
	h * (game.tile.width + game.CONST.spacing)
end

return utils