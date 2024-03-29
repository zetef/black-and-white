Object = require 'libs/classic/classic'
--Input = require 'libs/boipushy/Input'; input = Input()
Timer = require 'libs/hump/timer'; timer = Timer()
lume = require 'libs/lume/lume'

--[[===========================]]
--  to give it that crispy look
love.graphics.setDefaultFilter('nearest')
love.graphics.setLineStyle('rough')
love.graphics.setLineJoin('bevel')
--[[=================]]

love.math.getRandomSeed(os.time())

--[[================]]

function recursiveEnumerate(folder, file_list)
	local items = love.filesystem.getDirectoryItems(folder)
	for _, item in ipairs(items) do
		local file = folder .. '/' .. item
		local info = love.filesystem.getInfo(file)
		--print(file)
		if info.type == 'file' then
			table.insert(file_list, 1, file)
		elseif info.type == 'directory' then
			recursiveEnumerate(file, file_list)
		end
	end
	return file_list
end

function requireFiles(files)
	for _, filepath in ipairs(files) do
		local filepath = filepath:sub(1, -5)
		local parts = lume.split(filepath, '/')
		local class = parts[#parts]
		--print(class)
		_G[class] = require(filepath)
	end
end

function resize(s)
    love.window.setMode(s*gw, s*gh) 
    sx, sy = s, s
end

function newButton(text, font, size, fn, x, y)
	return {
		action = fn,
		text = text,
		font = font,
		size = size,
		x = x,
		y = y,
	}
end

function newStage(level, index, x, y, zeroes, ones)
	return {
		level = level,
		restart = level,
		index = index,
		x = x,
		y = y,
		zeroes = zeroes,
		ones = ones
	}
end

--[[================]]

requireFiles(recursiveEnumerate('objs', {}))

--[[================]]

display = {}

rooms = {
	Menu = Room('Menu'),
	Game = Room('Game'),
	Over = Room('Over'),
}
curr_room = rooms.Menu
curr_stage = nil

--[[================]]

function love.load()
	display.main_canvas = love.graphics.newCanvas(gw, gh)
	
	resize(resz)
	
	-- input:bind('left', 'player_left')
	-- input:bind('right', 'player_right')
	-- input:bind('up', 'player_up')
	-- input:bind('down', 'player_down')
	-- input:bind('z', 'action')
	-- input:bind('enter', 'action')

	default_font = love.graphics.newImageFont('res/fonts/monochrome.png', 
		' abcdefghijklmnopqrstuvwxyz0123456789:.%')
	love.graphics.setFont(default_font)

	tileset = {
		image = love.graphics.newImage('res/tilesets/monochrome.png'),
		rows = 2,
		cols = 4,
		margin = 1,
		spacing = 2,
	}
	tileset.w = tileset.image:getWidth()
	tileset.h = tileset.image:getHeight()
	
	-- tileset.tile = {}
	tileset.tile = {
		w = 16,
		h = 16,
	}
	
	quads = {}
	
	for i = 0, tileset.rows - 1 do
		for j = 0, tileset.cols - 1 do
			table.insert(
				quads,
				love.graphics.newQuad(
					tileset.margin + j * (tileset.tile.w + tileset.spacing),
					tileset.margin + i * (tileset.tile.h + tileset.spacing),
					tileset.tile.w, tileset.tile.h, tileset.w, tileset.h
				)
			)
		end
	end

	--[[================]]
	--[[======MENU======]]
	
	rooms.Menu:addButton('play', default_font, 1,
		function() curr_room = rooms.Game end,
		gw / 2 - (default_font:getWidth('play')) / 2, 100
	)
		
	rooms.Menu:addButton('exit', default_font, 1,
		function() love.event.quit() end,
		gw / 2 - (default_font:getWidth('exit')) / 2, 120
	)
	
	rooms.Menu:addButton('black and white', default_font, 1.5,
		function() end, 
		gw / 2 - (default_font:getWidth('black and white')) / 2 * 1.5, 50
	)
	
	rooms.Menu:addButton('move: arrow keys', default_font, 0.8,
		function() end, gw / 2 - default_font:getWidth('action: arrow keys') / 2 * 0.8, 
		gh - default_font:getHeight() * 2 
	)
	
	rooms.Menu:addButton('action: x', default_font, 0.8,
		function() end, gw / 2 - default_font:getWidth('action: x') / 2 * 0.8, 
		gh - default_font:getHeight() 
	)
	
	--[[================]]
	--[[======GAME======]]
	rooms.Game.stages = {
		tutorial = newStage(
			{{2, 5, 5, 1, 3}}, 
			7, 2, 1, 
			{{x = 5, y = 1}}, {{x = 1, y = 1}}
		),
		
		newStage(
			{
				{5, 5, 4, 5, 5},
				{5, 5, 2, 5, 5},
				{5, 2, 5, 5, 5},
				{5, 5, 2, 5, 5},
				{4, 5, 5, 5, 4},
			},
			7, 4, 3, --index, x, y
			{ --zeroes
				{},
			}, 
			{ --ones
				{x = 3, y = 1},
				{x = 1, y = 5},
				{x = 5, y = 5},
			}
		),
		
		
	}
	
	player = {
		index = 0,
		tile_x = 0,
		tile_y = 0,
	} 

	--[[================]]
	--[[======OVER======]]
	rooms.Over:addButton('restart', default_font, 1,
		function() curr_room = rooms.Game end,
		gw / 2 - (default_font:getWidth('restart')) / 2, 100
	)
	
	rooms.Over:addButton('menu', default_font, 1,
		function() curr_room = rooms.Menu end,
		gw / 2 - (default_font:getWidth('menu')) / 2, 120
	)
	
	
	
	select_arrow = {
		padding = 16,
		index = 8,
		curr_opt = 1
	}
	select_arrow.x = curr_room.buttons[select_arrow.curr_opt].x - select_arrow.padding
	select_arrow.y = curr_room.buttons[select_arrow.curr_opt].y
	
	curr_stage = rooms.Game.stages.tutorial
	once = true
	passedStage = false
	stage_number = 0
	
	--[[================]]
end

function love.update(dt)
	timer:update(dt)

	if curr_room then 
		curr_room:update(dt) 
		if curr_room == rooms.Menu or curr_room == rooms.Over then
			select_arrow.x = curr_room.buttons[select_arrow.curr_opt].x - select_arrow.padding
			select_arrow.y = curr_room.buttons[select_arrow.curr_opt].y
		end
		
		if curr_room == rooms.Game then
			if once then
				player.index = curr_stage.index
				player.tile_x = curr_stage.x
				player.tile_y = curr_stage.y
				once = false
			elseif passedStage == true then
				passedStage = false
				once = true
				stage_number = stage_number + 1
				if stage_number >= 5 then
					curr_room = room.Menu
				else
					curr_room = rooms.Game.stages[stage_number]
				end
			end
			
			
			
			local total_zeroes = #curr_stage.zeroes
			local total_ones = #curr_stage.ones
			for i, row in ipairs(curr_stage.level) do
				for j, tile in ipairs(row) do 
					if curr_stage.level[i][j] == 1 then --if it is a zero at a zero spot
						for index, v in ipairs(curr_stage.zeroes) do
							if v.x == j and v.y == i then
								total_zeroes = total_zeroes - 1
							end
						end
					elseif curr_stage.level[i][j] == 2 then --if it is a one at a one spot
						for index, v in ipairs(curr_stage.ones) do
							if v.x == j and v.y == i then
								total_ones = total_ones - 1
							end
						end
					end
				end
			end
			
			if total_ones == 0 and total_zeroes == 0 then
				passedStage = true
			end
		end
	end
	--if input:pressed('menu') then curr_room = rooms.Menu end
	--if input:pressed('game') then curr_room = rooms.Game end
	--if input:pressed('over') then curr_room = rooms.Over end
	-- if input:pressed('CircleRoom') then gotoRoom('CircleRoom', 'room1') end
	-- if input:pressed('RectangleRoom') then gotoRoom('RectangleRoom', 'room2') end
	-- if input:pressed('PolygonRoom') then gotoRoom('PolygonRoom', 'room3') end
	
	--if input:down('test', 0.5) then print('test event') end
	
	--[[ 
	if input:pressed('test') then print('pressed') end
    if input:released('test') then print('released') end
    if input:down('test') then print('down') end 
	]]
end

function love.draw()
	love.graphics.setCanvas(display.main_canvas)
	love.graphics.clear()
	
	
	if curr_room then 
		curr_room:draw() 
		if curr_room == rooms.Menu or curr_room == rooms.Over then
			love.graphics.draw(tileset.image, quads[select_arrow.index], select_arrow.x, select_arrow.y)
		end
		
		if curr_room == rooms.Game then
			local spacing = 4
			local level_h = 16 * #curr_stage.level + spacing * #curr_stage.level
			local level_w = 16 * #curr_stage.level[1] + spacing * #curr_stage.level[1]
			for i, row in ipairs(curr_stage.level) do
				for j, tile in ipairs(row) do
					if tile ~= 0 then
						love.graphics.draw(tileset.image, quads[tile], 
							gw / 2 - level_w / 2 + (j - 1) * 16 + (j - 1) * spacing, 
							gh / 2 - level_h / 2 + (i - 1) * 16 + (i - 1) * spacing
						)
					end 
				end
			end
			love.graphics.rectangle('line', 
				gw / 2 - level_w / 2 - spacing / 2, 
				gh / 2 - level_h / 2 - spacing / 2,
				level_w + spacing / 2,
				level_h + spacing / 2
			)
			
			
			love.graphics.draw(tileset.image, quads[player.index], 
				gw / 2 - level_w / 2 + (player.tile_x - 1) * 16 + (player.tile_x - 1) * spacing, 
				gh / 2 - level_h / 2 + (player.tile_y - 1) * 16 + (player.tile_y - 1) * spacing
			)
			
			if curr_stage.level == rooms.Game.stages.tutorial.level then
				local size = 
					tileset.tile.w + spacing + 
					default_font:getWidth('and') + spacing +
					tileset.tile.w + spacing + 
					default_font:getWidth('are you')
				local xpos = gw / 2 - size / 2
				local ypos = gh / 10
				
				love.graphics.draw(tileset.image, quads[7], xpos, ypos)
				xpos = xpos + tileset.tile.w + spacing
				love.graphics.print('and', xpos, ypos)
				xpos = xpos + default_font:getWidth('and') + spacing
				love.graphics.draw(tileset.image, quads[6], xpos, ypos)
				xpos = xpos + tileset.tile.w + spacing
				love.graphics.print('are you', xpos, ypos)
				
				
				size = 
					tileset.tile.w + spacing +
					default_font:getWidth('and') + spacing +
					tileset.tile.w + spacing +
					default_font:getWidth('repel each other')
				xpos = gw / 2 - size / 2
				ypos = ypos + 20
				
				love.graphics.draw(tileset.image, quads[2], xpos, ypos)
				xpos = xpos + tileset.tile.w + spacing
				love.graphics.print('and', xpos, ypos)
				xpos = xpos + default_font:getWidth('and') + spacing
				love.graphics.draw(tileset.image, quads[1], xpos, ypos)
				xpos = xpos + tileset.tile.w + spacing
				love.graphics.print('repel each other', xpos, ypos)
				
				size = default_font:getWidth('the same attract')
				xpos = gw / 2 - size / 2
				ypos = ypos + 20
				love.graphics.print('the same attract', xpos, ypos)
				
				size = 
					default_font:getWidth('get') + spacing +
					tileset.tile.w + spacing +
					default_font:getWidth('to') + spacing +
					tileset.tile.w + spacing
				xpos = gw / 2 - size / 2
				ypos = ypos + 100
				love.graphics.print('get', xpos, ypos)
				xpos = xpos + default_font:getWidth('get') + spacing 
				love.graphics.draw(tileset.image, quads[2], xpos, ypos)
				xpos = xpos + tileset.tile.w + spacing
				love.graphics.print('to', xpos, ypos)
				xpos = xpos + default_font:getWidth('to') + spacing 
				love.graphics.draw(tileset.image, quads[4], xpos, ypos)
				xpos = xpos + tileset.tile.w + spacing
				
				size = 
					default_font:getWidth('get') + spacing +
					tileset.tile.w + spacing +
					default_font:getWidth('to') + spacing +
					tileset.tile.w + spacing
				xpos = gw / 2 - size / 2
				ypos = ypos + 20
				love.graphics.print('get', xpos, ypos)
				xpos = xpos + default_font:getWidth('get') + spacing 
				love.graphics.draw(tileset.image, quads[1], xpos, ypos)
				xpos = xpos + tileset.tile.w + spacing
				love.graphics.print('to', xpos, ypos)
				xpos = xpos + default_font:getWidth('to') + spacing 
				love.graphics.draw(tileset.image, quads[3], xpos, ypos)
				xpos = xpos + tileset.tile.w + spacing
				
				size = default_font:getWidth('restart with r') + spacing
				xpos = gw / 2 - size / 2
				ypos = ypos + 20
				love.graphics.print('restart with r', xpos, ypos)
			end
		end
	end
	
	
	love.graphics.setCanvas()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setBlendMode('alpha', 'premultiplied')
	love.graphics.draw(display.main_canvas, 0, 0, 0, sx, sy)
	love.graphics.setBlendMode('alpha')
end

function love.keypressed(key)
	if curr_room then 
		curr_room:keypressed(key) 
	end
end

function love.keyreleased(key)
	--print(key)
	if curr_room then
		if curr_room == rooms.Menu or curr_room == rooms.Over then
			if key == 'up' then
				select_arrow.curr_opt = select_arrow.curr_opt - 1
			elseif key == 'down' then
				select_arrow.curr_opt = select_arrow.curr_opt + 1
			end
			
			if select_arrow.curr_opt <= 0 then
				select_arrow.curr_opt = 1
			elseif select_arrow.curr_opt >= 3 then
				select_arrow.curr_opt = 2
			end
			
			if key == 'escape' then
				love.event.quit()
			end
			
			if key == 'x' then
				curr_room.buttons[select_arrow.curr_opt].action()
			end
		end
		
		if curr_room == rooms.Menu or curr_room == rooms.Game then
			if key == 'f1' then
				if curr_room == rooms.Menu then
					curr_room = rooms.Game
				end
				curr_stage = rooms.Game.stages.tutorial
				player.index = curr_stage.index
				player.tile_x = curr_stage.x
				player.tile_y = curr_stage.y
			elseif key == 'f2' then
				if curr_room == rooms.Menu then
					curr_room = rooms.Game
				end
				curr_stage = rooms.Game.stages[1]
				player.index = curr_stage.index
				player.tile_x = curr_stage.x
				player.tile_y = curr_stage.y
			end
		end
		
		local x, y = player.tile_x, player.tile_y
		if curr_room == rooms.Game then
			if key == 'left' then
				x = x - 1
			elseif key == 'right' then
				x = x + 1
			elseif key == 'up' then
				y = y - 1
			elseif key == 'down' then
				y = y + 1
			end
			
			if isOk(x, y) then
				-- push, pull, be pushed
				-- local y1 = {-1, 0, 1,  0}
				-- local x1 = { 0, 1, 0, -1}
				
				-- local y2 = {-1, -1, -1, 0, 1, 1,  1,  0}
				-- local x2 = {-1,  0,  1, 1, 1, 0, -1, -1}
				
				-- local opposite
				-- if player.index == 6 then
					-- opposite = 2
				-- elseif player.index == 7 then
					-- opposite = 1
				-- end
				-- -- local dif.x = 
				-- -- local dif.y = 
				
				-- local further = {x = nil, y = nil}
				-- local view = {}
				-- view.up = curr_stage.level[player.tile_y - 1][player.tile_x]
				-- view.up.dir.y = -1
				-- view.right = curr_stage.level[player.tile_y][player.tile_x + 1]
				-- view.right.dir.x = 1
				-- view.down = curr_stage.level[player.tile_y + 1][player.tile_x]
				-- view.down.dir.y = 1
				-- view.left = curr_stage.level[player.tile_y][player.tile_x - 1]
				-- view.left.x = -1
				
				-- for k, v in pairs(view) do
					-- if v then
					-- --[[if v == player.index - 5 then 
						-- --to implement in further versions
					-- else]]
					
					-- if v == opposite then
						-- local dir = {}
						-- if v.dir.y then
							-- dir.y = v.dir.y * -1
						-- elseif v.dir.x then
							-- dir.x = v.dir.x * -1
						-- end
						
						-- if dir.y then
							-- if curr_stage.level[player.tile_y + dir.y][player.tile_x] == op then
								
							-- end
						-- elseif dir.x then
							-- if curr_stage.level[player.tile_y][player.tile_x + dir.y] then
							
							-- end
						-- end
					-- end
					
					-- end
				-- end
				
				-- local player_detect_tile = {}
				-- player_detect_tile[player.index] = {}
				-- --local player_one_tile = {}
				-- local zero_tile = {}
				-- local one_tile = {}
				
				-- for i = 1, 4 do -- near the 
					-- if curr_stage.level[player.tile_y + y1[i]][player.tile_x + x1[i]] == player.index then --is a zero
						-- --player_detect_tile[player.index][math.fmod()] = player.index - 4
						-- --player_detect_tile[player.index].y = y
						-- --player_detect_tile[player.index]
					-- end
				-- end
				
				-- if curr_stage.level[y][x] == player.index - 4 then
					-- top = {x = x, y, = y}
				-- end
				
				-- for i = 1, 4 do
					-- if curr_stage.level[y + y1[i]][x + x1[i]] == 2 then --is a zero
						-- zero_tile[i].x = x + x1[i]
						-- zero_tile[i].y = y + y1[i]
					-- elseif curr_stage.level[y + y1[i]][x + x1[i]] == 1 then --is a one
						-- one_tile[i].x = x + x1[i]
						-- one_tile[i].y = y + y1[i]
					-- end
				-- end
				
				player.tile_x = x
				player.tile_y = y
			end
		
			if key == 'x' then
				if player.index == 7 then
					player.index = 6
				else
					player.index = 7
				end
			end
			
			if key == 'r' then
				curr_stage.level = curr_stage.restart
				player.index = curr_stage.index
				player.tile_x = curr_stage.x
				player.tile_y = curr_stage.y
			end
		
			if key == 'escape' then
				curr_room = rooms.Menu
			end
		end
	end
end

function isOk(x, y)
	--print(x, y)
	if y >= 1 and y <= #curr_stage.level then
		return curr_stage.level[y][x] == 3 or
			curr_stage.level[y][x] == 4 or
			curr_stage.level[y][x] == 5
	end
end

-- function saveGame()
	-- data = {}
	
	-- data.curr_stage = curr_stage
	
	-- serialized = lume.serialize(data)
	-- love.filesystem.write('savedata.io', serialized)
-- end

-- function love.mousepressed(x, y, button)
	-- if curr_room then curr_room:mousepressed(x, y, button) end
-- end

-- function love.mousereleased(x, y, button)
	-- if curr_room then curr_room:mousereleased(x, y, button)	end
-- end