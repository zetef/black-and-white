local Object = require "libraries.classic.classic"
local Vector = require "libraries.hump.vector"
local Timer = require "libraries.hump.timer"
local lume = require "libraries.lume.lume"
local utils = require "utils"

local Tile = Object:extend()

function Tile:new(x, y, color)
	self.pos = Vector(x, y)
	self.color = color
	
	self.timer = Timer()
end

function Tile:update(dt)
	self.timer:update(dt)

	local current_stage = game.rooms.RGame.current_stage
	local tmp = Vector(0, 0)
	local diff = 5 -- from zero tile to zero heart
	local CONST = {}
	CONST.up, CONST.right, CONST.down, CONST.left = 1, 2, 3, 4
	local tiles = { -- the four directions
		Vector(0, -1), Vector(1, 0), Vector(0, 1), Vector(-1, 0)
	}
	
	for direction, vector in ipairs(tiles) do
		-- i could use the __add metamethod but i want to round
		-- the tile's position so it's always an integer no matter what
		tmp.x = lume.round(self.pos.x) + vector.x
		tmp.y = lume.round(self.pos.y) + vector.y
		if utils.inbound(tmp) then
			
		end
	end
end

function Tile:draw()
	utils.drawTile(self.color, self.pos)
end

function Tile:__tostring()
	return "(" .. tostring(self.pos) .. ", " .. self.color .. ")"
end

return Tile