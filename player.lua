--lets us use oop like coding
local Player = Object:extend()

function Player:new(x, y)
    self.x = x
    self.y = y
    self.vx = 0
    self.vy = 0
    self.speed = 150
    self.width = 16
    self.height = 16
    self.gravity = 500
    self.grounded = false
    self.jumpBuffer = 0
    self.jumpBufferTime = 0.1
    world:add(self, self.x, self.y, self.width, self.height)
end

function Player:keypressed(key)
    if key == "w" or key == "up" then
        self.jumpBuffer = self.jumpBufferTime
    end
end

function Player:update(dt)
    self.vy = self.vy + self.gravity * dt
    self.jumpBuffer = math.max(0, self.jumpBuffer - dt)

    self.vx = 0
    if love.keyboard.isDown("a", "left") then
        self.vx = -self.speed
    end
    if love.keyboard.isDown("d", "right") then
        self.vx = self.speed
    end

    local goalX = self.x + self.vx * dt
    local goalY = self.y + self.vy * dt

    local TrueX, TrueY, cols = world:move(self, goalX, goalY)

    self.x = TrueX
    self.y = TrueY

    self.grounded = false
    for i, col in ipairs(cols) do
        if col.normal.y < 0 then
            self.grounded = true
            self.vy = 0

            if self.jumpBuffer > 0 then
                self.vy = -200
                self.grounded = false
                self.jumpBuffer = 0
            end

            break
        end
    end
end

function Player:draw()
    -- sets colour of the rectangle basically
    love.graphics.setColor(1, 0.7, 0.4)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    -- changes it back to white so platform is that colour if this wasnt done then platform wouldve also been that colour
    love.graphics.setColor(1, 1, 1)
end

return Player
