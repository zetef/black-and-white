local Object = require "libraries.classic.classic"
local Menu = Object:extend()

function Menu:new()
	
end

function Menu:update(dt)
	
end

function Menu:draw()
	
end

function Menu:keypressed(key, scancode, isrepeat)
	if key == "escapre" then
		love.event.quit()
	end
end

function Menu:keyreleased(key)

end

return Menu