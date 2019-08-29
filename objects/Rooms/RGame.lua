local Object = require "libraries.classic.classic"
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
	
	--[[======================================================================]]
	
end

function RGame:update(dt)
	self.player:update(dt)
	
	self.player.x = lume.clamp(self.player.x, 1, self.current_stage.width)
	self.player.y = lume.clamp(self.player.y, 1, self.current_stage.height)
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
		
		--all the empty tiles
		for i = 0, self.current_stage.height - 1 do
			for j = 0, self.current_stage.width - 1 do
				utils.drawTile(game.CONST.empty, j, i)
			end
		end
		
		--draw the goal before the actual zeroes/ones
		for _, tile in ipairs(self.current_stage.zeroesGoal) do
			utils.drawTile(game.CONST.zeroGoal, tile.x - 1, tile.y - 1)
		end
		for _, tile in ipairs(self.current_stage.onesGoal) do
			utils.drawTile(game.CONST.oneGoal, tile.x - 1, tile.y - 1)
		end
		
		-- draw the zeroes/ones
		for _, tile in ipairs(self.current_stage.zeroes) do
			utils.drawTile(game.CONST.zero, tile.x - 1, tile.y - 1)
		end
		for _, tile in ipairs(self.current_stage.ones) do
			utils.drawTile(game.CONST.one, tile.x - 1, tile.y - 1)
		end
	
		--draw the player (if needed to)
		--if self.player.drawFlag then
		self.player:draw()
		--end
	end
end

function RGame:keypressed(key, scancode, isrepeat)
	if key == "escape" then
		game:gotoRoom("RMenu")
	end
end

function RGame:keyreleased(key)
	
end

local function verifyStage(stage)
	local flag = true
	local req = {}
	--req["map"] = true 
	req["width"] = true 
	req["height"] = true 
	req["heart"] = true
	req["x"] = true 
	req["y"] = true 
	req["zeroes"] = true 
	req["zeroesGoal"] = true 
	req["ones"] = true
	req["onesGoal"] = true
	
	for k, v in pairs(stage) do
		if not req[k] then
			print("you required a non-existent req.: ", k)
			flag = false
			break
		else 
			--print("good: ", k, " = ", v)
		end
	end
	
	return flag
end

function RGame:addStage(stage, name)
	if verifyStage(stage) then
		io.write("stage: ")
		if name then
			self.stages[name] = stage
			print(name)
		else
			table.insert(self.stages, stage)
			print(#self.stages)
		end
		print("good stage!")
		print()
	end
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