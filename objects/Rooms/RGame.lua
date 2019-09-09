local Object = require "libraries.classic.classic"
local Vector = require "libraries.hump.vector"
local lume = require "libraries.lume.lume"
local utils = require "utils"

local Tile = require "objects.Tile"
local Piece = require "objects.Piece"
local Player = require "objects.Player"

local RGame = Object:extend()

function RGame:new()
	--[[========================== attributes ================================]]

	self.current_stage = nil
	self.stages = {}

	self.player = nil -- Player(Vector(0, 0), game.CONST.zeroHeart)

	--[[======================================================================]]

end

function RGame:update(dt)
	if self.current_stage then
		for layer, m in ipairs(self.current_stage.layers) do
			for i, row in ipairs(m) do
				for j, tile in ipairs(row) do
					if tile ~= 0 then
						tile:update(dt)
					end
				end
			end
		end
		self.player:update(dt)
	end
end

function RGame:draw()
	--TODO: DO THE STAGE DRAWING
	if self.current_stage then

		--draw the current stage
		--TODO: optimize the drawing. tip: do not overdraw!

		for layer, m in ipairs(self.current_stage.layers) do
			for i, row in ipairs(m) do
				for j, tile in ipairs(row) do
					if tile ~= 0 then
						tile:draw()
					end
				end
			end
		end

		--draw the player (if needed to)
		--if self.player.drawFlag then
		self.player:draw()
		--end

		-- the stage bound
		love.graphics.rectangle("line",
			-- minus 2 to center
			utils.xpos(1) - 2, utils.ypos(1) - 2,
			utils.stagew(), utils.stageh()
		)

	end
end

function RGame:keypressed(key, scancode, isrepeat)

end

function RGame:keyreleased(key)
	if key == "escape" then
		game:gotoRoom("RMenu")
	end

	if key == "r" then -- goto same stage
		self:gotoStage(self.current_stage.name)
	end

	if key == "return" then -- show the layers
		for layer, m in ipairs(self.current_stage.layers) do
			print("layer: " .. layer)
			for i, row in ipairs(m) do
				for j, tile in ipairs(row) do
					io.write(tostring(tile) .. " ")
				end
				print()
			end
			print()
		end
		print()
	end
end

function RGame:addStage(stage)
	local map = utils.getMap(stage)

	-- my proccessing. the getMap function did his job of
	-- parsing a json file made from a Tiled map.
	-- the below code is the thing I want to do to it,
	-- that of transforming non-zero numbers into Tiles with their
	-- corresponding color, x, y etc

	for layer, m in ipairs(map.layers) do
		for i, row in ipairs(m) do
			for j, tile in ipairs(row) do
				if tile ~= 0 then
					if tile == game.CONST.empty or tile == game.CONST.zeroGoal
						or tile == game.CONST.oneGoal then
						map.layers[layer][i][j] = Tile(Vector(j, i), tile)
					else
						map.layers[layer][i][j] = Piece(Vector(j, i), tile)
					end
				end
			end
		end
	end

	self.stages[stage] = map
end

function RGame:gotoStage(stage)
	if self.stages[stage] then
		self.current_stage = self.stages[stage]

		self.player = Player(
			Vector(self.current_stage.x, self.current_stage.y),
			self.current_stage.color
		)
		self.current_stage.layers[2]
			[self.player.pos.y][self.player.pos.x] = self.player
		--if i mistakanly put the player beyond the width or height, clamp
		-- self.player.pos.x = lume.clamp(self.current_stage.x,
			-- 1, self.current_stage.width
		-- )
		-- self.player.pos.y = lume.clamp(self.current_stage.y,
			-- 1, self.current_stage.height
		-- )
		-- self.player.color = self.current_stage.color
	else
		print("there is no such stage like: ", stage)
	end
end

return RGame