local Object = require "libraries.classic.classic"
local Timer = require "libraries.hump.timer"
local lume = require "libraries.lume.lume"
local utils = require "utils"

--local Tile = require "objects.Tile"
local Player = require "objects.Player"

local RGame = Object:extend()

function RGame:new()
	--[[========================== attributes ================================]]
	
	self.current_stage = nil
	self.stages = {}
	
	self.player = Player()
	self.timer = Timer()
	
	--[[======================================================================]]
	
end

function RGame:update(dt)
	if self.current_stage then
		self.timer:update(dt)
		self.player:update(dt)
	end
end

function RGame:draw()
	--TODO: DO THE STAGE DRAWING
	if self.current_stage then
	
		--draw the current stage
		--TODO: optimize the drawing. tip: do not overdraw!
		
		-- the stage bound
		love.graphics.rectangle("line", 
			-- minus 2 to center
			utils.xpos(0) - 2, utils.ypos(0) - 2, 
			utils.stagew(), utils.stageh()
		)
		
		for layer, map in ipairs(self.current_stage.layers) do
			for i, row in ipairs(map) do
				for j, tile in ipairs(row) do
					--io.write(tile .. " ")
					if tile ~= 0 and tile ~= game.CONST.zeroHeart and 
					   tile ~= game.CONST.oneHeart then 
						utils.drawTile(tile, j - 1, i - 1)
					end
				end
				--print()
			end
			--print()
		end
		
		--all the empty tiles
		-- for i = 0, self.current_stage.height - 1 do
			-- for j = 0, self.current_stage.width - 1 do
				-- utils.drawTile(game.CONST.empty, j, i)
			-- end
		-- end
		
		--draw the goal before the actual zeroes/ones
		-- for _, tile in ipairs(self.current_stage.tiles.zeroGoal) do
			-- utils.drawTile(game.CONST.zeroGoal, tile.x - 1, tile.y - 1)
		-- end
		-- for _, tile in ipairs(self.current_stage.tiles.oneGoal) do
			-- utils.drawTile(game.CONST.oneGoal, tile.x - 1, tile.y - 1)
		-- end
		
		-- draw the zeroes/ones
		-- for _, tile in ipairs(self.current_stage.tiles.zero) do
			-- utils.drawTile(game.CONST.zero, tile.x - 1, tile.y - 1)
		-- end
		-- for _, tile in ipairs(self.current_stage.tiles.one) do
			-- utils.drawTile(game.CONST.one, tile.x - 1, tile.y - 1)
		-- end
	
		--draw the player (if needed to)
		--if self.player.drawFlag then
		self.player:draw()
		--end
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
	
	if key == "return" then
		for k, v in pairs(self.stages[self.current_stage.name].tiles.zero) do
			print(k, v)
		end
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
	io.write("stage: " .. stage .. "\n")
	self.stages[stage] = map
	
	for k, v in pairs(map) do
		print(k, v)
	end
	--self.stages[stage.name].name = name -- the stage name in the table
	--print("name stage: " .. self.stages[name].name)
	--print("good stage!")
	--print()
end

function RGame:gotoStage(stage)
	if self.stages[stage] then
		self.current_stage = self.stages[stage]
		
		self.player.heart = self.current_stage.heart
		
		--if i mistakanly put the player beyond the width or height, clamp
		self.player.x = lume.clamp(self.current_stage.x, 
			1, self.current_stage.width
		)
		self.player.y = lume.clamp(self.current_stage.y, 
			1, self.current_stage.height
		)
	else
		print("there is no such stage like: ", stage)
	end
end

return RGame