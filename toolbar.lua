local menu_widget = require("widgets.menu")


function toogle_main_menu()
    menu_widget.menu:toggle()
end

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
    tags[s] = awful.tag(settings.tags, s, awful.layout.suit.floating)
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
    left_layout:add(mypromptbox[s])


    right_layout:add(wibox.widget.systray())

    center_layout:add(mytaglist[s])

    local widgets = {}
    for i,widget in ipairs(settings.toolbar.widgets) do
        if widgets[widget] == nil then
            widgets[widget] = require(widget)
        end
        center_layout:add(widgets[widget].widget)
    end

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()

    layout:set_left(left_layout)
    layout:set_right(right_layout)
    layout:set_middle(center_layout)
    layout.expand = 'outside'

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


function toggle_toolbar_box(s)
    toolbar[s].visible = not toolbar[s].visible
end

-- Load popup toolbar
require("popup_toolbar")