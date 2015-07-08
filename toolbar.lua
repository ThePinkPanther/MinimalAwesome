-- Require widgets
local volume_widget = require("widgets.volume")
local battery_widget = require("widgets.battery")
local keyboard_layout_widget = require("widgets.kblayout")
local separator_widget = require("widgets.separator")
local menu_widget = require("widgets.menu")


-- Global references
update_volume = volume_widget.update
switch_keyboard_layout = keyboard_layout_widget.switch

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5 }, s, awful.layout.suit.floating)
end

-- Create a wibox for each screen and add it
local toolbar = {}
mypromptbox = {}
local mytaglist = {}
mytaglist.buttons = awful.util.table.join(awful.button({}, 1, awful.tag.viewonly),
    awful.button({ modkey }, 1, awful.client.movetotag),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, awful.client.toggletag),
    awful.button({}, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end))


local function render_widget_box(s)

    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget

    -- Create the wibox
    toolbar[s] = awful.wibox({
        position = settings.toolbar.position,
        screen = s,
        ontop = settings.toolbar.ontop
    })

    -- Widgets that are aligned to the left
    local center_layout = wibox.layout.fixed.horizontal()
    local left_layout = wibox.layout.fixed.horizontal()
    local right_layout = wibox.layout.fixed.horizontal()
--    left_layout:add(menu_widget.widget)
    left_layout:add(separator_widget.widget)
    left_layout:add(mypromptbox[s])


    right_layout:add(wibox.widget.systray())

    center_layout:add(mytaglist[s])
    center_layout:add(separator_widget.widget)
    center_layout:add(keyboard_layout_widget.widget)
    center_layout:add(separator_widget.widget)
    center_layout:add(volume_widget.widget)
    center_layout:add(separator_widget.widget)
    center_layout:add(battery_widget.widget)
    center_layout:add(separator_widget.widget)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()

    layout:set_left(left_layout)
    layout:set_right(right_layout)
    layout:set_middle(center_layout)

    local margin = wibox.layout.margin()

    margin:set_top(2)
    margin:set_bottom(2)
    margin:set_left(10)
    margin:set_right(10)

    margin:set_widget(layout)

    toolbar[s]:set_widget(margin)
    toolbar[s]:set_bg(beautiful.bg_normal_transparent)
end

for s = 1, screen.count() do
    render_widget_box(s)
end

-- Load popup toolbar
require("popup_toolbar")
