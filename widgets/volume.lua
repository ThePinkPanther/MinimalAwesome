local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

local VolumeWidget = {}

local layout =  wibox.layout.fixed.horizontal()
local textbox = wibox.widget.textbox()

local myicon = wibox.widget.imagebox()
myicon:set_image(beautiful.titlebar_audio_icon)
myicon:fit(2,10)

layout:add(myicon)
layout:add(textbox)

VolumeWidget.widget = layout


function VolumeWidget.update()
    local fd = io.popen("amixer -D pulse sget Master | egrep -o \"[0-9]+%\" | head -1")
    local status = fd:read("*all")
    fd:close()

    textbox:set_markup(
        " <span color='" .. beautiful.fg_focus ..
            "' >" .. status ..
            "</span>")
end

function VolumeWidget.onclick()
    awful.util.spawn("alsamixergui")
end

VolumeWidget.widget:buttons(awful.util.table.join(awful.button({}, 1, function()
    VolumeWidget.onclick()
end)))

VolumeWidget.update()

VolumeWidget.timer = timer({ timeout = 5 })
VolumeWidget.timer:connect_signal("timeout", VolumeWidget.update)
VolumeWidget.timer:start()

return VolumeWidget