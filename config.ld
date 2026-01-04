-- LDoc configuration file
project = 'ReaWrap'
title = 'ReaWrap API Documentation'
description = "Object-Oriented Wrapper for ReaScript Lua API"
version = '0.7.2'
author = 'Nomad Monad'

-- Source files
file = 'lua'
dir = 'doc'

-- Output format
format = 'markdown'
backtick_references = true
no_lua_ref = true

-- Sorting
sort = true
sort_modules = true

-- Custom CSS (optional - uses default if not present)
-- style = 'tools/doc_css/ldoc.css'

-- Package path for requires
package = ''

-- Exclude patterns
exclude = {
    'lua/constants.lua',  -- Large auto-generated constants file
}

-- Custom sections
new_type('container', 'Container Methods', false, 'function')
