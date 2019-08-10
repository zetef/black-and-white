local Object = require "libraries.classic.classic"
local Over = Object:extend()

function Over:new()
	
end

function Over:update(dt)
	
end

function Over:draw()
	
end

function Over:keypressed(key, scancode, isrepeat)
	if key == "escape" then
		game:gotoRoom("Menu")
	end
end

function Over:keyreleased(key)

end

return Over