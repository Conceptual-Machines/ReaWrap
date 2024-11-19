-- @description Provide ReaScript constants
-- @author NomadMonad

local constants = {}

constants.ImGui_InputTextFlag = {
     ImGui_InputTextFlags_AllowTabInput,
     ImGui_InputTextFlags_AlwaysOverwrite,
     ImGui_InputTextFlags_AutoSelectAll,
     ImGui_InputTextFlags_CharsDecimal,
     ImGui_InputTextFlags_CharsHexadecimal,
     ImGui_InputTextFlags_CharsNoBlank,
     ImGui_InputTextFlags_CharsScientific,
     ImGui_InputTextFlags_CharsUppercase,
     ImGui_InputTextFlags_CtrlEnterForNewLine
}

constants.PointerTypes = {
    ReaProject = 'ReaProject*',
    MediaTrack = 'MediaTrack*',
    MediaItem = 'MediaItem*',
    MediaItem_Take = 'MediaItem_Take*',
    TrackEnvelope = 'TrackEnvelope*',
    PCM_source = 'PCM_source*'
}

constants.ApplyFxFlags = {
    stereo = 0,
    mono = 1,
    multi_output = 2,
    midi = 3
}


constants.MsgBoxTypes = {
    OK = 0,
    OKCANCEL = 1,
    ABORTRETRYIGNORE = 2,
    YESNOCANCEL = 3,
    YESNO = 4,
    RETRYCANCEL = 5
}

constants.MsgBoxReturnTypes = {
    OK = 1,
    CANCEL = 2,
    ABORT = 3,
    RETRY = 4,
    IGNORE = 5,
    YES = 6,
    NO = 7
}

-- Accepted param values for Track:get_info_number(param)
-- Type for each param is documented (original ReaScript docs).
constants.TrackInfoValue = {
    B_MUTE = 'B_MUTE', --: boolean
    B_PHASE = 'B_PHASE', --: boolean : track phase inverted
    B_RECMON_IN_EFFECT = 'B_RECMON_IN_EFFECT', --: boolean : record monitoring in effect (current audio-thread playback state, read-only)
    IP_TRACKNUMBER = 'IP_TRACKNUMBER', --: number: track number 1-based, 0=not found, -1=master track (read-only, returns the numberdirectly)
    I_SOLO = 'I_SOLO', -- : number : soloed, 0=not soloed, 1=soloed, 2=soloed in place, 5=safe soloed, 6=safe soloed in place
    B_SOLO_DEFEAT = 'B_SOLO_DEFEAT', --: boolean : when set, if anything else is soloed and this track is not muted, this track acts soloed
    I_FXEN = 'I_FXEN', --: number : fx enabled, 0=bypassed, !0=fx active
    I_RECARM = 'I_RECARM', --: number : record armed, 0=not record armed, 1=record armed
    I_RECINPUT = 'I_RECINPUT', --[[
        number : record input, <0=no input. if 4096 set, input is MIDI and low 5 bits represent channel
        (0=all, 1-16=only chan), next 6 bits represent physical input (63=all, 62=VKB). If 4096 is not set, low 10 bits (0..1023)
        are input start channel (ReaRoute/Loopback start at 512).
        If 2048 is set, input is multichannel input (using track channel count),
        or if 1024 is set, input is stereo input, otherwise input is mono.
    --]]
    I_RECMODE = 'I_RECMODE', --[[
        : number : record mode,
        0=input, 1=stereo out, 2=none, 3=stereo out w/latency compensation,
        4=midi output, 5=mono out, 6=mono out w/ latency compensation, 7
        =midi overdub, 8=midi replace
    --]]
    I_RECMON = 'I_RECMON', --: number : record monitoring, 0=off, 1=normal, 2=not when playing (tape style)
    I_RECMONITEMS = 'I_RECMONITEMS', --: number : monitor items while recording, 0=off, 1=on
    B_AUTO_RECARM = 'B_AUTO_RECARM', --: boolean : automatically set record arm when selected (does not immediately affect recarm state, script should set directly if desired)
    I_AUTOMODE = 'I_AUTOMODE', --: number : track automation mode, 0=trim/off, 1=read, 2=touch, 3=write, 4=latch
    I_NCHAN = 'I_NCHAN', --: number : number of track channels, 2-64, even numbers only
    I_SELECTED = 'I_SELECTED', --: number : track selected, 0=unselected, 1=selected
    I_WNDH = 'I_WNDH', --: number : current TCP window height in pixels including envelopes (read-only)
    I_TCPH = 'I_TCPH', --: number : current TCP window height in pixels not including envelopes (read-only)
    I_TCPY = 'I_TCPY', --: number : current TCP window Y-position in pixels relative to top of arrange view (read-only)
    I_MCPX = 'I_MCPX', --: number : current MCP X-position in pixels relative to mixer container
    I_MCPY = 'I_MCPY', --: number : current MCP Y-position in pixels relative to mixer container
    I_MCPW = 'I_MCPW', --: number : current MCP width in pixels
    I_MCPH = 'I_MCPH', --: number : current MCP height in pixels
    I_FOLDERDEPTH = 'I_FOLDERDEPTH', --: number : folder depth change, 0=normal, 1=track is a folder parent, -1=track is the last in the innermost folder, -2=track is the last in the innermost and next-innermost folders, etc
    I_FOLDERCOMPACT = 'I_FOLDERCOMPACT', --: number : folder compacted state (only valid on folders), 0=normal, 1=small, 2=tiny children
    I_MIDIHWOUT = 'I_MIDIHWOUT', --: number : track midi hardware output index, <0=disabled, low 5 bits are which channels (0=all, 1-16), next 5 bits are output device index (0-31)
    I_PERFFLAGS = 'I_PERFFLAGS', --: number : track performance flags, &1=no media buffering, &2=no anticipative FX
    I_CUSTOMCOLOR = 'I_CUSTOMCOLOR', --: number : custom color, OS dependent color|0x100000 (i.e. ColorToNative(r,g,b)|0x100000). If you do not |0x100000, then it will not be used, but will store the color
    I_HEIGHTOVERRIDE = 'I_HEIGHTOVERRIDE', --: number : custom height override for TCP window, 0 for none, otherwise size in pixels
    B_HEIGHTLOCK = 'B_HEIGHTLOCK', --: boolean : track height lock (must set I_HEIGHTOVERRIDE before locking)
    D_VOL = 'D_VOL', --: number : trim volume of track, 0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc
    D_PAN = 'D_PAN', --: number : trim pan of track, -1..1
    D_WIDTH = 'D_WIDTH', --: number : width of track, -1..1
    D_DUALPANL = 'D_DUALPANL', --: number : dualpan position 1, -1..1, only if I_PANMODE==6
    D_DUALPANR = 'D_DUALPANR', --: number : dualpan position 2, -1..1, only if I_PANMODE==6
    I_PANMODE = 'I_PANMODE', --: number : pan mode, 0=classic 3.x, 3=new balance, 5=stereo pan, 6=dual pan
    D_PANLAW = 'D_PANLAW',  --: number : pan law of track, <0=project default, 1=+0dB, etc
    P_ENV = 'P_ENV', --:<envchunkname or P_ENV:{GUID... : TrackEnvelope * : (read-only) chunkname can be <VOLENV, <PANENV, etc; GUID is the stringified envelope GUID.
    B_SHOWINMIXER = 'B_SHOWINMIXER', -- : boolean : track control panel visible in mixer (do not use on master track)
    B_SHOWINTCP = 'B_SHOWINTCP', --: boolean : track control panel visible in arrange view (do not use on master track)
    B_MAINSEND = 'B_MAINSEND', ---: boolean : track sends audio to parent
    C_MAINSEND_OFFS = 'C_MAINSEND_OFFS', --: string : channel offset of track send to parent
    B_FREEMODE = 'B_FREEMODE', --: boolean : track free item positioning enabled (call UpdateTimeline() after changing)
    C_BEATATTACHMODE = 'C_BEATATTACHMODE', --: string : track timebase, -1=project default, 0=time, 1=beats (position, length, rate), 2=beats (position only)
    F_MCP_FXSEND_SCALE = 'F_MCP_FXSEND_SCALE', --: number* : scale of fx+send area in MCP (0=minimum allowed, 1=maximum allowed)
    F_MCP_FXPARM_SCALE = 'F_MCP_FXPARM_SCALE', --: number* : scale of fx parameter area in MCP (0=minimum allowed, 1=maximum allowed)
    F_MCP_SENDRGN_SCALE = 'F_MCP_SENDRGN_SCALE',  --: number* : scale of send area as proportion of the fx+send total area (0=minimum allowed, 1=maximum allowed)
    F_TCP_FXPARM_SCALE = 'F_TCP_FXPARM_SCALE',  --: number* : scale of TCP parameter area when TCP FX are embedded (0=min allowed, default, 1=max allowed)
    I_PLAY_OFFSET_FLAG = 'I_PLAY_OFFSET_FLAG',  --: number : track playback offset state, &1=bypassed, &2=offset value is measured in samples (otherwise measured in seconds)
    D_PLAY_OFFSET = 'D_PLAY_OFFSET', --: number : track playback offset, units depend on I_PLAY_OFFSET_FLAG
    P_PARTRACK = 'P_PARTRACK',  --: MediaTrack * : parent track (read-only)
    P_PROJECT = 'P_PROJECT', --: ReaProject * : parent project (read-only)
}

-- Accepted param values for Track:get_info_string(param)
-- Type for each param is documented (original ReaScript docs).
TrackInfoString = {
    P_NAME = 'P_NAME', --track name (on master returns NULL)
    P_ICON = 'P_ICON', --track icon (full filename, or relative to resource_path/data/track_icons)
    P_MCP_LAYOUT = 'P_MCP_LAYOUT', --layout name
    P_RAZOREDITS = 'P_RAZOREDITS', --list of razor edit areas, as space-separated triples of start time, end time, and envelope GUID string.
    P_TCP_LAYOUT = 'P_TCP_LAYOUT', --layout name
    P_EXT = 'P_EXT', --xyz
    GUID = 'GUID', --globally unique identifier
}

MediaItemInfoValue = {
    B_MUTE = 'B_MUTE', --boolean
    B_MUTE_ACTUAL = 'B_MUTE_ACTUAL', --boolean
    C_MUTE_SOLO = 'C_MUTE_SOLO', --string
    B_LOOPSRC = 'B_LOOPSRC', --boolean
    B_ALLTAKESPLAY = 'B_ALLTAKESPLAY', --boolean
    B_UISEL = 'B_UISEL', --boolean
    C_BEATATTACHMODE = 'C_BEATATTACHMODE', --string
    C_AUTOSTRETCH = 'C_AUTOSTRETCH', --
    C_LOCK = 'C_LOCK', --string
    D_VOL = 'D_VOL', --number
    D_POSITION = 'D_POSITION', --number
    D_LENGTH = 'D_LENGTH', --number
    D_SNAPOFFSET = 'D_SNAPOFFSET', --number
    D_FADEINLEN = 'D_FADEINLEN', --number
    D_FADEOUTLEN = 'D_FADEOUTLEN', --number
    D_FADEINDIR = 'D_FADEINDIR', --number
    D_FADEOUTDIR = 'D_FADEOUTDIR', --number
    D_FADEINLEN_AUTO = 'D_FADEINLEN_AUTO', --number
    D_FADEOUTLEN_AUTO = 'D_FADEOUTLEN_AUTO', --number
    C_FADEINSHAPE = 'C_FADEINSHAPE', --number
    C_FADEOUTSHAPE = 'C_FADEOUTSHAPE', --number
    I_GROUPID = 'I_GROUPID', --number
    I_LASTY = 'I_LASTY', --number
    I_LASTH = 'I_LASTH', --number
    I_CUSTOMCOLOR = 'I_CUSTOMCOLOR', --number
    I_CURTAKE = 'I_CURTAKE', --number
    IP_ITEMNUMBER = 'IP_ITEMNUMBER', --number
    F_FREEMODE_Y = 'F_FREEMODE_Y', --number
    F_FREEMODE_H = 'F_FREEMODE_H', --number
}
--
--TrackFXNamedConfigParams = {
--    pdc = 'pdc',
--    input_pin_name = 'in_pin_0',
--    output_pin_name = 'out_pin_0'
--}

constants.MediaItemTakeInfoValue = {
    D_STARTOFFS =  'D_STARTOFFS', --: number : start offset in source media, in seconds
    D_VOL = 'D_VOL', --: number : take volume, 0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc, negative if take polarity is flipped
    D_PAN = 'D_PAN', --: number : take pan, -1..1
    D_PANLAW = 'D_PANLAW', --: number : take pan law, -1=default, 0.5=-6dB, 1.0=+0dB, etc
    D_PLAYRATE = 'D_PLAYRATE', --: number : take playback rate, 0.5=half speed, 1=normal, 2=double speed, etc
    D_PITCH = 'D_PITCH', --: number : take pitch adjustment in semitones, -12=one octave down, 0=normal, +12=one octave up, etc
    B_PPITCH = 'B_PPITCH', --: boolean : preserve pitch when changing playback rate
    I_CHANMODE = 'I_CHANMODE', --: number : channel mode, 0=normal, 1=reverse stereo, 2=downmix, 3=left, 4=right
    I_PITCHMODE = 'I_PITCHMODE', --[[
        : number : pitch shifter mode, -1=projext default,
        otherwise high 2 bytes=shifter, low 2 bytes=parameter--]]
    I_CUSTOMCOLOR = 'I_CUSTOMCOLOR', --[[
        : number : custom color,
        OS dependent color|0x100000 (i.e. ColorToNative(r,g,b)|0x100000).
        If you do not |0x100000, then it will not be used, but will store the color
    --]]
    IP_TAKENUMBER = 'IP_TAKENUMBER', --: number: take number (read-only, returns the take number directly)
    P_TRACK = 'P_TRACK', --: ponumberer to MediaTrack (read-only)
    P_ITEM = 'P_ITEM', --: ponumberer to MediaItem (read-only)
    P_SOURCE = 'P_SOURCE', --[[
        : PCM_source *. Note that if setting this,
        you should first retrieve the old source, set the new,
        THEN delete the old.
     --]]
}

constants.MediaItemInfoString = {
    P_NAME = 'P_NAME', --: string : media item take name
    P_EXT = 'P_EXT', --[[
        : string : extension-specific persistent data
        Append :ext name, e.g MediaItemInfoString.P_EXT..:my_ext
    --]]
    GUID = 'GUID', --[[
        : GUID * : 16-byte GUID, can query or update.
        If using a _String() function, GUID is a string {xyz-...}.
    --]]
}

constants.MediaItemTakeInfoString = constants.MediaItemInfoString

constants.TrackFXShowFlags = {
    hide_chain = 0,
    show_chain = 1,
    hide_window = 2,
    show_window = 3
}


constants.SendReceiveCategory = {
    receive = -1,
    send = 0,
    hw = 1
}

constants.EnvelopeType = {
    volume = 0,
    pan = 1,
    mute = 2
}

constants.SendReceiveInfoValue = {
    B_MUTE  = 'B_MUTE', --[]
    B_PHASE  = 'B_PHASE', --[' boolean ']
    B_MONO  = 'B_MONO', --[]
    D_VOL  = 'D_VOL', --[' number ']
    D_PAN  = 'D_PAN', --[' number ']
    D_PANLAW  = 'D_PANLAW', --[' number ']
    I_SENDMODE  = 'I_SENDMODE', --[' number ']
    I_AUTOMODE  = 'I_AUTOMODE', --[' number ']
    I_SRCCHAN  = 'I_SRCCHAN', --[' number ']
    I_DSTCHAN  = 'I_DSTCHAN', --[' number ', ' index, &1024=mono, otherwise stereo pair, hwout']
    I_MIDIFLAGS  = 'I_MIDIFLAGS', --[' number ']
    P_DESTTRACK  = 'P_DESTTRACK', --[' MediaTrack * ']
    P_SRCTRACK  = 'P_SRCTRACK', --[' MediaTrack * ']
    P_ENV = 'P_ENV', --['<envchunkname ', ' TrackEnvelope * ', ' call with ', '<VOLENV, ']
}

constants.AutomationItemInfo = {
    D_POOL_ID = 'D_POOL_ID', --automation item pool ID (as an integer); edits are propagated to all other automation items that share a pool ID
    D_POSITION = 'D_POSITION', --automation item timeline position in seconds
    D_LENGTH = 'D_LENGTH', --automation item length in seconds
    D_STARTOFFS = 'D_STARTOFFS', --automation item start offset in seconds
    D_PLAYRATE = 'D_PLAYRATE', --automation item playback rate
    D_BASELINE = 'D_BASELINE', --automation item baseline value in the range [0,1]
    D_AMPLITUDE = 'D_AMPLITUDE', --automation item amplitude in the range [-1,1]
    D_LOOPSRC = 'D_LOOPSRC', --nonzero if the automation item contents are looped
    D_UISEL = 'D_UISEL', --nonzero if the automation item is selected in the arrange view
    D_POOL_QNLEN = 'D_POOL_QNLEN', --automation item pooled source length in quarter notes (setting will affect all pooled instances)
}

constants.zero_db = 716.21785031261
constants.minus_inf = 0.0

constants.DockPosition = {
    notfound = -1,
    bottom = 0,
    left=1,
    top=2,
    right=3,
    floating=4
}

constants.MediaInsertModes = {
    add_to_current_track = 0,
    add_new_track = 1,
    add_to_selected_items_as_takes = 3,
    stretch_loop_to_fit_time_sel = 4,
    try_to_match_tempo_1x = 8,
    try_to_match_tempo_05x = 16,
    try_to_match_tempo_2x = 32,
    dont_preserve_pitch_when_matching_tempo = 64,
    no_loop_section_if_startpct_endpct_set = 128,
    force_loop_regardless_of_global_preference_for_looping_imported_items = 256,
    use_high_word_as_absolute_track_index_if_mode3 = 512,
    insert_into_reasamplomatic_on_a_new_track = 1024,
    insert_into_open_reasamplomatic_instance = 2048,
    move_to_source_preferred_position = 4096,
    reverse = 8192,
}

return constants