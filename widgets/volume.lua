local wibox = require("wibox")
local awful = require("awful")

volume_widget = wibox.widget.textbox()
volume_widget:set_align("right")

function update_volume(widget)
   local fd = io.popen("amixer -D pulse sget Master | egrep -o \"[0-9]+%\" | head -1")
   local status = fd:read("*all")
   fd:close()

   widget:set_markup(" vol: <span color='#FFFFFF' >" .. status .. "</span>")
end

volume_widget:buttons(awful.util.table.join(
   awful.button({ }, 1, function () awful.util.spawn("alsamixergui") end)
 ))

update_volume(volume_widget)

mytimer = timer({ timeout = 1 })
mytimer:connect_signal("timeout", function () update_volume(volume_widget) end)
mytimer:start()
