local Object = require "libraries.classic.classic"
local baton = require "libraries.baton.baton"

local RMenu = Object:extend()

function RMenu:new()
	--[[========================== attributes ================================]]
	
	self.input = baton.new{
		controls = {
			up = {"key:up", "button:dpup"},
			down = {"key:down", "button:dpdown"},
			action = {"key:x", "button:a"},
		},
		joystick = game.joysticks[1]
	}
	
	--[[======================================================================]]
	
end

function RMenu:update(dt)
	self.input:update()
	
	if self.input:released("action") then
		game:gotoRoom("RGame")
	end
end

function RMenu:draw()
	local lineHeight = game.font:getHeight()
	local titleHeight = lineHeight * 2 -- "BLACK" + "AND WHITE"
	local gap = lineHeight
	local promptHeight = lineHeight

	local blockHeight = titleHeight + gap + promptHeight
	local startY = (game.height - blockHeight) / 2

	love.graphics.printf("BLACK\nAND WHITE", 0, startY, game.width, "center")
	love.graphics.printf("X TO PLAY", 0, startY + titleHeight + gap, game.width, "center")
end

function RMenu:keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.event.quit()
	end
end

function RMenu:keyreleased(key)

end

return RMenu