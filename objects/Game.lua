local Object = require "libraries.classic.classic"
local push = require "libraries.push.push"

local Room = love.filesystem.load("objects/Room.lua")

local Game = Object:extend()

function Game:new(w, h)
	--[[============================= general ================================]]

	love.math.getRandomSeed(os.time())
	love.graphics.setDefaultFilter("nearest", "nearest")

	--[[========================== attributes ================================]]

	self.width, self.height = w, h
	
	self.window = {}
	self.window.width, self.window.height = love.graphics.getDimensions()
	self.window.width = self.window.width * .5
	self.window.height = self.window.height * .5
	
	self.font = love.graphics.newFont("resources/fonts/VCR_OSD_MONO.ttf", 12, "mono")
	
	self.current_room = nil
	self.rooms_names = {"Menu", "Game", "Over"}
	self.rooms = {}
	
	--[[=========================== setting up ===============================]]
	
	love.graphics.setFont(self.font)
	
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