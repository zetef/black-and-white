local Object = require "libraries.classic.classic"
local baton = require "libraries.baton.baton"
local utils = require "utils"
local Timer = require "libraries.hump.timer"

local Player = Object:extend()

function Player:new()
	--[[========================== attributes ================================]]
	
	self.x = nil -- in tile numbers, not position on screen
	self.y = nil
	self.heart = nil
	self.timer = Timer.new()
	
	self.input = baton.new {
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
	self.timer:update(dt)
	
	--print(self.input:getActiveDevice())
	
	if self.input:released("action") then
		--print("you released the action button!")
		self.heart = utils.pingpong(self.heart, 
			game.CONST.zeroHeart, game.CONST.oneHeart
		)
	end
	
	-- let them with elseif to move diagon-ally (pun intended)
	if self.input:released("left") then
		-- print("you released the left button!")
		-- self.x = self.x - 1
		self.timer:tween(.3, self, {x = self.x - 1}, "out-quad")
		--self.timer:after(.3, function)
	elseif self.input:released("right") then
		--print("you released the right button!")
		-- self.x = self.x + 1
		self.timer:tween(.3, self, {x = self.x + 1}, "out-quad")
	end
	
	if self.input:released("up") then
		--print("you released the up button!")
		-- self.y = self.y - 1
		self.timer:tween(.3, self, {y = self.y - 1}, "out-quad")
	elseif self.input:released("down") then
		--print("you released the down button!")
		-- self.y = self.y + 1
		self.timer:tween(.3, self, {y = self.y + 1}, "out-quad")
	end
end

function Player:draw()
	utils.drawTile(self.heart, self.x - 1, self.y - 1)
end

return Player