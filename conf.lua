io.stdout:setvbuf('no')

gw = 300
gh = 240
resz = 3
sx = resz
sy = resz


function love.conf(t)
	t.version = '11.2'                  -- The L�VE version this game was made for (string)
    
 
    t.window.title = 'black and white'     	   -- The window title (string)
    t.window.icon = 'res/icon/b&w.png' 	   -- Filepath to an image to use as the window's icon (string)
    t.window.width = gw * sx	           -- The window width (number)
    t.window.height = gh * sy	           -- The window height (number)
    t.window.vsync = -1                    -- Vertical sync mode (number)
 
    -- t.modules.audio = true              -- Enable the audio module (boolean)
    -- t.modules.data = true               -- Enable the data module (boolean)
    -- t.modules.event = true              -- Enable the event module (boolean)
    -- t.modules.font = true               -- Enable the font module (boolean)
    -- t.modules.graphics = true           -- Enable the graphics module (boolean)
    -- t.modules.image = true              -- Enable the image module (boolean)
    -- t.modules.joystick = true           -- Enable the joystick module (boolean)
    -- t.modules.keyboard = true           -- Enable the keyboard module (boolean)
    -- t.modules.math = true               -- Enable the math module (boolean)
    -- t.modules.mouse = true              -- Enable the mouse module (boolean)
    -- t.modules.physics = true            -- Enable the physics module (boolean)
    -- t.modules.sound = true              -- Enable the sound module (boolean)
    -- t.modules.system = true             -- Enable the system module (boolean)
    -- t.modules.thread = true             -- Enable the thread module (boolean)
    -- t.modules.timer = true              -- Enable the timer module (boolean), Disabling it will result 0 delta time in love.update
    -- t.modules.touch = true              -- Enable the touch module (boolean)
    -- t.modules.video = true              -- Enable the video module (boolean)
    -- t.modules.window = true             -- Enable the window module (boolean)
end