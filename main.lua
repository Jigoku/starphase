--[[
 * Copyright (C) 2016 Ricky K. Thomson
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * u should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 --]]

require("misc")
require("binds")
require("collision")
require("sound")
require("screen/title")
require("screen/hud")
require("screen/fonts")
require("entities/pickups")
require("entities/enemies")
require("entities/explosions")
require("entities/player")
require("entities/projectiles")



function love.load(args)


	--love.math.setRandomSeed( os.time() )


	
	starfield = require("starfield")
	msgs = require("screen/messagebox")
	
	msgs.callback = function() print("end of message test") end

	debug = false
	debugarcade = false
	cheats = {
		invincible = false,
	}
	
	--parse command line arguments to the game
	for _,arg in pairs(args) do
		if arg == "-debug" or arg == "-d" then debug = true end
		if arg == "-fullscreen" or arg == "-f" then love.window.setFullscreen(1) end
	end
	


	game = {}
	game.width, game.height, game.flags = love.window.getMode( )
	game.seed = 133742069
	game.max_fps = 200--game.flags.refreshrate
	game.min_dt = 1/game.max_fps
	game.next_time = love.timer.getTime()
	
	game.scale = {}
	game.scale.w = 1920
	game.scale.h = 1080
	game.scale.x = love.graphics.getWidth()/game.scale.w
	game.scale.y = love.graphics.getHeight()/game.scale.h

	
	cursor = love.mouse.newCursor( "gfx/cursor.png", 0, 0 )
	love.mouse.setCursor(cursor)	

	sound:init()
	title:init()
	
end


--test function
function initarcade(playersel)
	love.mouse.setVisible(false)
	love.mouse.setGrabbed(true)
	paused = false
	debugarcade = false
	mode = "arcade"
	love.graphics.setBackgroundColor(0,0,0,255)
	
	--starfield.offset = love.graphics.getHeight()/3
	--starfield.nebulae.red = love.math.random(0,255)
	--starfield.nebulae.green = love.math.random(0,255)
	--starfield.nebulae.blue = love.math.random(0,255)
	player:init(playersel)
	--starfield.speed = 2
	starfield.speed = 10
	--starfield.offset = 300
	--starfield:populate()
	hud:init()

	local s = love.math.random(3,#sound.music)
	sound:playbgm(s)
end

function initdebugarcade(playersel)
	initarcade(playersel)
	debugarcade = true
	
	msgs.queue(
		{
			{		
				face = love.graphics.newImage("gfx/faces/1.png"),
				name = "Debug mode",
				text = "Message box test",
				duration = 2,
			},
			{		
				face = love.graphics.newImage("gfx/faces/2.png"),
				name = "Achievment unlocked!",
				text = "Absolutely nothing.",
				duration = 6,
			}
		}
	)
end


function love.update(dt)
	--cap fps

		--use this to slow down when setting < 60fps
		--dt = math.min(dt, game.min_dt)
		
	game.next_time = game.next_time + game.min_dt

	--process arcade game mode
	if mode == "arcade" then
		starfield:update(dt)
		projectiles:update(dt)
		enemies:update(dt)
		explosions:update(dt)
		player:update(dt)
		pickups:update(dt)
		hud:update(dt)
		msgs.update(dt)
	end
	
	--process titlescreen
	if mode == "title" then
		title:update(dt)
	end
	
	--process the debug console
	hud:updateconsole(dt)

end



	
function love.draw()
	--investigate this......
	--love.graphics.scale(game.scale.x,game.scale.y)
	
	--draw arcade game
	if mode == "arcade" then

		--starfield:draw(0,-player.y/4)
		starfield:draw(0,0)
		
		hud:draw()
		msgs.draw()
	end
	
	
	
	--draw title screen
	if mode == "title" then
		title:draw()
	end
	
	--draw the debug console
	hud:drawconsole()
	




	-- caps fps

	local cur_time = love.timer.getTime()
	if game.next_time <= cur_time then
		game.next_time = cur_time
		return
	end
	love.timer.sleep(game.next_time - cur_time)

end




function love.keypressed(key)
if key == "k" then pickups:add(200,200) end


	--global controls
	if key == binds.fullscreen then misc:togglefullscreen() end
	if key == binds.console then debug = not debug end
	
	--arcade mode controls
	if mode == "arcade" then
		if key == binds.pause then 
			misc:togglepaused()
		end
	
		if paused then
			if key == binds.pausequit then  title:init() end
		end
	end
	
	--title screen controls
	if mode == "title" then
		title:keypressed(key)
	end
	
	
	--debug enemy
	if debugarcade then
	if key == "1" then
		enemies:add_abomination()
	elseif key == "2" then
		enemies:add_asteroid()
	elseif key == "3" then
		enemies:add_crescent()
	elseif key == "4" then
		enemies:add_dart()
	elseif key == "5" then
		enemies:add_delta()
	elseif key == "6" then
		enemies:add_large()
	elseif key == "7" then
		enemies:add_train()
	elseif key == "8" then
		enemies:add_tri()
	end
	end
	--[[
	if key == "0" then
		love.window.setMode(1024,(game.scale.h/game.scale.w)*1024 )
	end
	
	if key == "9" then
		love.window.setMode(800,(game.scale.h/game.scale.w)*800 )
	end
	
	if key == "8" then
		love.window.setMode(1200,(game.scale.h/game.scale.w)*1200 )
	end
	
	--]]


end

function love.mousepressed(x,y,button) 

end


function love.focus(f)
	if f then
		print("Window focused.")
	else
		print("Window lost focused.")
		if mode == "arcade" then
			misc:pause()
		end
	end
end


function love.resize(w,h)
	
end

