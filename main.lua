local Game = require "objects.Game"

function love.load()
	game = Game(128, 128) --intentionally global
	game:addRoom("RMenu")
	game:addRoom("RGame")
	game:addRoom("ROver")
	game:gotoRoom("RGame")
	-- good to know: max width/height is 6
	
	game.rooms.RGame:addStage("tutorial")
	game.rooms.RGame:gotoStage("tutorial")
	
	--[[ 	{
			-- width = 5, 
			-- height = 5,
			-- L1 = utils.mapfrom("resources/maps/tutorial.json")
			-- heart = game.CONST.zeroHeart,
			-- x = 3, 
			-- y = 3,
			-- zeroGoal = {
				--Vector(2, 3),
			-- },
			-- oneGoal = {
				--Vector(4, 3),
			-- }
			-- tiles = {
				-- zero = {
					--Vector(4, 1),
					-- Vector(3, 2),
					-- Vector(3, 4),
					-- Vector(2, 3),
				-- },
				-- one = {
					--Vector(3, 4)
				-- }
			-- }
		-- }
	
	-- for k, v in pairs(game.rooms.RGame.stages) do
		-- print(k, v)
	-- end
	]]
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