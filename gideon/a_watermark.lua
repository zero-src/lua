-- Define elements
local h_state, si_get, si_set, c_get, c_set = ui_hotkey.get_state, ui_slider_int.get_value, ui_slider_int.set_value, ui_checkbox.get_value, ui_checkbox.set_value
local font = drawing.create_font("C:/windows/fonts/verdana.ttf", 12)

local active = ui.new_checkbox("Extensions", "Elements 1", "Watermark")

--------------------------------
local ctag = "gideonproject"   --Cheat name
local nickname = "zero"        --User name
--------------------------------

-- Local vars
local client_screen_size = client.get_screen_size
local renderer_measure_text = render.text_size
local client_system_time = client.system_time
local renderer_rectangle = render.rect_filled
local renderer_text = render.text

local function to_int(number)
    return math.floor(tonumber(number) or error("Could not cast '" .. tostring(number) .. "' to number.'"))
end

local function round(x)
    return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

local function paint_handler(ctx)
    if c_get(active) and client.is_ingame() then
        local sys_time = { client_system_time("%H"), client_system_time("%M"), client_system_time("%S") }
        local actual_time = string.format("%02d:%02d:%02d", sys_time[1], sys_time[2], sys_time[3])

        local latency = round(client.get_ping() * 1000) 
        local text = string.format("%s | %s | delay: %dms | %s", ctag, nickname, latency, actual_time)

        local r, g, b, a = 89, 119, 239, 80
        local w, h = renderer_measure_text(ctx, text, font) + 8, 18
        local x, y = client_screen_size()

        x = x - w - 5

        renderer_rectangle(ctx, x, 3, x+w, 5, r, g, b, 255)
        renderer_rectangle(ctx, x, 5, x+w, 19, 17, 17, 17, a)
        renderer_text(ctx, x+4, 5, 255, 255, 255, 255, text, font)
    end
end

add_callback('paint', paint_handler)


