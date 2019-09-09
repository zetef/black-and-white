local Vector = require "libraries.hump.vector"
local Timer = require "libraries.hump.timer"
local lume = require "libraries.lume.lume"
local Tile = require "objects.Tile"
local utils = require "utils"

local Piece = Tile:extend()

function Piece:new(position, color)
	Piece.super.new(self, position, color)
	self.drawPos = Vector(position.x, position.y)
	self.speed = 0.5

	self.timer = Timer()
end

function Piece:update(dt)
	Piece.super.update(self, dt)

	self.timer:update(dt)

	local map = game.rooms.RGame.current_stage.layers[2]
	local tmp = Vector(0, 0)
	local diff = game.CONST.zeroHeart - game.CONST.zero
	local CONST = {}
	CONST.up = 1
	CONST.right = 2
	CONST.down = 3
	CONST.left = 4
	CONST.total = 4
	CONST.opposite = 2
	local tiles = { -- the four directions
		Vector(0, -1), Vector(1, 0), Vector(0, 1), Vector(-1, 0)
	}

	--print(tostring(self) .. ": ")
	for direction, vector in ipairs(tiles) do
		-- i could use the __add metamethod but i want to round
		-- the tile's position so it's always an integer no matter what
		tmp = self.pos + vector
		-- tmp.x = lume.round(self.drawPos.x) + vector.x
		-- tmp.y = lume.round(self.drawPos.y) + vector.y
		if utils.inbound(tmp) then --tile in that direction
			local tile = map[tmp.y][tmp.x]
			if tile ~= game.CONST.NULL then
				--print("\t" .. tostring(tmp))
				-- if player keep it 1 or 2
				if utils.isPlayer(tile) then
					tile = tile - game.CONST.colorDiff
				end

				if self.color ~= tile - 5 or self.color ~= tile then
					local opp = (direction + CONST.opposite) % CONST.total
					if opp == 0 then opp = CONST.left end -- tiles[opp]
					print(direction .. " " ..  opp)
					tmp = self.pos + tiles[opp]
					-- tmp.x = lume.round(self.drawPos.x) + tiles[opp].x
					-- tmp.y = lume.round(self.drawPos.y) + tiles[opp].y
					--print(tostring(tmp) .. "\n")
					game.acceptInput = false
					self.timer:after(self.speed * 0.5,
						function()
							self:moveTo(tmp)
						end
					)
					--if utils.isPlayer(tile) then self.drawPos = self.drawPos + tile[opp] end
				end
			end
		end
	end
end

function Piece:draw()
	--Piece.super.draw(self)
	utils.drawTile(self.color, self.pos)
end

function Piece:moveTo(position)
	self.timer:tween(self.speed, self.drawPos,
		{x = position.x, y = position.y}, "out-quad"
	)
	game.rooms.RGame.current_stage.layers[2][self.pos.y][self.pos.x] = 0
	self.pos = position
	game.rooms.RGame.current_stage.layers[2][self.pos.y][self.pos.x] = self
	game.acceptInput = false
	self.timer:after(self.speed, function() game.acceptInput = true end)
end

return Piece