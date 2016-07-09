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
 
sound = {}
sound.muted = false
sound.bgm = nil
sound.bgmtrack = nil

sound.volume = 80  -- 0>100 (used when a track is played)

sound.music = {}
sound.music[1] = "sfx/music/zhelanov/space.ogg" -- title sound
sound.music[2] = "sfx/music/maxstack/tst/lose.ogg" -- game over sound
sound.music[3] = "sfx/music/maxstack/nebula.ogg"
sound.music[4] = "sfx/music/maxstack/through-space.ogg"
sound.music[5] = "sfx/music/maxstack/crystal-space.ogg"
sound.music[6] = "sfx/music/maxstack/bazaarnet.ogg"
sound.music[7] = "sfx/music/maxstack/the-client.ogg"
sound.music[8] = "sfx/music/maxstack/deprecation.ogg"
sound.music[9] = "sfx/music/maxstack/inevitable.ogg"
sound.music[10] = "sfx/music/maxstack/mediathreat.ogg"

	
love.audio.setVolume( 1 )--master volume


function sound:playbgm(n)
	if sound.muted then return true end
	if sound.bgm then sound.bgm:stop() end
	sound.bgmtrack = n
	sound.bgm = love.audio.newSource(sound.music[n])
	sound.bgm:setVolume(sound.volume/100)
	sound.bgm:play()
	sound.bgm:setLooping(true)
end


function sound:play(sfx)
	if sound.muted then return true end
	
	if sfx:isPlaying() then
		sfx:stop()
	end
	sfx:play()
end
