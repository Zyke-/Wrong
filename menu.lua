----------------------------------------------------------------------------------
--
-- Menu
--
----------------------------------------------------------------------------------

local composer = require "composer" 
local api = require "modules.api"
local scene = composer.newScene()

local sceneGroup = {}

local c
local b
local l
local pdw
local pup

---------------------------------------------------------------------------------

function scene:create( event )
	sceneGroup = self.view
	c = {1, 1, 1}
	b = rect(b, centerX, centerY, W, H, c, true)
	l = display.newImage("src/logo.jpg", centerX, -centerY)
	pdw = display.newImage("src/pdw.jpg", centerX, centerY+50)
	pup = display.newImage("src/pup.jpg", centerX, H+centerY)
	pdw.active = true
	pup.active = true
	pdw.isVisible = false
	
	pup:addEventListener( "touch", pup )

	function pup:touch( e )
		if pdw.active or pup.active then
			if e.phase == "began" then
				display.getCurrentStage():setFocus(e.target)
				pdw.isVisible = true
				pup.isVisible = false

			elseif e.phase == "cancelled" then
				display.getCurrentStage():setFocus(nil)
				pup.isVisible = true
				pdw.isVisible = false
				
			elseif e.phase == "ended" then
				display.getCurrentStage():setFocus(nil)
				pup.isVisible = true
				pdw.isVisible = false
				transition.to(pdw, {delay = 150, onComplete = play()}) 
			end
		end
	end

	function play ( e )
		pup.active = false
		pdw.active = false
		pup.isVisible = false
		pdw.isVisible = false

		local opt = {effect = "slideLeft", time = 800}
		composer.showOverlay( "game" , opt)
	end
	-- add display objects to 'sceneGroup', add touch listeners, etc.
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		

	elseif phase == "did" then
		transition.to( l, { time = 1500, y = l.height+50, transition = easing.outExpo } )
		transition.to( pup, { time = 1250, y = centerY+50, transition = easing.outExpo, delay = 1000 } )
		
		-- start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene