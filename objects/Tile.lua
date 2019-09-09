local Object = require "libraries.classic.classic"
local utils = require "utils"

local Tile = Object:extend()

function Tile:new(position, color)
	self.pos = position
	self.color = color
end

function Tile:update(dt)

end

function Tile:draw()
	utils.drawTile(self.color, self.pos)
end

function Tile:__tostring()
	return "(" .. tostring(self.pos) .. ", " .. self.color .. ")"
end

return Tile