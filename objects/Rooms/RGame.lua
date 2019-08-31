local Object = require "libraries.classic.classic"
local Vector = require "libraries.hump.vector"
local lume = require "libraries.lume.lume"
local utils = require "utils"

local Tile = require "objects.Tile"
local Player = require "objects.Player"

local RGame = Object:extend()

function RGame:new()
	--[[========================== attributes ================================]]
	
	self.current_stage = nil
	self.stages = {}
	
	self.player = Player(0, 0, game.CONST.zeroHeart)
	
	--[[======================================================================]]
	
end

function RGame:update(dt)
	if self.current_stage then
		for layer, m in ipairs(self.current_stage.layers) do
			for i, row in ipairs(m) do
				for j, tile in ipairs(row) do
					if tile ~= 0 then 
						tile:update()
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

--[[ local function verifyStage(stage)
	-- local flag = true
	-- local req = {}
	-- req["map"] = true 
	-- req["width"] = true 
	-- req["height"] = true 
	-- req["heart"] = true
	-- req["x"] = true 
	-- req["y"] = true 
	-- req["tiles"] = true
	-- req["zeroes"] = true 
	-- req["zeroesGoal"] = true 
	-- req["ones"] = true
	-- req["onesGoal"] = true
	
	-- for k, v in pairs(stage) do
		-- if not req[k] then
			-- print("you required a non-existent req.: ", k)
			-- flag = false
			-- break
		-- else 
			-- print("good: ", k, " = ", v)
		-- end
	-- end
	
	-- return flag
-- end
]]

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
					map.layers[layer][i][j] = Tile(j, i, tile)
				end
			end
		end
	end
	
	self.stages[stage] = map
end

function RGame:gotoStage(stage)
	if self.stages[stage] then
		self.current_stage = self.stages[stage]
		
		self.player.color = self.current_stage.color
		
		--if i mistakanly put the player beyond the width or height, clamp
		self.player.pos.x = lume.clamp(self.current_stage.x, 
			1, self.current_stage.width
		)
		self.player.pos.y = lume.clamp(self.current_stage.y, 
			1, self.current_stage.height
		)
	else
		print("there is no such stage like: ", stage)
	end
end

return RGame