local wibox = require("wibox")

minimum_battery = 15 
battery_low_notification_command = "mplayer /usr/share/sounds/freedesktop/stereo/suspend-error.oga"

has_notified = false

function update_battery()
    local fh = assert(io.popen("acpi | cut -d, -f 2 - | grep -o -E \"[0-9]+\"", "r"))
    local battery_level = tonumber(fh:read("*l"))
    fh:close()
    
    fh = assert(io.popen("acpi | cut -d' ' -f 3", "r"))
    local battery_status = fh:read("*l")    
    fh:close()

    local color = beautiful.fg_focus 
    local is_discharging = false;
    if battery_status == "Discharging," then
      color = beautiful.fg_urgent 
      is_discharging = true
    end
    

    if is_discharging and not has_notified and battery_level <= minimum_battery then
         has_notified = true
         naughty.notify({ title      = "Battery Warning"
                                , text       = "Battery low! Level: " .. battery_level .. "%"
                                , timeout    = 5
                                , fg         = beautiful.fg_focus
                                , bg         = beautiful.bg_focus
                                })
    awful.util.spawn_with_shell(battery_low_notification_command)         

    elseif battery_level > minimum_battery then
         has_notified = false
    end

    batterywidget:set_markup("<span color='" .. beautiful.fg_normal .. "'>pow: </span><span color='" .. color .. "'>" .. battery_level .. "%</span>")
  end 


batterywidget = wibox.widget.textbox()    
batterywidgettimer = timer({ timeout = 5 })    
batterywidgettimer:connect_signal("timeout", update_battery)    
batterywidgettimer:start()


update_battery()
