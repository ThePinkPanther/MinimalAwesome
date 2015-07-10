-- Global linraries
gears = require("gears")
awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
wibox = require("wibox")
-- Theme handling library
beautiful = require("beautiful")
-- Notification library
naughty = require("naughty")
-- Menubar
menubar = require("menubar")
require("debian.menu")

-- Load error handler
require("error_handler")

configdir = awful.util.getdir("config")

-- Themes define colours, icons, font and wallpapers.
beautiful.init(configdir .. "/theme/theme.lua")

-- Global settings
settings = require("settings")
modkey = settings.modkey
terminal = settings.terminal

menubar.utils.terminal = terminal

require("toolbar")

require("mousebindings")

require("keybindings")

require("rules")

require("signals")

require("error_handler")
