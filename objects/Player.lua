local Vector = require "libraries.hump.vector"
local Timer = require "libraries.hump.timer"
local baton = require "libraries.baton.baton"
local lume = require "libraries.lume.lume"
local utils = require "utils"

local Piece = require "objects.Piece"

local Player = Piece:extend()

function Player:new(position, color)
	--[[========================== attributes ================================]]

	Player.super.new(self, position, color)
	--self.drawPos = Vector(position.x, position.y)
	-- self.speed = 0.5
	--self.acceptInput = true
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
	Player.super.update(self, dt)
	self.input:update()

	-- local current_stage = game.rooms.RGame.current_stage

	if self.input:pressed("action") then
		--print("you released the action button!")
		self.color = utils.pingpong(self.color,
			game.CONST.zeroHeart, game.CONST.oneHeart
		)
		Player.super.update(self, dt)
	end

	-- let  them with elseif to move diagon-ally (pun intended)
	-- now you can't move diagon-ally :sad: (can we get an f in main.lua, guys)
	if self.input:pressed("left") and game.acceptInput then
		-- self:move{x = self.pos.x - 1}
		self:moveTo(Vector(self.pos.x - 1, self.pos.y))
	elseif self.input:pressed("right") and game.acceptInput then
		-- self:move{x = self.pos.x + 1}
		self:moveTo(Vector(self.pos.x + 1, self.pos.y))
	end

	if self.input:pressed("up") and game.acceptInput then
		-- self:move{y = self.pos.y - 1}
		self:moveTo(Vector(self.pos.x, self.pos.y - 1))
	elseif self.input:pressed("down") and game.acceptInput then
		-- self:move{y = self.pos.y + 1}
		self:moveTo(Vector(self.pos.x, self.pos.y + 1))
	end

	-- bound the player (might change later)
	self.pos.x = lume.clamp(self.pos.x,
		1, game.rooms.RGame.current_stage.width
	)
	self.pos.y = lume.clamp(self.pos.y,
		1, game.rooms.RGame.current_stage.height
	)
	self.drawPos.x = lume.clamp(self.drawPos.x,
		1, game.rooms.RGame.current_stage.width
	)
	self.drawPos.y = lume.clamp(self.drawPos.y,
		1, game.rooms.RGame.current_stage.height
	)
end

function Player:draw()
	-- if self.pos and self.heart then
	--utils.drawTile(self.color, self.drawPos)
	-- end
	Player.super.draw(self)
end

return Player