--local Object = require "libraries.classic.classic"
local Vector = require "libraries.hump.vector"
local Timer = require "libraries.hump.timer"
local baton = require "libraries.baton.baton"
local lume = require "libraries.lume.lume"
local utils = require "utils"

local Tile = require "objects.Tile"

local Player = Tile:extend()

function Player:new(x, y, color)
	--[[========================== attributes ================================]]
	
	self.super.new(self, x, y, color)
	self.speed = 0.3
	--self.pos = Vector(0, 0) -- in tile numbers, not position on screen
	-- self.x = nil 
	-- self.y = nil
	--self.heart = nil
	
	--self.timer = Timer.new()
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
	
	-- i thought maybe I could do something with this, idk
	-- self.drawFlag = true 
	
	--[[=========================== setting up ===============================]]
	
	--print(love.joystick.getName(love.joystick.getJoysticks()[1]))
	
	--[[======================================================================]]
	
end

function Player:update(dt)
	self.super.update(self, dt)
	self.input:update()
	
	-- local current_stage = game.rooms.RGame.current_stage
	
	if self.input:released("action") then
		--print("you released the action button!")
		self.color = utils.pingpong(self.color, 
			game.CONST.zeroHeart, game.CONST.oneHeart
		)
	end
	
	-- let them with elseif to move diagon-ally (pun intended)
	if self.input:released("left") then
		self.timer:tween(self.speed, self.pos, {x = self.pos.x - 1}, "out-quad")
		-- maybe an after?
	elseif self.input:released("right") then
		self.timer:tween(self.speed, self.pos, {x = self.pos.x + 1}, "out-quad")
	end
	
	if self.input:released("up") then
		self.timer:tween(self.speed, self.pos, {y = self.pos.y - 1}, "out-quad")
	elseif self.input:released("down") then
		self.timer:tween(self.speed, self.pos, {y = self.pos.y + 1}, "out-quad")
	end
	
	-- bound the player (might change later)
	self.pos.x = lume.clamp(self.pos.x, 
		1, game.rooms.RGame.current_stage.width
	)
	self.pos.y = lume.clamp(self.pos.y, 
		1, game.rooms.RGame.current_stage.height
	)
end

function Player:draw()
	-- if self.pos and self.heart then
		-- utils.drawTile(self.heart, self.pos)
	-- end
	self.super.draw(self)
end

function Player:opposite()
	return utils.pingpong(self.color, game.CONST.zeroHeart, game.CONST.oneHeart) 
end

return Player