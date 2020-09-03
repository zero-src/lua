client.exec("clear")
--------------------------------------------------------------------------------
-- HTTP functions
--------------------------------------------------------------------------------
local LINK = "https://pastebin.com/raw/Sq7FNxhz"
local http = require "gamesense/http"
local ffi = require("ffi")

-- Creating a database files
local user_base = database.read('user_base') or {}
local db = database.read('bytemode') or {}

local DATABASE = false
-- Colors for console
local log_color = { r = 240, g = 240, b = 240 }
local log_start = { r = 3, g = 252, b = 194 }   
local colored_text = { r = 180, g = 180, b = 255 } 
local starter_log_color = { r = 255, g = 222, b = 5 }

--------------------------------------------------------------------------------
-- Console logs
-------------------------------------------------------------------------------- 
local client_log = function(text)
    client.color_log(starter_log_color.r, starter_log_color.g, starter_log_color.b, "[bytemode]\0")
	client.color_log(183, 183, 183, " ", text)
end

local login_log = function(text)
    client.color_log(log_start.r, log_start.g, log_start.b, "-\0")

    client.color_log(log_color.r, log_color.g, log_color.b, " Logged in as\0")
    client.color_log(colored_text.r, colored_text.g, colored_text.b, " " .. text, "\0")
    client.color_log(log_color.r, log_color.g, log_color.b, " ")
end

local loaded_script = function(text)
    client.color_log(log_color.r, log_color.g, log_color.b, "- Loaded\0")
    client.color_log(colored_text.r, colored_text.g, colored_text.b, " " .. text, "\0")
    client.color_log(log_color.r, log_color.g, log_color.b, " from server\0")
end

local log = function(text)
	client.log(text .. "\0")
end
--------------------------------------------------------------------------------
-- HEX
--------------------------------------------------------------------------------
local function from_hex(hex)
    return (hex:gsub('..', function(cc)
        return string.char(tonumber(cc, 16))
    end))
end

local function tohex(str) 
    return (str:gsub('.', function (c) 
        return string.format('%02X', string.byte(c)) 
    end)) 
end

--------------------------------------------------------------------------------
-- User information
--------------------------------------------------------------------------------
http.get("https://ipv4.icanhazip.com/", function(success, response)
    local current_ip = response.body
        local current_key = tohex(current_ip)
        
    http.get(LINK, function(success, response)
        if not success or response.status ~= 200 then
            return
        end

        user_base.active = false
        local web_info = json.parse(response.body)
        --print(web_info)
        for i, user in pairs(web_info.data) do
            if current_key == user.key and current_key ~= nil then
                user_base.active = true
                user_base.username = user.username
                user_base.status = user.status
                
                database.write("user_base", user_base)   
            end
            --print(user.key) 
            if user_base.key ~= nil then
                if user_base.key == user.key then user_base.active = true return else user_base.active = false
                end
            end
        end

        if user_base.active == nil or current_key == nil or user_base.active == false then
            user_base.username = "unknown"
            user_base.status = "unknown"
            client_log('Copy your key: ' .. current_key)
        else     
            client_log("Welcome, " .. user_base.username)  
        end
        
    end)
    
end)

--------------------------------------------------------------------------------
-- Different script versions
--------------------------------------------------------------------------------
local get_lua_scripts = {
    ["admin"] = 'https://pastebin.com/raw/L41Kbptb', 
    ["beta"] = 'https://pastebin.com/raw/L41Kbptb', 
    ["premium"] = '', 
    ["NaN"] = '',
}

--------------------------------------------------------------------------------
-- Console functions
--------------------------------------------------------------------------------
ffi.cdef[[
    typedef bool(__thiscall* console_is_visible)(void*);
]]

local engine_client = ffi.cast(ffi.typeof("void***"), client.create_interface("engine.dll", "VEngineClient014"))
local console_is_visible = ffi.cast("console_is_visible", engine_client[0][11])
local materials = { "vgui_white", "vgui/hud/800corner1", "vgui/hud/800corner2", "vgui/hud/800corner3", "vgui/hud/800corner4" }

client.set_event_callback("paint", function()
    if (console_is_visible(engine_client)) then
        local r, g, b, a = 110, 110, 110, 228
        for i=1, #materials do 
            local mat = materials[i]
            materialsystem.find_material(mat):alpha_modulate(a)
            materialsystem.find_material(mat):color_modulate(r, g, b)
        end
    else
        for i=1, #materials do 
            local mat = materials[i]
            materialsystem.find_material(mat):alpha_modulate(255)
            materialsystem.find_material(mat):color_modulate(255, 255, 255)
        end
    end
end)
--------------------------------------------------------------------------------
-- Loader
--------------------------------------------------------------------------------
local loader = function()

    local init = function(list)
        local l_luas_list = list.title
        local loaded_luas = { }
    
        local load_luas = function()
            if l_luas_list == nil then return end
            for i, link in pairs(list.links) do
                http.get(link, function(success, response)
                    loadstring(response.body)()
                    loaded_luas[i] = true
                    loaded_script(list.title[i])
                    client.color_log(240, 240, 240, ' ')
                end)
            end
        end
        load_luas() 
    end

    -- Load script from server
    http.get(get_lua_scripts[user_base.status], function(success, response)
        local scripts = json.parse(response.body)

        local list = { title = {}, links = {} }
        for i, script in pairs(scripts.luas) do
            list.title[i] = script.name
            list.links[i] = script.link
        end
        init(list)
    end)
end


if user_base.active then loader() end