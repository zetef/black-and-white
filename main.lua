local Game = require "objects.Game"

function love.load()
	game = Game(128, 128) --intentionally global
	game:addRoom("RMenu")
	game:addRoom("RGame")
	game:addRoom("ROver")
	
	game.rooms.RGame:addStage( --tutorial
		{
			width = 5, 
			height = 1,
			heart = game.CONST.oneHeart,
			x = 2, 
			y = 1,
			zeroes = { --zeroes
				{x = 4, y = 1},
			},
			zeroesGoal = { --zeroes goal
				{x = 5, y = 1},
			}, 
			ones = { --ones
				{x = 1, y = 1},
			},
			onesGoal = { --ones goal
				{x = 1, y = 1},
			},
		}, 
		"tutorial"
	)
	
	game:gotoRoom("RGame")
	game.rooms.RGame:gotoStage("tutorial")
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