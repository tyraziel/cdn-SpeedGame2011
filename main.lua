---------------------------------------------------------------------------------------
-- Project: SpeedGame-2011 Christian Dev Network
--
-- Name of Game: Project Z
--
-- Date: Aug 6, 2011
--
-- Version: 1.0
--
-- File name: main.lua
--
-- Code type: Speed Game
--
-- Author: Tyraziel (Andrew Potozniak)
--
-- Released with the following lisense -
-- CC BY-NC-SA 3.0
-- http://creativecommons.org/licenses/by-nc-sa/3.0/
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

system.activate( "multitouch" )

--Setup the onExit Listener
local onSystem = function( event )
  if event.type == "applicationExit" then
    if system.getInfo( "environment" ) == "device" then
      -- prevents iOS 4+ multi-tasking crashes
      os.exit()
    end
  end
end
Runtime:addEventListener( "system", onSystem )

--Setup the HUD and JoyStick and some other debugging stuff
local hudGroup = display.newGroup()

local debugOverworld = display.newRect(40, 20, 400, 280)
debugOverworld.strokeWidth = 3
debugOverworld:setFillColor(0, 0, 0)
debugOverworld:setStrokeColor(180, 180, 0)

hudGroup:insert(debugOverworld)

local centerDot = display.newImage("center_dot.png", 0, 0)
local center_dot_x = 55
local center_dot_y = 270
local dpad_touched = false
centerDot:setReferencePoint(display.CenterReferencePoint)
centerDot.x = center_dot_x
centerDot.y = center_dot_y

local dPad = display.newImage("d_pad.png", 0, 0)
dPad.x = 55
dPad.y = 270
dPad:setReferencePoint(display.CenterReferencePoint)

function dPadTouch(event)
  local t = event.target
  local phase = event.phase

  if(phase == "began" and not dpad_touched) then
    dpad_touched = true
    centerDot.x = event.x
    centerDot.y = event.y
    display.getCurrentStage():setFocus(t, event.id)  
  elseif(phase == "moved") then
    if(dpad_touched) then
      local x = event.x - dPad.x
      local y = event.y - dPad.y
    
      if(x > dPad.width / 2) then
        x = dPad.width / 2
      elseif(x < (dPad.width / -2))then
        x = dPad.width / -2
      end
      if(y > dPad.height / 2) then
        y = dPad.height / 2
      elseif(y < dPad.height / -2) then
        y = dPad.height / -2
      end    
    
      centerDot.x = center_dot_x + x
      centerDot.y = center_dot_y + y
    end
  elseif(phase == "ended" or phase == "cancelled") then
    dpad_touched = false
    centerDot.x = center_dot_x
    centerDot.y = center_dot_y
    display.getCurrentStage():setFocus( t, nil )
  end
    
  return true
  
end

dPad:addEventListener("touch", dPadTouch)

hudGroup:insert(centerDot)
hudGroup:insert(dPad)

local debugDPad = display.newRoundedRect(10, 10, 15, 15, 2)
debugDPad.strokeWidth = 3
debugDPad:setFillColor(0, 0, 0)
debugDPad:setStrokeColor(180, 0, 0)

local debugGlobalTouch = display.newRoundedRect(10, 30, 15, 15, 2)
debugGlobalTouch.strokeWidth = 3
debugGlobalTouch:setFillColor(0, 0, 0)
debugGlobalTouch:setStrokeColor(0, 0, 180)

local global_touch = false

hudGroup:insert(debugDPad)
hudGroup:insert(debugGlobalTouch)

--Hero Co-ords
local debugXLabel = display.newText("X: ", 340, 5, native.systemFont, 12)
debugXLabel:setTextColor(255, 255, 255)

local debugXText = display.newText("0", 420, 5, native.systemFont, 12)
debugXText:setTextColor(255, 255, 255)

local debugYLabel = display.newText("Y: ", 340, 20, native.systemFont, 12)
debugYLabel:setTextColor(255, 255, 255)

local debugYText = display.newText("0", 420, 20, native.systemFont, 12)
debugYText:setTextColor(255, 255, 255)

hudGroup:insert(debugXLabel)
hudGroup:insert(debugXText)
hudGroup:insert(debugYLabel)
hudGroup:insert(debugYText)

--MainGroup Co-ords
local debugMGXLabel = display.newText("MGX: ", 340, 35, native.systemFont, 12)
debugMGXLabel:setTextColor(255, 255, 255)

local debugMGXText = display.newText("0", 420, 35, native.systemFont, 12)
debugMGXText:setTextColor(255, 255, 255)

local debugMGYLabel = display.newText("MGY: ", 340, 50, native.systemFont, 12)
debugMGYLabel:setTextColor(255, 255, 255)

local debugMGYText = display.newText("0", 420, 50, native.systemFont, 12)
debugMGYText:setTextColor(255, 255, 255)

hudGroup:insert(debugMGXLabel)
hudGroup:insert(debugMGXText)
hudGroup:insert(debugMGYLabel)
hudGroup:insert(debugMGYText)

--World Co-ords
local debugWXLabel = display.newText("WX: ", 340, 65, native.systemFont, 12)
debugWXLabel:setTextColor(255, 255, 255)

local debugWXText = display.newText("0", 420, 65, native.systemFont, 12)
debugWXText:setTextColor(255, 255, 255)

local debugWYLabel = display.newText("WY: ", 340, 80, native.systemFont, 12)
debugWYLabel:setTextColor(255, 255, 255)

local debugWYText = display.newText("0", 420, 80, native.systemFont, 12)
debugYText:setTextColor(255, 255, 255)

hudGroup:insert(debugWXLabel)
hudGroup:insert(debugWXText)
hudGroup:insert(debugWYLabel)
hudGroup:insert(debugWYText)

--Physics Engine
local physics = require 'physics'
physics.start()
physics.setGravity(0, 0)

--physics.setDrawMode( "debug" ) -- shows collision engine outlines only
--physics.setDrawMode( "hybrid" ) -- overlays collision outlines on normal Corona objects
--physics.setDrawMode( "normal" ) -- the default Corona renderer, with no collision outlines

--Main Group
local mainGroup = display.newGroup()

--local hero = display.newImage("poc_arrow.png", 0, 0)
local hero = display.newRoundedRect(0, 0, 16, 16, 2)
hero:setReferencePoint(display.CenterReferencePoint)
hero.strokeWidth = 3
hero:setFillColor(0, 0, 0)
hero:setStrokeColor(255, 255, 255)
hero.x = 240
hero.y = 160
hero.rotation = 90
--local triangleShape = { 0,-10, 10,10, -10,10}
physics.addBody(hero,{density=0.0, friction=0.0, bounce=0.0})

hero.what = "Hero" -- help to know what this is for the event listener

hero.isFixedRotation = true
hero.isSensor = true --allows things to pass through

--Setup other spaceship things
hero.isInvincible = false
hero.invincibleTimeToLive = 2500
hero.invincibleTimeLived = 0 -- invincible time 
hero.rateOfMovement = 2.25

--Add spaces ship to main group
mainGroup:insert(hero)

--Enemy Bullets
local enemyBullets = {}

--Enemies
local enemies = {}

--Game Content
local gameContent = {
  --{what = "tree", enterAt=25, enterX=500, enterY=150, moveX=40, moveY=0, yMin=0, yMax=0, fireEvery=1000, bullets=1, bulletSpeed=150, hits=1, points=5},
}

local worldLandscape = {
  {what = "tree", worldX = 5, worldY = 5, areaX = 0, areaY = 0, passable=false},
  {what = "tree", worldX = 5, worldY = 5, areaX = 1, areaY = 0, passable=false},
  {what = "tree", worldX = 5, worldY = 5, areaX = 2, areaY = 0, passable=false}
}

local function initWorldLandscape(worldLandscape, mainGroup)

  for index, landscape in pairs(worldLandscape) do
    local landScapeObject = display.newRect( (landscape.worldX * 400 + 40) + (landscape.areaX * 8), (landscape.worldY * 280 + 20) + (landscape.areaY * 8), 8, 8)
    landScapeObject.strokeWidth = 1
    landScapeObject:setFillColor(0, 0, 0)
    landScapeObject:setStrokeColor(128, 255, 128)
    landScapeObject.alpha = 1.0
    mainGroup:insert(landScapeObject)
  end

end

initWorldLandscape(worldLandscape, mainGroup)

local gameState = {gameOver = false, paused = false, story = false, worldScrolling = false, overWorld = true}

local gameTimer = {lastTime = 0}

local startWorldX = 5
local startWorldY = 5

local worldScroll = {currentX = startWorldX, currentY = startWorldY, toX = startWorldX, toY = startWorldY, 
                     rateX = 250, rateY = 250, shiftX = 400, shiftY = 280, 
                     remaningShiftX = 0, remainingShiftY = 0}

--world cell is 50x35 assuming 8pixels per square

--might want to turn this into a function call
hero.x = hero.x + worldScroll.currentX * worldScroll.shiftX
hero.y = hero.y + worldScroll.currentY * worldScroll.shiftY
mainGroup.x = mainGroup.x - worldScroll.currentX * worldScroll.shiftX
mainGroup.y = mainGroup.y - worldScroll.currentY * worldScroll.shiftY

local function collideWithHero( self, event )

  if ( event.phase == "began" and not self.isInvincible) then
    if(event.other.what == "Enemy" or 
       event.other.what == "EnemyBullet" or
       event.other.what == "Boss") then

      lifeTotal = lifeTotal - 1
      self.isInvincible = true
      self.invincibleTimeLived = 0
	
	  if(event.other.what ~= "Boss") then
        event.other:removeSelf()
      end

      if(lives < 1)then
        gameState.gameOver = true
      end

    elseif(event.other.what == "Item") then
      --powerup goodness?
    end
  
    --print( "SPACE SHIP: "..self.what .. ": collision began with " .. event.other.what )
  elseif (self.isInvincible) then
    --print ("INVINCIBLE")
  end
  
end

hero.collision = collideWithHero
hero:addEventListener( "collision", hero )

local function spaceShipBulletCollideWithEnemy(self, event)
  if ( event.phase == "began") then
    --print("BULLET: ".. self.what .. ": collision began with " .. event.other.what )
  
    if(event.other.what == "Enemy") then

	  event.other.hitsLeft = event.other.hitsLeft - 1
	  
	  --do some cool color change
	  event.other.alpha = event.other.hitsLeft / 2
	  
	  
	  if(event.other.hitsLeft < 1) then
	    --print("REMOVE")
	    event.other.isVisible = false
	    event.other:removeSelf()
	    --event.other = nil
	    self:removeSelf()
	    
	    score = score + event.other.points
	  else
	  	self:removeSelf()
	    score = score + 5
	  end
    end
  
    --print("BULLET: ".. self.what .. ": collision began with " .. event.other.what )
  end
end


--Global Touch Event for Sword Attack
function globalTouch(event)
  local t = event.target
  local phase = event.phase

  if(phase == "began") then
	global_touch = true
	
	--fire bullet if not invincible
--	if(not spaceShip.isInvincible) then
	  --Fire Bullet
--	  local shipBullet = display.newCircle(spaceShip.x + 10, spaceShip.y+1, 3) 
    
--      physics.addBody(shipBullet)
--      shipBullet.isBullet = true
--      shipBullet.isSensor = true
--      shipBullet.what = "Bullet"
--      shipBullet:setLinearVelocity( 150, 0 )
    
--      shipBullet:setFillColor(255, 255, 255)
	  
--	  shipBullet.collision = spaceShipBulletCollideWithEnemy
--      shipBullet:addEventListener( "collision", shipBullet )

--      table.insert(shipBullets,shipBullet)
	
--	  mainGroup:insert(shipBullet)
--	end
	
  end
  if(phase == "ended") then
    global_touch = false
  end
  
  return true
end

Runtime:addEventListener("touch", globalTouch) 

local function gameLoop(event)
  local timeSinceLastCall = event.time - gameTimer.lastTime
  local secondsElapsed = timeSinceLastCall / 1000
  local millisElapsed = timeSinceLastCall
  
  gameTimer.lastTime = event.time

  debugXText.text = math.floor(hero.x)
  debugYText.text = math.floor(hero.y)

  debugWXText.text = worldScroll.currentX  
  debugWYText.text = worldScroll.currentY

  debugMGXText.text = math.floor(mainGroup.x)
  debugMGYText.text = math.floor(mainGroup.y)
  
  if(not gameState.gameOver) then
    if(not gameState.paused and not gameState.worldScrolling) then
  
      --only move guy if dpad_touched
      if (dpad_touched) then
        debugDPad:setFillColor(140, 0, 0)
  
        local dx = (centerDot.x - center_dot_x)
        local dy = (centerDot.y - center_dot_y)

        local val = -dy / dx
  
        local deg = 90-math.deg(math.atan(val))
  
        hero.deg = deg
        --hero.rotation = deg   -- this will rotate the hero in the "heading"
  
        if((deg >= 45 and deg <= 135) or (deg >= 225 and deg <= 315)) then
          hero.x = hero.x + dx * secondsElapsed * hero.rateOfMovement
        else
          hero.y = hero.y + dy * secondsElapsed * hero.rateOfMovement
        end 
      else
	    debugDPad:setFillColor(0, 0, 0)
      end
  
      if(global_touch)then
        debugGlobalTouch:setFillColor(0, 0, 140)
      else
        debugGlobalTouch:setFillColor(0, 0, 0)
      end
      
      if(hero.x < worldScroll.currentX * 400 + 40) then -- 480 = Screen width, 40 = how close to the edge
        hero.x = worldScroll.currentX * 400 + 40
          
        if(gameState.overWorld) then        
          gameState.worldScrolling = true
          worldScroll.toX = worldScroll.currentX - 1
          worldScroll.remainingShiftX = worldScroll.shiftX --- 440 - 40 - 5 for tollerance
        end
          
      elseif(hero.x > worldScroll.currentX * 400 + 440) then -- 440 = how close to the edge
        hero.x = worldScroll.currentX * 400 + 440
        
        if(gameState.overWorld) then        
          gameState.worldScrolling = true
          worldScroll.toX = worldScroll.currentX + 1
          worldScroll.remainingShiftX = worldScroll.shiftX
        end
      end
      
      if(hero.y < worldScroll.currentY * 280 + 20) then -- 320 = screen height, 20 = how close to the edge
        hero.y = worldScroll.currentY * 280 + 20
        
        if(gameState.overWorld) then
          gameState.worldScrolling = true
          worldScroll.toY = worldScroll.currentY - 1
          worldScroll.remainingShiftY = worldScroll.shiftY
        end
      elseif(hero.y > worldScroll.currentY * 280 + 300) then -- 300 = how close to the edge
        hero.y = worldScroll.currentY * 280 + 300
        
        if(gameState.overWorld) then
          gameState.worldScrolling = true
          worldScroll.toY = worldScroll.currentY + 1
          worldScroll.remainingShiftY = worldScroll.shiftY
        end
      end
      
    elseif(not gameState.paused and gameState.worldScrolling and gameState.overWorld) then -- We need to scroll the world
      local movement = secondsElapsed * worldScroll.rateX

      if(worldScroll.currentX ~= worldScroll.toX) then
        worldScroll.remainingShiftX = worldScroll.remainingShiftX - movement
      
        if(worldScroll.currentX < worldScroll.toX) then
          mainGroup.x = mainGroup.x - movement
        elseif(worldScroll.currentX > worldScroll.toX) then 
          mainGroup.x = mainGroup.x + movement        
        end
        
        if(worldScroll.remainingShiftX < 0)then
          worldScroll.currentX = worldScroll.toX
          gameState.worldScrolling = false
          
          mainGroup.x = worldScroll.currentX * -worldScroll.shiftX
          --Fix location here
        end
        
      elseif(worldScroll.currentY ~= worldScroll.toY) then
        worldScroll.remainingShiftY = worldScroll.remainingShiftY - movement
      
        if(worldScroll.currentY < worldScroll.toY) then
          mainGroup.y = mainGroup.y - movement
        elseif(worldScroll.currentY > worldScroll.toY) then 
          mainGroup.y = mainGroup.y + movement        
        end
        
        if(worldScroll.remainingShiftY < 0)then
          worldScroll.currentY = worldScroll.toY
          gameState.worldScrolling = false
          
          mainGroup.y = worldScroll.currentY * -worldScroll.shiftY
          --Fix location here
        end
      end

    --mainGroup.
    
    else --PAUSED
    
    end
  else -- GAMEOVER

  end
  
end

Runtime:addEventListener( "enterFrame", gameLoop )