local Object = require "libraries.classic.classic"
local baton = require "libraries.baton.baton"

local Player = Object:extend()

function Player:new()
	--[[========================== attributes ================================]]
	
	self.x = nil -- in tile numbers, not position on screen
	self.y = nil
	self.width = game.tile.width
	self.height = game.tile.height
	
	self.zero = game.CONST.zeroHeart
	self.one = game.CONST.oneHeart
	
	self.input = baton.new{
		controls = {
			left = {"key:left", "button:dpleft"},
			right = {"key:right", "button:dpright"},
			up = {"key:up", "button:dpup"},
			down = {"key:down", "button:dpdown"},
			action = {"key:x", "button:a"},
		},
		joystick = love.joystick.getJoysticks()[1]
	}
	
	self.drawFlag = false
	
	--[[======================================================================]]
	
end

function Player:update(dt)
	self.input:update()
end

function Player:draw()

end

return Player