-- Keyboard map indicator and changer
local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")

local KeyboardLayoutWidget = {}
KeyboardLayoutWidget.cmd = "setxkbmap"
KeyboardLayoutWidget.layout = settings.keyboard_layouts

KeyboardLayoutWidget.current = 1 -- us is our default layout
KeyboardLayoutWidget.widget = wibox.widget.textbox()
--KeyboardLayoutWidget.widget:set_text(" " .. KeyboardLayoutWidget.layout[KeyboardLayoutWidget.current][3] .. " ")
KeyboardLayoutWidget.switch = function(lang)
    local t = lang
    if lang == nil then
        KeyboardLayoutWidget.current = KeyboardLayoutWidget.current % #(KeyboardLayoutWidget.layout) + 1
        t = KeyboardLayoutWidget.layout[KeyboardLayoutWidget.current]
    end
    KeyboardLayoutWidget.widget:set_markup("<span color='" .. beautiful.fg_focus .. "'> " .. t[3] .. " </span>")
    os.execute(KeyboardLayoutWidget.cmd .. " " .. t[1] .. " " .. t[2])
end

KeyboardLayoutWidget.switch(KeyboardLayoutWidget.layout[KeyboardLayoutWidget.current])

-- Mouse bindings
KeyboardLayoutWidget.widget:buttons(awful.util.table.join(awful.button({}, 1, function() KeyboardLayoutWidget.switch() end)))

switch_keyboard_layout = KeyboardLayoutWidget.switch

return KeyboardLayoutWidget