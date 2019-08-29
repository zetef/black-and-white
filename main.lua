local Game = require "objects.Game"

function love.load()
	game = Game(128, 128) --intentionally global
	game:addRoom("RMenu")
	game:addRoom("RGame")
	game:addRoom("ROver")
	
	-- good to know: max width/height is 6
	
	game.rooms.RGame:addStage( --tutorial
		{
			width = 5, 
			height = 5,
			heart = game.CONST.zeroHeart,
			x = 3, 
			y = 3,
			zeroesGoal = {
				--{x = 5, y = 1},
			},
			onesGoal = {
				--{x = 1, y = 1},
			},
			zeroes = {
				--{x = 4, y = 1},
			},
			ones = {
				--{x = 1, y = 1},
			},
		}, 
		"tutorial"
	)
	
	-- for k, v in pairs(game.rooms.RGame.stages) do
		-- print(k, v)
	-- end
	
	game.rooms.RGame:gotoStage("tutorial")
	
	game:gotoRoom("RGame")
	
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