local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")

local CalendarWidget = {}
CalendarWidget.month = tonumber(io.popen("date +'%m'"):read("*all"))
CalendarWidget.year = tonumber(io.popen("date +'%Y'"):read("*all"))

local calendar_textbox = wibox.widget.textbox()
calendar_textbox:set_align("left")
CalendarWidget.font = "DejaVu Sans Mono 11"


local button_left = wibox.widget.textbox()
button_left:set_align("right")
button_left:set_markup("<span color='" .. beautiful.fg_focus ..  "'> ◄ </span>")

local button_right = wibox.widget.textbox()
button_right:set_align("left")
button_right:set_markup("<span color='" .. beautiful.fg_focus ..  "'> ► </span>")

local separator = wibox.widget.textbox()
separator:set_text("        ")

local button_container = wibox.layout.flex.horizontal()

button_container:add(button_left)
button_container:add(separator)
button_container:add(button_right)


local container = wibox.layout.fixed.vertical()
container:add(button_container)
container:add(calendar_textbox)


local margin = wibox.layout.margin()

margin:set_top(0)
margin:set_bottom(10)
margin:set_left(10)
margin:set_right(-10)

margin:set_widget(container)

CalendarWidget.widget = margin
calendar_textbox:set_font(CalendarWidget.font)

function CalendarWidget.offset(offset)
    assert(type(offset) == "number", "function CalendarWidget.offset expects a number, got "
            .. type(offset))

    local sum = offset+CalendarWidget.month+CalendarWidget.year*12

    CalendarWidget.month = sum%12
    CalendarWidget.year = math.floor(sum/12)
end

function CalendarWidget.update()
    local fd = io.popen("cal -d " .. CalendarWidget.year .. "-"
            .. CalendarWidget.month ..
        " | sed -re 's/\\x5f\\x08([0-9]*)/P1^\\1P2^/g' | sed -re 's/\\n\\n//'")
    local status = fd:read("*all")
        :gsub("%P1^", "<span background='" .. beautiful.bg_focus .. "'>")
        :gsub("%P2^", "</span>")
    fd:close()

    calendar_textbox:set_markup("<span color='" ..
            beautiful.fg_focus .. "'>"
            .. status .. "</span>")
end

function CalendarWidget.previousMonth()
    CalendarWidget.offset(-1)
    CalendarWidget.update()
end

function CalendarWidget.nextMonth()
    CalendarWidget.offset(1)
    CalendarWidget.update()
end

button_left:buttons(awful.util.table.join(awful.button({}, 1, function()
    CalendarWidget.previousMonth()
end)))


button_right:buttons(awful.util.table.join(awful.button({}, 1, function()
    CalendarWidget.nextMonth()
end)))

CalendarWidget.update()

CalendarWidget.timer = timer({ timeout = 60 })
CalendarWidget.timer:connect_signal("timeout", CalendarWidget.update)
CalendarWidget.timer:start()

return CalendarWidget