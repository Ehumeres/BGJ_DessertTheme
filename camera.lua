local Object = require "libs.classic"

local Camera = Object:extend()

function Camera:new(virtual_width, virtual_height)
    self.x = 0
    self.y = 0

    self.virtual_width = virtual_width
    self.virtual_height = virtual_height

    self.deadzoneX = 17
    self.deadzoneY = 40

    self.shakeIntensity = 0
    self.shakeTime = 0
    self.shakeX = 0
    self.shakeY = 0
end

--takes the values you set in like you can do if player gets hurt maybe do camera:shake(3,0.3) 3 would be the intensity and 0.3 would be the duration
function Camera:shake(intensity, duration)
    self.shakeIntensity = intensity
    self.shakeTime = duration
end

function Camera:update(targetX, targetY, dt)
    --this the following player part
    local targetCamX = targetX - self.virtual_width / 2
    local targetCamY = targetY - self.virtual_height / 2

    local diffX = targetCamX - self.x
    local diffY = targetCamY - self.y

    if math.abs(diffX) > self.deadzoneX then
        self.x = targetCamX - self.deadzoneX * (diffX > 0 and 1 or -1)
    end

    if math.abs(diffY) > self.deadzoneY then
        self.y = targetCamY - self.deadzoneY * (diffY > 0 and 1 or -1)
    end
    --camera shake this actually is the true code
    if self.shakeTime > 0 then
        self.shakeTime = self.shakeTime - dt

        local intensity = self.shakeIntensity * (self.shakeTime / 0.2)

        self.shakeX = (math.random() * 2 - 1) * intensity
        self.shakeY = (math.random() * 2 - 1) * intensity
    else
        self.shakeX = 0
        self.shakeY = 0
    end
end

--everything you want to listen to camera youd put inbetween apply and clear
function Camera:apply()
    love.graphics.push()
    love.graphics.translate(-self.x + self.shakeX, -self.y + self.shakeY)
end

function Camera:clear()
    love.graphics.pop()
end

return Camera
