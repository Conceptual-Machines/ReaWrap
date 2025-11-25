#pragma once

#include <string>

namespace ReaWrap {

namespace Constants {

// Track Info Value constants
namespace TrackInfoValue {
    constexpr const char* B_MUTE = "B_MUTE";
    constexpr const char* B_PHASE = "B_PHASE";
    constexpr const char* B_RECMON_IN_EFFECT = "B_RECMON_IN_EFFECT";
    constexpr const char* IP_TRACKNUMBER = "IP_TRACKNUMBER";
    constexpr const char* I_SOLO = "I_SOLO";
    constexpr const char* B_SOLO_DEFEAT = "B_SOLO_DEFEAT";
    constexpr const char* I_FXEN = "I_FXEN";
    constexpr const char* I_RECARM = "I_RECARM";
    constexpr const char* I_RECINPUT = "I_RECINPUT";
    constexpr const char* I_RECMODE = "I_RECMODE";
    constexpr const char* I_RECMON = "I_RECMON";
    constexpr const char* I_RECMONITEMS = "I_RECMONITEMS";
    constexpr const char* B_AUTO_RECARM = "B_AUTO_RECARM";
    constexpr const char* I_AUTOMODE = "I_AUTOMODE";
    constexpr const char* I_NCHAN = "I_NCHAN";
    constexpr const char* I_SELECTED = "I_SELECTED";
    constexpr const char* I_WNDH = "I_WNDH";
    constexpr const char* I_TCPH = "I_TCPH";
    constexpr const char* I_TCPY = "I_TCPY";
    constexpr const char* I_MCPX = "I_MCPX";
    constexpr const char* I_MCPY = "I_MCPY";
    constexpr const char* I_MCPW = "I_MCPW";
    constexpr const char* I_MCPH = "I_MCPH";
    constexpr const char* I_FOLDERDEPTH = "I_FOLDERDEPTH";
    constexpr const char* I_FOLDERCOMPACT = "I_FOLDERCOMPACT";
    constexpr const char* I_MIDIHWOUT = "I_MIDIHWOUT";
    constexpr const char* I_PERFFLAGS = "I_PERFFLAGS";
    constexpr const char* I_CUSTOMCOLOR = "I_CUSTOMCOLOR";
    constexpr const char* I_HEIGHTOVERRIDE = "I_HEIGHTOVERRIDE";
    constexpr const char* B_HEIGHTLOCK = "B_HEIGHTLOCK";
    constexpr const char* D_VOL = "D_VOL";
    constexpr const char* D_PAN = "D_PAN";
    constexpr const char* D_WIDTH = "D_WIDTH";
    constexpr const char* D_DUALPANL = "D_DUALPANL";
    constexpr const char* D_DUALPANR = "D_DUALPANR";
    constexpr const char* I_PANMODE = "I_PANMODE";
    constexpr const char* D_PANLAW = "D_PANLAW";
    constexpr const char* P_ENV = "P_ENV";
    constexpr const char* B_SHOWINMIXER = "B_SHOWINMIXER";
    constexpr const char* B_SHOWINTCP = "B_SHOWINTCP";
    constexpr const char* B_MAINSEND = "B_MAINSEND";
    constexpr const char* C_MAINSEND_OFFS = "C_MAINSEND_OFFS";
    constexpr const char* B_FREEMODE = "B_FREEMODE";
    constexpr const char* C_BEATATTACHMODE = "C_BEATATTACHMODE";
    constexpr const char* F_MCP_FXSEND_SCALE = "F_MCP_FXSEND_SCALE";
    constexpr const char* F_MCP_FXPARM_SCALE = "F_MCP_FXPARM_SCALE";
    constexpr const char* F_MCP_SENDRGN_SCALE = "F_MCP_SENDRGN_SCALE";
    constexpr const char* F_TCP_FXPARM_SCALE = "F_TCP_FXPARM_SCALE";
    constexpr const char* I_PLAY_OFFSET_FLAG = "I_PLAY_OFFSET_FLAG";
    constexpr const char* D_PLAY_OFFSET = "D_PLAY_OFFSET";
    constexpr const char* P_PARTRACK = "P_PARTRACK";
    constexpr const char* P_PROJECT = "P_PROJECT";
}

// Track Info String constants
namespace TrackInfoString {
    constexpr const char* P_NAME = "P_NAME";
    constexpr const char* P_ICON = "P_ICON";
    constexpr const char* P_MCP_LAYOUT = "P_MCP_LAYOUT";
    constexpr const char* P_RAZOREDITS = "P_RAZOREDITS";
    constexpr const char* P_TCP_LAYOUT = "P_TCP_LAYOUT";
    constexpr const char* P_EXT = "P_EXT";
    constexpr const char* GUID = "GUID";
}

// Media Item Info Value constants
namespace MediaItemInfoValue {
    constexpr const char* B_MUTE = "B_MUTE";
    constexpr const char* B_MUTE_ACTUAL = "B_MUTE_ACTUAL";
    constexpr const char* C_MUTE_SOLO = "C_MUTE_SOLO";
    constexpr const char* B_LOOPSRC = "B_LOOPSRC";
    constexpr const char* B_ALLTAKESPLAY = "B_ALLTAKESPLAY";
    constexpr const char* B_UISEL = "B_UISEL";
    constexpr const char* C_BEATATTACHMODE = "C_BEATATTACHMODE";
    constexpr const char* C_AUTOSTRETCH = "C_AUTOSTRETCH";
    constexpr const char* C_LOCK = "C_LOCK";
    constexpr const char* D_VOL = "D_VOL";
    constexpr const char* D_POSITION = "D_POSITION";
    constexpr const char* D_LENGTH = "D_LENGTH";
    constexpr const char* D_SNAPOFFSET = "D_SNAPOFFSET";
    constexpr const char* D_FADEINLEN = "D_FADEINLEN";
    constexpr const char* D_FADEOUTLEN = "D_FADEOUTLEN";
    constexpr const char* D_FADEINDIR = "D_FADEINDIR";
    constexpr const char* D_FADEOUTDIR = "D_FADEOUTDIR";
    constexpr const char* D_FADEINLEN_AUTO = "D_FADEINLEN_AUTO";
    constexpr const char* D_FADEOUTLEN_AUTO = "D_FADEOUTLEN_AUTO";
    constexpr const char* C_FADEINSHAPE = "C_FADEINSHAPE";
    constexpr const char* C_FADEOUTSHAPE = "C_FADEOUTSHAPE";
    constexpr const char* I_GROUPID = "I_GROUPID";
    constexpr const char* I_LASTY = "I_LASTY";
    constexpr const char* I_LASTH = "I_LASTH";
    constexpr const char* I_CUSTOMCOLOR = "I_CUSTOMCOLOR";
    constexpr const char* I_CURTAKE = "I_CURTAKE";
    constexpr const char* IP_ITEMNUMBER = "IP_ITEMNUMBER";
    constexpr const char* F_FREEMODE_Y = "F_FREEMODE_Y";
    constexpr const char* F_FREEMODE_H = "F_FREEMODE_H";
}

// Media Item Info String constants
namespace MediaItemInfoString {
    constexpr const char* P_NAME = "P_NAME";
    constexpr const char* P_EXT = "P_EXT";
    constexpr const char* GUID = "GUID";
}

// Media Item Take Info Value constants
namespace MediaItemTakeInfoValue {
    constexpr const char* D_STARTOFFS = "D_STARTOFFS";
    constexpr const char* D_VOL = "D_VOL";
    constexpr const char* D_PAN = "D_PAN";
    constexpr const char* D_PANLAW = "D_PANLAW";
    constexpr const char* D_PLAYRATE = "D_PLAYRATE";
    constexpr const char* D_PITCH = "D_PITCH";
    constexpr const char* B_PPITCH = "B_PPITCH";
    constexpr const char* I_CHANMODE = "I_CHANMODE";
    constexpr const char* I_PITCHMODE = "I_PITCHMODE";
    constexpr const char* I_CUSTOMCOLOR = "I_CUSTOMCOLOR";
    constexpr const char* IP_TAKENUMBER = "IP_TAKENUMBER";
    constexpr const char* P_TRACK = "P_TRACK";
    constexpr const char* P_ITEM = "P_ITEM";
    constexpr const char* P_SOURCE = "P_SOURCE";
}

// Media Item Take Info String constants (same as MediaItemInfoString)
using MediaItemTakeInfoString = MediaItemInfoString;

// Track FX Named Config Params
namespace TrackFXNamedConfigParams {
    constexpr const char* pdc = "pdc";
    constexpr const char* input_pin_name = "in_pin_0";
    constexpr const char* output_pin_name = "out_pin_0";
}

// Track FX Show Flags
enum class TrackFXShowFlags {
    hide_chain = 0,
    show_chain = 1,
    hide_window = 2,
    show_window = 3,
};

// Send/Receive Category
enum class SendReceiveCategory {
    receive = -1,
    send = 0,
    hw = 1,
};

// Envelope Type
enum class EnvelopeType {
    volume = 0,
    pan = 1,
    mute = 2,
};

// Send/Receive Info Value constants
namespace SendReceiveInfoValue {
    constexpr const char* B_MUTE = "B_MUTE";
    constexpr const char* B_PHASE = "B_PHASE";
    constexpr const char* B_MONO = "B_MONO";
    constexpr const char* D_VOL = "D_VOL";
    constexpr const char* D_PAN = "D_PAN";
    constexpr const char* D_PANLAW = "D_PANLAW";
    constexpr const char* I_SENDMODE = "I_SENDMODE";
    constexpr const char* I_AUTOMODE = "I_AUTOMODE";
    constexpr const char* I_SRCCHAN = "I_SRCCHAN";
    constexpr const char* I_DSTCHAN = "I_DSTCHAN";
    constexpr const char* I_MIDIFLAGS = "I_MIDIFLAGS";
    constexpr const char* P_DESTTRACK = "P_DESTTRACK";
    constexpr const char* P_SRCTRACK = "P_SRCTRACK";
    constexpr const char* P_ENV = "P_ENV";
}

// Automation Item Info constants
namespace AutomationItemInfo {
    constexpr const char* D_POOL_ID = "D_POOL_ID";
    constexpr const char* D_POSITION = "D_POSITION";
    constexpr const char* D_LENGTH = "D_LENGTH";
    constexpr const char* D_STARTOFFS = "D_STARTOFFS";
    constexpr const char* D_PLAYRATE = "D_PLAYRATE";
    constexpr const char* D_BASELINE = "D_BASELINE";
    constexpr const char* D_AMPLITUDE = "D_AMPLITUDE";
    constexpr const char* D_LOOPSRC = "D_LOOPSRC";
    constexpr const char* D_UISEL = "D_UISEL";
    constexpr const char* D_POOL_QNLEN = "D_POOL_QNLEN";
}

// Audio constants
namespace Audio {
    constexpr double zero_db = 716.21785031261;
    constexpr double minus_inf = 0.0;
}

// Dock Position
enum class DockPosition {
    notfound = -1,
    bottom = 0,
    left = 1,
    top = 2,
    right = 3,
    floating = 4,
};

// Media Insert Modes
enum class MediaInsertModes {
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
};

// Apply FX Flags
enum class ApplyFxFlags {
    stereo = 0,
    mono = 1,
    multi_output = 2,
    midi = 3,
};

// Message Box Types
enum class MsgBoxTypes {
    OK = 0,
    OKCANCEL = 1,
    ABORTRETRYIGNORE = 2,
    YESNOCANCEL = 3,
    YESNO = 4,
    RETRYCANCEL = 5,
};

// Message Box Return Types
enum class MsgBoxReturnTypes {
    OK = 1,
    CANCEL = 2,
    ABORT = 3,
    RETRY = 4,
    IGNORE = 5,
    YES = 6,
    NO = 7,
};

} // namespace Constants

} // namespace ReaWrap

