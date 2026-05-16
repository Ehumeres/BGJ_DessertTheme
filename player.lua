--lets us use oop like coding
local Player = Object:extend()

function Player:new(x, y)
    self.x = x
    self.y = y
    self.vx = 0
    self.vy = 0
    self.direction = 1 --1 means its facing right and -1 means its facing left
    self.speed = 250
    self.width = 32
    self.height = 32
    self.gravity = 800
    self.fallMultiplier = 2
    self.lowJumpMultiplier = 1.4
    self.grounded = false
    self.jumpBuffer = 0
    self.jumpBufferTime = 0.11
    self.isAttacking = false
    self.attackDuration = 0.15
    self.attackTimer = 0
    self.attackCooldown = 0.4
    self.cooldownTimer = 0
    world:add(self, self.x, self.y, self.width, self.height)
end

--sets jumpBuffer greater than zero
function Player:keypressed(key)
    if key == "w" or key == "up" then
        self.jumpBuffer = self.jumpBufferTime
    end
    if key == "i" or key == "c" then
        self:attack() 
    end
end


function Player:attack()
    if self.isAttacking or self.cooldownTimer > 0 then return end
    
    self.isAttacking = true
    self.attackTimer = self.attackDuration
    self.cooldownTimer = self.attackCooldown

    local range = 40
    local height = 20
    
    local attackX
    if self.direction == 1 then
        attackX = self.x + self.width
    else
        attackX = self.x - range      
    end
    local attackY = self.y + (self.height / 4) 

    local items, len = world:queryRect(attackX, attackY, range, height)
    
    for i, item in ipairs(items) do
        if item ~= self and item.isEnemy then
            item:takeDamage(10) 
        end
    end
end

function Player:update(dt)
    local gravity = self.gravity
    -- makes it you fall faster than you jump better for game feel
    if self.vy > 0 then
        gravity = self.gravity * self.fallMultiplier
    end

    if self.vy < 0 and not love.keyboard.isDown("w", "up") then
        gravity = self.gravity * self.lowJumpMultiplier
    end

    self.vy = self.vy + gravity * dt
    self.jumpBuffer = math.max(0, self.jumpBuffer - dt)

    if self.attackTimer > 0 then
        self.attackTimer = self.attackTimer - dt
        if self.attackTimer <= 0 then
            self.isAttacking = false
        end
    end

    if self.cooldownTimer > 0 then
        self.cooldownTimer = self.cooldownTimer - dt
    end

    self.vx = 0
    if love.keyboard.isDown("a", "left") then
        self.vx = -self.speed
        self.direction = -1
    end
    if love.keyboard.isDown("d", "right") then
        self.vx = self.speed
        self.direction = 1
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
                -- how high you want the player to jump
                self.vy = -320
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
    if self.isAttacking then
        love.graphics.setColor(1, 0, 0, 0.6) 
        
        local range = 40
        local height = 20
        local attackX = (self.direction == 1) and (self.x + self.width) or (self.x - range)
        local attackY = self.y + (self.height / 4)
        
        love.graphics.rectangle("fill", attackX, attackY, range, height)
    end
    -- sets colour back to default if you dont do this everything would have same colour as our player
    love.graphics.setColor(1, 1, 1)
end

return Player
