local Object = require "libraries.classic.classic"
local baton = require "libraries.baton.baton"
local utils = require "utils"

local Player = Object:extend()

function Player:new()
	--[[========================== attributes ================================]]
	
	self.x = nil -- in tile numbers, not position on screen
	self.y = nil
	self.heart = nil
	
	self.input = baton.new{
		controls = {
			left = {"key:left", "button:dpleft"},
			right = {"key:right", "button:dpright"},
			up = {"key:up", "button:dpup"},
			down = {"key:down", "button:dpdown"},
			action = {"key:x", "button:a"},
		},
		joystick = game.joysticks[1]
	}
	
	self.drawFlag = true -- i thought maybe I could do something with this, idk
	
	--[[=========================== setting up ===============================]]
	
	--print(love.joystick.getName(love.joystick.getJoysticks()[1]))
	
	--[[======================================================================]]
	
end

function Player:update(dt)
	self.input:update()
	
	--print(self.input:getActiveDevice())
	
	if self.input:down("action") then
		print("you pressed the action button!")
	end
	
	if self.input:down("left") then
		print("you pressed the left button!")
	end
	
	if self.input:down("right") then
		print("you pressed the right button!")
	end
	
	if self.input:down("up") then
		print("you pressed the up button!")
	end
	
	if self.input:down("down") then
		print("you pressed the down button!")
	end
end

function Player:draw()
	love.graphics.draw(game.tileset.image,
		game.quads[self.heart],
		utils.width_position(self.x - 1),
		utils.height_position(self.y - 1)
	)
end

return Player