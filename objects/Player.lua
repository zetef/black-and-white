local Object = require "libraries.classic.classic"
local baton = require "libraries.baton.baton"
local lume = require "libraries.lume.lume"
local utils = require "utils"
local Vector = require "libraries.hump.vector"
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
	
	local current_stage = game.rooms.RGame.current_stage
	local tmp = Vector(0, 0)
	local CONST = {}
	CONST.up, CONST.right, CONST.down, CONST.left = 1, 2, 3, 4
	local tiles = { -- the four directions
		Vector(0, -1), Vector(1, 0), Vector(0, 1), Vector(-1, 0)
	}
	
	for i, tile in ipairs(tiles) do
		-- use round bcs the player moves 'smoothly'
		tmp.x = lume.round(self.x) + tile.x
		tmp.y = lume.round(self.y) + tile.y
		if utils.inbound(tmp) then
			for tilename, tilevalue in pairs(current_stage.tiles) do
				if lume.find(tilevalue, tmp) then
					print(tilename .. "!")
					break
				end
			end
		end
	end
	print()
	
	if self.input:released("action") then
		--print("you released the action button!")
		self.heart = utils.pingpong(self.heart, 
			game.CONST.zeroHeart, game.CONST.oneHeart
		)
	end
	
	-- let them with elseif to move diagon-ally (pun intended)
	if self.input:released("left") then
		-- print("you released the left button!")
		self.timer:tween(.3, self, {x = self.x - 1}, "out-quad")
		--self.timer:after(.3, function)
	elseif self.input:released("right") then
		--print("you released the right button!")
		self.timer:tween(.3, self, {x = self.x + 1}, "out-quad")
	end
	
	if self.input:released("up") then
		--print("you released the up button!")
		self.timer:tween(.3, self, {y = self.y - 1}, "out-quad")
	elseif self.input:released("down") then
		--print("you released the down button!")
		self.timer:tween(.3, self, {y = self.y + 1}, "out-quad")
	end
	
	-- bound the player (might change later)
	self.x = lume.clamp(self.x, 1, current_stage.width)
	self.y = lume.clamp(self.y, 1, current_stage.height)
end

function Player:draw()
	if self.x and self.y then
		utils.drawTile(self.heart, self.x - 1, self.y - 1)
	end
end

return Player