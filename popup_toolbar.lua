local common = require("awful.widget.common")
local wibox_bg = require("wibox.widget.background")

local popup_toolbar = {}

local mytasklist = {}
mytasklist.buttons = awful.util.table.join(awful.button({}, 1, function(c)
    if c == client.focus then
        c.minimized = true
    else
        -- Without this, the following
        -- :isvisible() makes no sense
        c.minimized = false
        if not c:isvisible() then
            awful.tag.viewonly(c:tags()[1])
        end
        -- This will also un-minimize
        -- the client, if needed
        client.focus = c
        c:raise()
    end
end),
    awful.button({}, 3, function()
        if instance then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({
                theme = { width = 250 }
            })
        end
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end))


local function list_update(w, buttons, label, data, objects)
    common.list_update(w, buttons, label, data, objects)
    w:set_max_widget_size(settings.popup_bar.tasklist.item_height)
end

function toggle_popup_box(s)
    popup_toolbar[s].visible = not popup_toolbar[s].visible
end

local function render_popup_box(s)
    popup_toolbar[s] = awful.wibox({
        position = settings.popup_bar.position,
        screen = s,
        ontop = true,
        width = settings.popup_bar.width,
    })

    popup_toolbar[s].visible = false

    mytasklist[s] = awful.widget.tasklist(s,
        awful.widget.tasklist.filter.currenttags,
        mytasklist.buttons,
        nil,
        list_update,
        wibox.layout.flex.vertical())


    local top_layout = wibox.layout.fixed.vertical()

    for i,widget in ipairs(settings.popup_bar.widgets) do
        top_layout:add(require(widget).widget)
    end

    local middle_layout = wibox.layout.flex.vertical()
    middle_layout:add(mytasklist[s])

    local layout = wibox.layout.align.vertical()
    layout:set_top(top_layout)
    layout:set_middle(middle_layout)

    local background = wibox.widget.background(layout)

    background:set_bgimage(beautiful.popup_toolbar_background)

    popup_toolbar[s]:set_widget(background)
end

for s = 1, screen.count() do
    render_popup_box(s)
end
