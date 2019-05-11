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

name = "Star Phase"
author = "ricky thomson"
version = 0.07
build = "-dev"
print (name .. " " .. version .. build .. " by " .. author)

function love.conf(t)
	t.version = "11.0"
	t.identity = "starphase"
	t.window.title = name .. " " .. version .. build
	t.window.width = 1920/2
	t.window.height = 1080/2
	t.window.minwidth = 960
	t.window.minheight = 540
	t.modules.joystick = false
	t.modules.physics = false
	t.window.msaa = 0
	t.window.resizable = true
	t.window.vsync = true
	t.window.fullscreen = false
	t.window.fullscreentype = "desktop"
	t.window.icon = "gfx/icon.png"
end
