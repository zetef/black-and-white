local Object = require "libraries.classic.classic"
local baton = require "libraries.baton.baton"

local ROver = Object:extend()

function ROver:new()
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

function ROver:update(dt)
	self.input:update(dt)
end

function ROver:draw()
	love.graphics.print("Over", 0, 0)
end

function ROver:keypressed(key, scancode, isrepeat)
	if key == "escape" then
		game:gotoRoom("RMenu")
	end
end

function ROver:keyreleased(key)

end

return ROver