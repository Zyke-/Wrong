----------------------------------------------------------------------------------
--
-- Results
--
----------------------------------------------------------------------------------

local composer = require "composer" 
local api = require "modules.api"
local scene = composer.newScene()

local sceneGroup = {}

---------------------------------------------------------------------------------

function scene:create( event )
	sceneGroup = self.view
	score = event.params.score

	local c = {1, 1, 1}
	local b, s, sopt, hup, hdw, rup, rdw
	local sopt = {
		parent = qbox,
		text = tostring(score) .. "  Points",     
		x = centerX,
		y = (centerY-250)/1.5,
		width = W-10,     
		font = native.systemFontBold,   
		fontSize = 40,
		align = "center" }

	b = rect(b, centerX, centerY, W, H, c, true)
	s = display.newText( sopt )
	s:setFillColor( 0, 0, 0 )

	hdw = display.newImage("src/hdw.png", 0, centerY)	setPos(hdw, hdw.width, centerY)
	hup = display.newImage("src/hup.png", 0, centerY)	setPos(hup, hup.width, centerY)

	rdw = display.newImage("src/rdw.png", 0, centerY)	setPos(rdw, W-rdw.width, centerY)
	rup = display.newImage("src/rup.png", 0, centerY)	setPos(rup, W-rup.width, centerY)

	hdw.active = true
	hup.active = true
	rdw.active = true
	rup.active = true

	hdw.isVisible = false
	rdw.isVisible = false
	
	hup:addEventListener( "touch", hup )
	rup:addEventListener( "touch", hup )

	function hup:touch( e )
		if hdw.active or hup.active then
			if e.phase == "began" then
				display.getCurrentStage():setFocus(e.target)
				if e.target == hup then
					hdw.isVisible = true
					hup.isVisible = false
				elseif e.target == rup then
					rdw.isVisible = true
					rup.isVisible = false
				end				
			elseif e.phase == "ended" then
				display.getCurrentStage():setFocus(nil)
				if e.target == hup then
					hdw.isVisible = true
					hup.isVisible = false
					hup.active = false
					hdw.active = false
					local opt = {effect = "slideRight", time = 800}
					composer.gotoScene("menu", opt)
				elseif e.target == rup then
					rdw.isVisible = true
					rup.isVisible = false
					rup.active = false
					rdw.active = false
					local opt = {effect = "slideRight", time = 800}
					composer.hideOverlay(true, "results", opt)
				end
			end
		end
	end
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		
	elseif phase == "did" then
		
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