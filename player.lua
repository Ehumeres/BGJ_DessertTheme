--lets us use oop like coding
local Player = Object:extend()

function Player:new(x, y)
    self.x = x
    self.y = y
    self.vx = 0
    self.vy = 0
    self.speed = 150
    self.width = 32
    self.height = 32
    self.gravity = 800
    self.grounded = false
    self.jumpBuffer = 0
    self.jumpBufferTime = 0.11
    world:add(self, self.x, self.y, self.width, self.height)
end
--sets jumpBuffer greater than zero 
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
    -- since we using bump lua for collisions we want to set a goal and then have bump calculate if something blocks us\
    -- if something blocks us TrueX and TrueY wont equal GoalX GoalY since theyre is something in the way
    local goalX = self.x + self.vx * dt
    local goalY = self.y + self.vy * dt

    local TrueX, TrueY, cols = world:move(self, goalX, goalY)

    self.x = TrueX
    self.y = TrueY

    self.grounded = false
    for i, col in ipairs(cols) do
        --this checks if your feet are touching ground everything hear only occurs if you are touching ground 
        if col.normal.y < 0 then
            self.grounded = true
            self.vy = 0
            --if jumpBuffer greater than zero then perform jump 
            if self.jumpBuffer > 0 then
                self.vy = -300
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
    -- sets colour back to default if you dont do this everything would have same colour as our player
    love.graphics.setColor(1, 1, 1)
end

return Player
