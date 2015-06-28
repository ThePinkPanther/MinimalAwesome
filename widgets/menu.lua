
-- Load Debian menu entries
require("debian.menu")

custommenu = {
   { "disk management" , "gnome-disks" },
   { "disks space" , "baobab" },
   { "screen management" , "arandr" },
   { "themes" , "lxappearance" },
   { "sound" , "alsamixergui" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "tools", custommenu },
                                    { "Debian", debian.menu.Debian_menu.Debian }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

menubar.utils.terminal = terminal 
