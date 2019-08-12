local Object = require "libraries.classic.classic"

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
	self.player.input:update()
end

function RGame:draw()
	--TODO: DO THE STAGE DRAWING
	if self.current_stage then
		love.graphics.print("Level: " .. self.current_stage, 0, 0)
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
	req["ones"] = true
	req["zeroesGoal"] = true 
	req["onesGoal"] = true
	
	
	for k, v in pairs(stage) do
		if not req[k] then
			print("you required a non-existent req.: ", k)
			flag = false
			break
		else 
			print("good: ", k, " = ", v)
		end
	end
	
	return flag
end

function RGame:addStage(stage, name)
	print("stage: ", name)
	if verifyStage(stage) then
		if name then
			self.stages[name] = stage
		else
			table.insert(self.stages, stage)
		end
	end
end

function RGame:gotoStage(stage)
	if self.stages[stage] then
		self.current_stage = stage
	else
		print("there is no such stage like: ", stage)
	end
end

return RGame