local wibox = require("wibox")

batterywidget = wibox.widget.textbox()    
batterywidgettimer = timer({ timeout = 5 })    
batterywidgettimer:connect_signal("timeout",    
  function()    
    fh = assert(io.popen("acpi | cut -d, -f 2,2 -", "r"))    
    batterywidget:set_markup("pow: <span color='#FFFFFF'>" .. fh:read("*l") .. "</span>")    
    fh:close()    
  end    
)    
batterywidgettimer:start()
