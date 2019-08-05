local Room = Object:extend()

function Room:new(name)
	self.name = name
	self.buttons = {}
	--self.area = Area(self)
	--self.main_canvas = love.graphics.newCanvas(gw, gh)
end

function Room:update(dt)
	--self.area:update(dt)
end

function Room:draw()
	for _, v in ipairs(self.buttons) do
		love.graphics.print(v.text, v.x, v.y, 0, v.size, v.size)
	end

	-- love.graphics.setCanvas(self.main_canvas)
	-- love.graphics.clear()
	-- love.graphics.circle('line', gw/2, gh/2, 50)
    -- self.area:draw()
	-- love.graphics.print('0 - 1 - 2 - 3', 0, 0)
	-- love.graphics.setCanvas()
	
	-- love.graphics.setColor(1, 1, 1, 1)
	-- love.graphics.setBlendMode('alpha', 'premultiplied')
	-- love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
	-- love.graphics.setBlendMode('alpha')
end

function Room:addButton(text, font, size, fn, x, y)
	table.insert(self.buttons, {
			action = fn,
			text = text,
			font = font,
			size = size,
			x = x,
			y = y,
		}
	)
end

function Room:keypressed(key)
	
end

function Room:keyreleased(key)
	--print(self.name, key)
end

function Room:mousepressed(x, y, button)
	
end

function Room:mousereleased(x, y, button)

end

return Room