local System         = require 'systems.system'
local Tween          = require 'utils.tween'
local AudioComponent = require 'components.audio'

-- vector  = require 'lib.hump.vector'

local AudioMixer = class({})
AudioMixer:include(System)

function AudioMixer:init( state )
    System.init(self,state)

    self.sfx_dir   = 'assets/audio/sfx/'
    self.music_dir = 'assets/audio/music/'

    local settings = require('settings')
    self.settings  = settings.AUDIO

    self.sfx   = {}
    self.music = {}

    local sfx_files   = love.filesystem.getDirectoryItems(self.sfx_dir)
    local music_files = love.filesystem.getDirectoryItems(self.music_dir)

    for i,filename in ipairs(sfx_files) do
        if love.filesystem.isFile(self.sfx_dir..filename) then
            self:add_sfx(filename)
        end
    end

    for i,filename in ipairs(music_files) do
        if love.filesystem.isFile(self.music_dir..filename) then
            self:add_music(filename)
        end
    end

    local songs = _.keys(self.music)
    self.music[songs[love.math.random(1,#songs)]]:play()
end

function AudioMixer:run( dt )
    -- look for new bullets
    for i,e in ipairs(self.event_queue) do
        print('audio event:',e.name,e.ent)

        local file = e.ent.audio[e.name]

        if self.sfx[file]:isPlaying() then
            self.sfx[file]:rewind()
        else
            self.sfx[file]:play()
        end
    end

    -- FLUSH
    self.event_queue = {}
end

function AudioMixer:build_component( layer, obj, comp_data )
    local c = AudioComponent(layer, obj, comp_data)
    for event,sound_file in pairs(c) do
        self:listen_for(event)
        print('Listening for audio event:',event)
    end
    return c
end

function AudioMixer:add_sfx(sound_file)
    -- The static tells it to slurp into memory, not dynamically
    -- We'll do this for small files (like sound effects)
    local s = love.audio.newSource(self.sfx_dir..sound_file, 'static')
    s:setVolume(self.settings.SFX_VOLUME)
    print('adding sfx:', sound_file)
    self.sfx[sound_file] = s
end

function AudioMixer:add_music(music_file)
    -- ... for the big files, we'll stream them from the disk
    -- (granted, even these are small right now)
    local s = love.audio.newSource(self.music_dir..music_file)
    s:setLooping(true) -- for now?
    s:setVolume(self.settings.MUSIC_VOLUME)
    print('adding music:', music_file)
    self.music[music_file] = s
end

return AudioMixer