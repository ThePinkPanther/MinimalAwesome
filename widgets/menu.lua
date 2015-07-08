local awful = require("awful")
local beautiful = require("beautiful")

local MenuWidget = {}

MenuWidget.widget = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = awful.menu({ items = require("settings").menu })
})

return MenuWidget
