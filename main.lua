-- balloontap

require "io"

-- creates background and centers it
local background = display.newImageRect("background.png", 360, 570)
background.x = display.contentCenterX
background.y = display.contentCenterY

-- creates platform and positions it
local platform = display.newImageRect("platform.png", 350, 50)
platform.x = display.contentCenterX
platform.y = display.contentHeight + 25

-- creates balloon with slight transparency
local balloon = display.newImageRect("balloon.png", 112, 112)
balloon.x = display.contentCenterX
balloon.y = display.contentCenterY
balloon.alpha = 0.8

-- adds physics
local physics = require("physics")
physics.start()

physics.addBody(platform, "static")
physics.addBody(balloon, "dynamic", { radius = 50, bounce = 0.3 })
    -- to fully remove bounce of objects, remove from object & platform

-----------------------------------------------------------------------

local tapCount = 0
local highScore = 0

-- opens file in read mode
-- *a means it iterates over everything in file for the assignment
local file = io.open("highScore.txt", "r")
if file then
    highScore = tonumber(file:read("*a")) or 0
    io.close(file)
end

local tapText = display.newText(
    tapCount, display.contentCenterX, 20, native.systemFont, 40)

tapText:setFillColor(0, 0, 0)

local highScoreText = display.newText( 
    highScore, display.contentCenterX, 60, native.systemFont, 20)

highScoreText:setFillColor(0, 0, 0)
    
local function pushBalloon()
    balloon:applyLinearImpulse(0, -0.5, balloon.x, balloon.y)
    tapCount = tapCount + 1
    tapText.text = tapCount
end
    
local function onLocalCollision(self, event)
    if tapCount > highScore then
        highScore = tapCount
        highScoreText.text = highScore
        file = io.open("highScore.txt", "w")
        if file then
            file:write(highScore)
            io.close(file)
        end
    end
    tapCount = 0
    tapText.text = tapCount
end

balloon:addEventListener("tap", pushBalloon)
balloon.collision = onLocalCollision
balloon:addEventListener("collision")
