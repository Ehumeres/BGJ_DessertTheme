--since lua doesnt have oop this adds oop to lua
Object = require "libs.classic"
--- since love2d doesnt have collision checks this adds that to love2d in a way
bump = require "libs.bump"

Camera = require 'libs.Camera'

--creates a world for checking collision you have to put everything you want to have collisions with in the world
world = bump.newWorld()

local player = {}

--this is temporary platform when we are making levels will use something like tiled so everyone on the team can make levels its also easier to make levels visually than with code unless you do procedural gen thats pretty fun to code but its diffcult
platform = { x = 0, y = 170, width = 320, height = 20 }

world:add(platform, platform.x, platform.y, platform.width, platform.height)

function love.load()
    -- this is for making sure the game isnt blurry this uses nearest neighbour filitering which is best for pixel art games
    love.graphics.setDefaultFilter("nearest", "nearest")
    local Player = require "player"
    player = Player(160, 90)
    camera = Camera()
    camera:setFollowLerp(0.2)
    camera:setFollowStyle('PLATFORMER')
end

function love.keypressed(key)
    player:keypressed(key)
end

function love.update(dt)
    camera:update(dt)
    camera:follow(player.x, player.y)
    player:update(dt)
end

--push start and finish is for drawing everything youd want to get resized which would be everything so put everything in push start and finish
function love.draw()
    camera:attach()

    player:draw()
    love.graphics.rectangle("fill", platform.x, platform.y, platform.width, platform.height)
    camera:detach()
end