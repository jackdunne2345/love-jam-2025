-- Configuration file for LÖVE
function love.conf(t)
    t.title = "My First Love2D Game"    -- The title of the window
    t.version = "11.4"                   -- The LÖVE version this game was made for
    t.window.width = 800                 -- Game window width
    t.window.height = 600                -- Game window height
    -- For debugging
    t.console = true                     -- Enable console output (Windows only)
    -- Modules to include
    t.modules.audio = true               -- Enable the audio module
    t.modules.event = true               -- Enable the event module
    t.modules.graphics = true            -- Enable the graphics module
    t.modules.image = true               -- Enable the image module
    t.modules.joystick = true            -- Enable the joystick module
    t.modules.keyboard = true            -- Enable the keyboard module
    t.modules.math = true                -- Enable the math module
    t.modules.mouse = true               -- Enable the mouse module
    t.modules.sound = true               -- Enable the sound module
    t.modules.system = true              -- Enable the system module
    t.modules.timer = true               -- Enable the timer module
    t.modules.window = true              -- Enable the window module
    t.modules.thread = true              -- Enable the thread module
end 