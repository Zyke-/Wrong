----------------------------------------------------------------------------------
--
-- Wrong!				
-- Vince Games API 2013-2014
--
----------------------------------------------------------------------------------


local api = require "modules.api"
local composer = require "composer"

function init()
	Version = "0.1b"
	Build = loadValue("build.data")
	Build = (Build + 1)--*0
	saveValue("build.data", tostring(Build))
	firstPlay = false

	print("\nWrong")
	print("Version: " .. getVesion(), "\n")
	main()
end

function main()
	local imgBackground = display.newRect( 0, 0, W, H )
	imgBackground:setFillColor( white )

	if firstPlay then
		--composer.gotoScene( "tutorial" )
	else
		local opt = {time = 800}
		composer.gotoScene( "menu" , opt)
	end
end

init()


