local Object = require "libraries.classic.classic"
local baton = require "libraries.baton.baton"

local RMenu = Object:extend()

function RMenu:new()
	--[[========================== attributes ================================]]
	
	self.input = baton.new{
		controls = {
			up = {"key:up", "button:dpup"},
			down = {"key:down", "button:dpdown"},
			action = {"key:x", "button:a"},
		},
		joystick = love.joystick.getJoysticks()[1]
	}
	
	--[[======================================================================]]
	
end

function RMenu:update(dt)
	self.input:update()
end

function RMenu:draw()
	love.graphics.print("Menu", 0, 0)
end

function RMenu:keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.event.quit()
	end
end

function RMenu:keyreleased(key)

end

return RMenu