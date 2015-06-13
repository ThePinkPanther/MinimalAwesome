local wibox = require("wibox")

language_widget = wibox.widget.textbox()
language_widget:set_align("right")

function update_language(widget)
   local fd = io.popen("setxkbmap -print | awk -F\"+\" '/xkb_symbols/ {print $2}'")
   local status = fd:read("*all")
   fd:close()

   widget:set_markup("<span color='#FFFFFF' >" .. status .. "</span>")
end

update_language(volume_widget)

mytimer = timer({ timeout = 1 })
mytimer:connect_signal("timeout", function () update_language(language_widget) end)
mytimer:start()
