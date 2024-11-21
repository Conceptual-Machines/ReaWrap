-- @description FNG: Provide implementation for FNG functions.
-- @author NomadMonad
-- @license MIT

local r = reaper

local constants = require('constants')
local helpers = require('helpers')
local media_item_take = require('media_item_take')


local FNG = {}



--- Create new FNG instance.
-- @return FNG table.
function FNG:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--- Log messages with the FNG logger.
-- @param ... (varargs) Messages to log.
function FNG:log(...)
    local logger = helpers.log_func('FNG')
    logger(...)
    return nil
end

    
--- Add Midi Note.
-- [FNG] Add MIDI note to MIDI take
-- @param midi_take RprMidiTake
-- @return RprMidiNote
function FNG:add_midi_note(midi_take)
    return r.FNG_AddMidiNote(midi_take)
end

    
--- Alloc Midi Take.
-- [FNG] Allocate a RprMidiTake from a take pointer. Returns a NULL pointer if the
-- take is not an in-project MIDI take
-- @return RprMidiTake
function FNG:alloc_midi_take()
    return r.FNG_AllocMidiTake(self.pointer)
end

    
--- Count Midi Notes.
-- [FNG] Count of how many MIDI notes are in the MIDI take
-- @param midi_take RprMidiTake
-- @return integer
function FNG:count_midi_notes(midi_take)
    return r.FNG_CountMidiNotes(midi_take)
end

    
--- Free Midi Take.
-- [FNG] Commit changes to MIDI take and free allocated memory
-- @param midi_take RprMidiTake
function FNG:free_midi_take(midi_take)
    return r.FNG_FreeMidiTake(midi_take)
end

    
--- Get Midi Note.
-- [FNG] Get a MIDI note from a MIDI take at specified index
-- @param midi_take RprMidiTake
-- @param index integer
-- @return RprMidiNote
function FNG:get_midi_note(midi_take, index)
    return r.FNG_GetMidiNote(midi_take, index)
end

    
--- Get Midi Note Int Property.
-- [FNG] Get MIDI note property
-- @param midi_note RprMidiNote
-- @param property string
-- @return integer
function FNG:get_midi_note_int_property(midi_note, property)
    return r.FNG_GetMidiNoteIntProperty(midi_note, property)
end

    
--- Set Midi Note Int Property.
-- [FNG] Set MIDI note property
-- @param midi_note RprMidiNote
-- @param property string
-- @param value integer
function FNG:set_midi_note_int_property(midi_note, property, value)
    return r.FNG_SetMidiNoteIntProperty(midi_note, property, value)
end

return FNG
