local Game = require "objects.Game"

function love.load()
	game = Game(128, 128) --intentionally global
	game:addRoom("Menu")
	game:addRoom("Game")
	game:addRoom("Over")
	-- for k, v in pairs(game.rooms) do
		-- print(k, v)
	-- end
	game:gotoRoom("Menu")
	-- print(game.current_room)
end

function love.update(dt)
	game:update(dt)
end

function love.draw()
	game:draw()
end

function love.keypressed(key, scancode, isrepeat)
	game:keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key)
	game:keyreleased(key)
end

function love.resize(w, h)
	game:resize(w, h)
end