-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()
local physics = require("physics")
physics.start()
physics.setGravity(0,0)


-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local stones = {}
local mainGroup
local stoneIsInside = true
local circlex
local circley
local function stone()
	if #stones < 10 and stoneIsInside == true then
		local stone = display.newImageRect(mainGroup, "stone.png", 20,20)
		table.insert(stones, stone)
		stone.x = display.contentCenterX
	    stone.y = display.contentHeight - 30
	    stone:addEventListener( "touch", touch )
		stone.myName = "stone"
		physics.addBody(stone, {radius=25, isSensor=true})
		stoneIsInside = false
		stone:toFront()
	end
end

local function makeCircle(x, y)
	local c1 = display.newCircle(mainGroup, x, y, 25)
    -- c1:setFillColor(0,0, 0, 0)
    c1:setFillColor(255,255, 255, 1)
    c1.myName = "circle"
    physics.addBody(c1, {radius=20, isSensor=true})
    c1:toBack()
end

function touch( event )
	local tihsstone = event.target
    if event.phase == "began" then
 		 print(tihsstone.myName)
        display.getCurrentStage():setFocus( tihsstone )
        tihsstone:toFront()
        tihsstone.isFocus = true
        tihsstone.x0 = event.x - tihsstone.x
		tihsstone.y0 = event.y - tihsstone.y
    elseif tihsstone.isFocus then
        if event.phase == "moved" then
 			tihsstone.x = event.x - tihsstone.x0
			tihsstone.y = event.y - tihsstone.y0
            -- print( "moved phase" )
 
        elseif event.phase == "ended" or event.phase == "cancelled" then
            display.getCurrentStage():setFocus( nil )
            tihsstone.isFocus = false
            if stoneIsInside then
	            tihsstone:removeEventListener("touch", touch)
	            tihsstone.x = circlex
	            tihsstone.y = circley
	        end
            stone()

        end
    end
 
    return true
end

local function onCollision( event )
 
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2
        
         if ( ( obj1.myName == "circle" and obj2.myName == "stone" ) or
             ( obj1.myName == "stone" and obj2.myName == "circle" ) )
        then
        	 stoneIsInside = true;
        	 print(obj1.x .. obj1.y)
        	 circlex = obj1.x
        	 circley = obj1.y
    	end
    elseif ( event.phase == "ended" ) then
    	stoneIsInside = false
    	 print(stoneIsInside)
    end
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	mainGroup = display.newGroup()
	sceneGroup:insert(mainGroup)
	local starImage = display.newImageRect(sceneGroup, "star.png", display.contentWidth, display.contentWidth)
	starImage.x = display.contentCenterX
    starImage.y = display.contentCenterY
    starImage:toBack()
    makeCircle(starImage.width-30, display.contentCenterY - 45)
    makeCircle(starImage.width*0.1, display.contentCenterY - 45)
    makeCircle(display.contentCenterX, display.contentCenterY - starImage.width / 2 + 10)
    makeCircle(display.contentCenterX, display.contentCenterY + starImage.width / 4 - 20)
    makeCircle(display.contentCenterX -35, display.contentCenterY - 45)
    makeCircle(display.contentCenterX + 35, display.contentCenterY - 45)
    makeCircle(display.contentCenterX + 50, display.contentCenterY + 20)
    makeCircle(display.contentCenterX - 50, display.contentCenterY + 20)
    makeCircle(display.contentCenterX - 90, display.contentCenterY + 125)
    makeCircle(display.contentCenterX + 90, display.contentCenterY + 125)
 	stone()
 	stoneIsInside = false
	-- Code here runs when the scene is first created but has not yet appeared on screen

end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		
		Runtime:addEventListener( "collision", onCollision )

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene

