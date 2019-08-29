local Object = require "libraries.classic.classic"
local push = require "libraries.push.push"
local utils = require "utils"

-- TODO: use the lua stdlib
local Room = love.filesystem.load("objects/Room.lua") 

local Game = Object:extend()

function Game:new(w, h)
	--[[============================= general ================================]]

	love.math.getRandomSeed(os.time())
	-- crispy texture loading
	love.graphics.setDefaultFilter("nearest", "nearest") 

	--[[========================== attributes ================================]]

	--the width and height of the game
	self.width, self.height = w, h
	
	self.window = {}
	self.window.width, self.window.height = love.graphics.getDimensions()
	self.window.width = self.window.width * .5
	self.window.height = self.window.height * .5
	
	self.joysticks = love.joystick.getJoysticks()
	
	self.tileset = {}
	self.tileset.image = love.graphics.newImage("resources/tilesets/monochrome.png")
	self.tileset.width = self.tileset.image:getWidth()
	self.tileset.height = self.tileset.image:getHeight()
	self.tileset.margin = 1
	self.tileset.spacing = 2
	self.tileset.rows = 3
	self.tileset.cols = 3
	
	self.tile = {}
	self.tile.width = (self.tileset.width / self.tileset.cols) - self.tileset.spacing
	self.tile.height = (self.tileset.height / self.tileset.rows) - self.tileset.spacing
	
	self.quads = {}
	
	self.CONST = {}
	self.CONST.zero = 1
	self.CONST.one = 2
	self.CONST.zeroGoal = 3
	self.CONST.oneGoal = 4
	self.CONST.empty = 5
	self.CONST.zeroHeart = 6
	self.CONST.oneHeart = 7
	self.CONST.arrow = 8
	self.CONST.AButton = 9
	self.CONST.spacing = 4
	
	self.font = love.graphics.newImageFont("resources/fonts/pixel.png",
		" abcdefghijklmnopqrstuvwxyz" ..
		":.%"
	)
	
	self.current_room = nil
	--self.rooms_names = {"Menu", "Game", "Over"}
	self.rooms = {}
	
	--[[=========================== setting up ===============================]]
	
	if self.joysticks then
		utils.joystick_details(self.joysticks[1])
	end
	
	love.graphics.setFont(self.font)
	
	-- makes the quads
	for i = 0, self.tileset.rows - 1 do
		for j = 0, self.tileset.cols - 1 do
			table.insert(self.quads,
				love.graphics.newQuad(
					1 + j * (self.tile.width + self.tileset.spacing),
					1 + i * (self.tile.height + self.tileset.spacing),
					self.tile.width, self.tile.height,
					self.tileset.width, self.tileset.height
				)
			)
		end
	end
	
	-- push library
	push:setupScreen(self.width, self.height, 
		self.window.width, self.window.height,
		{
			fullscreen = false,
			resizable = true,
			pixelperfect = true
		}
	)
	push:setBorderColor{0, 0, 0} -- the default anyways
	
	--[[======================================================================]]

end

function Game:update(dt)
	if self.current_room then
		self.rooms[self.current_room]:update(dt)
	end
end

function Game:draw()
	push:start()
	
	if self.current_room then
		self.rooms[self.current_room]:draw()
	end
	
	push:finish()
end

function Game:keypressed(key, scancode, isrepeat)
	if key == "f11" then
		push:switchFullscreen()
	end
	
	if self.current_room then
		self.rooms[self.current_room]:keypressed(key, scancode, isrepeat)
	end
end

function Game:keyreleased(key)
	if self.current_room then
		self.rooms[self.current_room]:keyreleased(key)
	end
end

function Game:resize(w, h)
	push:resize(w, h)
end

function Game:addRoom(room) --string as room name
	if not self.rooms[room] then
		self.rooms[room] = Room(room)
	else
		print("there already is a room like:", room)
	end
end

function Game:gotoRoom(room)
	if self.rooms[room] then
		self.current_room = room
	else
		print("there is no room like:", room)
	end
end

return Game