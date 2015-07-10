local wibox = require("wibox")
local beautiful = require("beautiful")

local CalendarWidget = {}

local textbox = wibox.widget.textbox()
textbox:set_align("left")
CalendarWidget.font = "DejaVu Sans Mono 11"

local margin = wibox.layout.margin()

margin:set_top(0)
margin:set_bottom(0)
margin:set_left(10)
margin:set_right(-10)

margin:set_widget(textbox)

CalendarWidget.widget = margin
textbox:set_font(CalendarWidget.font)

function CalendarWidget.update()
    local fd = io.popen("cal | sed -re 's/\\x5f\\x08([0-9]*)/P1^\\1P2^/g' ")
    local status = fd:read("*all"):gsub("%P1^", "<span background='" .. beautiful.bg_focus .. "'>"):gsub("%P2^", "</span>")
    fd:close()

    textbox:set_markup("<span color='" ..
            beautiful.fg_focus .. "'>"
            .. status .. "</span>")
end

CalendarWidget.update()

CalendarWidget.timer = timer({ timeout = 60 })
CalendarWidget.timer:connect_signal("timeout", CalendarWidget.update)
CalendarWidget.timer:start()

return CalendarWidget