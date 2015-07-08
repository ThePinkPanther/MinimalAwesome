local wibox = require("wibox")
local beautiful = require("beautiful")

local layout =  wibox.layout.fixed.horizontal()
local textbox = wibox.widget.textbox()

local myicon = wibox.widget.imagebox()
myicon:set_image(beautiful.titlebar_battery_icon)

layout:add(myicon)
layout:add(textbox)

local BatteryWidget = {
    widget = layout,
    timer = timer({ timeout = 5 }),
    hasNotified = false,
    minBattery = 15,
    batteryLowNotificationCommand = "mplayer ",
    batteryLowNotificationSound = configdir .. "/media/audio/suspend-error.oga"
}


-- Update widget
function BatteryWidget.update()
    local fh = assert(io.popen("acpi | cut -d, -f 2 - | grep -o -E \"[0-9]+\"", "r"))
    local battery_level = tonumber(fh:read("*l"))
    fh:close()

    assert(type(battery_level) == "number", "Failed to read battery level")

    fh = assert(io.popen("acpi | cut -d' ' -f 3", "r"))
    local battery_status = fh:read("*l")
    fh:close()

    local color = beautiful.fg_focus
    local is_discharging = false;
    if battery_status == "Discharging," then
        color = beautiful.fg_urgent
        is_discharging = true
    end


    if is_discharging and not BatteryWidget.hasNotified
            and battery_level <= BatteryWidget.minBattery then
        BatteryWidget.hasNotified = true
        naughty.notify({
            title = "Battery Warning",
            text = "Battery low! Level: " .. battery_level .. "%",
            timeout = 5,
            fg = beautiful.fg_focus,
            bg = beautiful.bg_focus
        })
        awful.util.spawn_with_shell(
            BatteryWidget.batteryLowNotificationCommand ..
                    BatteryWidget.batteryLowNotificationSound)

    elseif battery_level > BatteryWidget.minBattery then
        BatteryWidget.hasNotified = false
    end

    textbox:set_markup(" <span color='" .. color ..
            "'>" .. battery_level .. "%</span>")
end

BatteryWidget.timer:connect_signal("timeout", BatteryWidget.update)
BatteryWidget.timer:start()
BatteryWidget.update()

return BatteryWidget
