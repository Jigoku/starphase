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
 
music = {}

love.audio.setVolume( 1 )--master volume

music.volume = 80  -- 0>100 (used when a track is played)
	
music[1] = "sfx/music/zhelanov/space.ogg" -- title music
music[2] = "sfx/music/maxstack/tst/lose.ogg" -- game over music
music[3] = "sfx/music/maxstack/nebula.ogg"
music[4] = "sfx/music/maxstack/through-space.ogg"
music[5] = "sfx/music/maxstack/crystal-space.ogg"
music[6] = "sfx/music/maxstack/bazaarnet.ogg"
music[7] = "sfx/music/maxstack/the-client.ogg"
music[8] = "sfx/music/maxstack/deprecation.ogg"
	
music.bgm = nil
music.track = nil

function music:play(track)
	if music.bgm then music.bgm:stop() end
	music.track = track
	music.bgm = love.audio.newSource(music[music.track])
	music.bgm:setVolume(music.volume/100)
	music.bgm:play()
	music.bgm:setLooping(true)
end
