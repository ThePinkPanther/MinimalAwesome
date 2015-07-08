local wibox = require("wibox")
local beautiful = require("beautiful")

local WidgetSeparator = {}
WidgetSeparator.text = "      "

WidgetSeparator.widget = wibox.widget.textbox()
WidgetSeparator.widget:set_markup(
    "<span color='" .. beautiful.fg_normal .. "'>" .. WidgetSeparator.text .. "</span>")

return WidgetSeparator


