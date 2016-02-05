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


require("title")
require("misc")
require("pickups")
require("binds")
require("ship")
require("starfield")
require("enemies")
require("collision")
require("hud")
require("music")

debug = false


function love.load(args)
	--parse command line arguments to the game
	for _,arg in pairs(args) do
		if arg == "-debug" or arg == "-d" then debug = true end
		if arg == "-fullscreen" or arg == "-f" then love.window.setFullscreen(1) end
	end
	
	--initialize seed
	math.randomseed(os.time())

	game = {}
	game.width, game.height, game.flags = love.window.getMode( )
	
	--display configuration
	if not game.flags.vsync then
		max_fps = 200
		min_dt = 1/max_fps
		next_time = love.timer.getTime()
	end


	icon = love.image.newImageData( "gfx/icon.png")
	love.window.setIcon( icon )

	
	cursor = love.mouse.newCursor( "gfx/cursor.png", 0, 0 )
	love.mouse.setCursor(cursor)	

	--fonts
	fonts = {
		default = love.graphics.newFont("fonts/0xa000/0xA000-Squareish-Mono.ttf",12),
		timer = love.graphics.newFont("fonts/0xa000/0xA000-Squareish-Mono-Bold.ttf",20),
		hud = love.graphics.newFont("fonts/0xa000/0xA000-Squareish-Mono-Bold.ttf",12),
		paused_large = love.graphics.newFont("fonts/0xa000/0xA000-Squareish-Mono-Bold.ttf",40),
		paused_small = love.graphics.newFont("fonts/0xa000/0xA000-Squareish-Mono-Bold.ttf",14),
		title_large = love.graphics.newFont("fonts/0xa000/0xA000-Squareish-Mono-Bold.ttf",70),
		title_select = love.graphics.newFont("fonts/0xa000/0xA000-Squareish-Mono-Bold.ttf",20)
	}
	

	--game init
	paused = false
	invincible = false

	title:init()
	--initarcade()
	
end


--test function
function initarcade()
	love.mouse.setVisible(false)
	love.mouse.setGrabbed(true)
	paused = false
	
	mode = "arcade"
	love.graphics.setBackgroundColor(0,255,0,255)
	nebulae.r = 0
	nebulae.g = 255
	nebulae.b = 255
	ship:init()
	starfield.speed = 1.5
	starfield:populate()
	hud:init()
	
	music:play(math.random(2,#music))

end

function love.update(dt)
	--cap fps
	if not game.flags.vsync then
		next_time = next_time + min_dt
    end
	

	--process arcade game mode
	if mode == "arcade" then
		starfield:update(dt)
		enemies:update(dt)
		ship:update(dt)
		pickups:update(dt)
		hud:update(dt)
	end
	
	--process titlescreen
	if mode == "title" then
		title:update(dt)
	end
	
	--process the debug console
	hud:updateconsole(dt)

end




function love.draw()
	--draw arcade game
	if mode == "arcade" then
		starfield:draw(0,0)
		ship:draw()
		hud:draw()
	end
	
	
	--draw title screen
	if mode == "title" then
		title:draw()
	end
	
	--draw the debug console
	hud:drawconsole()
	
	-- caps fps
	if not game.flags.vsync then
		local cur_time = love.timer.getTime()
		if next_time <= cur_time then
			next_time = cur_time
			return
		end
		love.timer.sleep(next_time - cur_time)
	end
end




function love.keypressed(key)
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

