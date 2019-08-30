local Object = require "libraries.classic.classic"
local baton = require "libraries.baton.baton"
local lume = require "libraries.lume.lume"
local utils = require "utils"
local Vector = require "libraries.hump.vector"
local Timer = require "libraries.hump.timer"

local Player = Object:extend()

function Player:new()
	--[[========================== attributes ================================]]
	
	self.x = 0 -- in tile numbers, not position on screen
	self.y = 0
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
	
	-- local current_stage = game.rooms.RGame.current_stage
	local tmp = Vector(0, 0)
	local diff = 5 -- from zero tile to zero heart
	local CONST = {}
	CONST.up, CONST.right, CONST.down, CONST.left = 1, 2, 3, 4
	local tiles = { -- the four directions
		Vector(0, -1), Vector(1, 0), Vector(0, 1), Vector(-1, 0)
	}
	
	if self.input:released("action") then
		--print("you released the action button!")
		self.heart = utils.pingpong(self.heart, 
			game.CONST.zeroHeart, game.CONST.oneHeart
		)
	end
	
	-- let them with elseif to move diagon-ally (pun intended)
	if self.input:released("left") then
		self.timer:tween(.3, self, {x = self.x - 1}, "out-quad")
		-- maybe an after?
	elseif self.input:released("right") then
		self.timer:tween(.3, self, {x = self.x + 1}, "out-quad")
	end
	
	if self.input:released("up") then
		self.timer:tween(.3, self, {y = self.y - 1}, "out-quad")
	elseif self.input:released("down") then
		self.timer:tween(.3, self, {y = self.y + 1}, "out-quad")
	end
	
	-- bound the player (might change later)
	self.x = lume.clamp(self.x, 1, game.rooms.RGame.current_stage.width)
	self.y = lume.clamp(self.y, 1, game.rooms.RGame.current_stage.height)
end

function Player:draw()
	if self.x and self.y and self.heart then
		utils.drawTile(self.heart, self.x - 1, self.y - 1)
	end
end

function Player:opposite()
	return utils.pingpong(self.heart, game.CONST.zeroHeart, game.CONST.oneHeart) 
end

return Player