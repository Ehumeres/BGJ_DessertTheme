--since lua doesnt have oop this adds oop to lua
Object = require "libs.classic"
--- since love2d doesnt have collision checks this adds that to love2d in a way
bump = require "libs.bump"
-- this lets you resize window
local push = require "libs.push"

Camera = require "camera"

-- this is the virutal width and height I chose 320x180 since you can multiply by intger values to get 1080p and 4k
VIRTUAL_WIDTH, VIRTUAL_HEIGHT = 426, 240

--creates a world for checking collision you have to put everything you want to have collisions with in the world
world = bump.newWorld()

local player = {}

--this is temporary platform when we are making levels will use something like tiled so everyone on the team can make levels its also easier to make levels visually than with code unless you do procedural gen thats pretty fun to code but its diffcult
platform = { x = 0, y = 170, width = 320, height = 20 }

world:add(platform, platform.x, platform.y, platform.width, platform.height)

function love.load()
    -- this is for making sure the game isnt blurry this uses nearest neighbour filitering which is best for pixel art games
    love.graphics.setDefaultFilter("nearest", "nearest")
    -- this is just for setting up the screen resolution like the game is in 320x180 but when the screen is made its 640x360 although it can be scaled to anything else probably when we publish it we will just make it fullscreen but now its easier to test with and stuff on a lower resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, 852, 480, { fullscreen = false, vsync = true, resizable = true })
    local Player = require "player"
    player = Player(160, 90)
    camera = Camera(VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

function love.keypressed(key)
    player:keypressed(key)
end

-- gets whatever value the user resizes the window into and then give it to push so push can resize it
function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    player:update(dt)
    camera:update(player.x, player.y, dt)
end

--push start and finish is for drawing everything youd want to get resized which would be everything so put everything in push start and finish
--everything you want to listen to camera youd put inbetween apply and clear for ui like player health youd want to put it under camera:clear()
function love.draw()
    push:start()
    camera:apply()

    player:draw()
    love.graphics.rectangle("fill", platform.x, platform.y, platform.width, platform.height)

    camera:clear()
    --for stuff you dont want camera to effect like ui put here and below
    push:finish()
end
