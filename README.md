awesome-leaved
==============

Layout for AwesomeWM based on i3 and arranging clients into containers

Features
--------

Similar to i3, clients can be ordered within containers and vertically or horizontally arranged. They can also be "stacked" or "tabbed", and the focused window (client or container) and a list of windows in the container will be shown above, as a stack or tabs.

Instructions
------------

Put the awesome-leaved directory in the same location as rc.lua and include the library in rc.lua:

    local leaved = require "awesome-leaved"
    
There are currently two different types of layout, one that tiles and one that acts like the spiral layout from awful, splitting containers along the shortest axis 

Add some of the following to the `layouts` table in rc.lua

    leaved.layout.suit.tile.left
    leaved.layout.suit.spiral

Additionally, add the following to your beautiful theme:

    beautiful.layout_leaved = os.getenv("HOME") .. "/.config/awesome/awesome-leaved/leaved.png"

using the correct path to the image file.

Keybindings
-----------

There are a few important keybindings for leaved.

To switch the orientation of the current container use `shiftOrder`:

    awful.key({ modkey }, "s", leaved.keys.shiftOrder),

To force the current container to split in a certain direction, bind any or all of the following functions:

    awful.key({ modkey, "Shift" }, "h", leaved.keys.splitH), --split next horizontal
    awful.key({ modkey, "Shift" }, "v", leaved.keys.splitV), --split next vertical
    awful.key({ modkey, "Shift" }, "o", leaved.keys.splitOpp), --split in opposing direction

To switch between no tabs, tabs and stack use `shiftStyle`:

    awful.key({ modkey, "Shift" }, "t", leaved.keys.shiftStyle),

To scale windows there are two options, use vertical and horizontal scaling and include the percentage points to scale as an argument:

    awful.key({ modkey, "Shift" }, "]", leaved.keys.scaleV(-5)),
    awful.key({ modkey, "Shift" }, "[", leaved.keys.scaleV(5)),
    awful.key({ modkey }, "]", leaved.keys.scaleH(-5)),
    awful.key({ modkey }, "[", leaved.keys.scaleH(5))

Or scale based on the focused client and its opposite direction:

    awful.key({ modkey, "Shift" }, "]", leaved.keys.scaleOpposite(-5)),
    awful.key({ modkey, "Shift" }, "[", leaved.keys.scaleOpposite(5)),
    awful.key({ modkey }, "]", leaved.keys.scaleFocused(-5)),
    awful.key({ modkey }, "[", leaved.keys.scaleFocused(5))

`focusedScale` will always make the current client bigger or smaller in its container and `oppositeScale` will always scale in the opposing direction.

To swap two clients in the tree, use `swap`:

    awful.key({ modkey }, "'", leaved.keys.swap)

To select a client with the keyboard, use `focus`:

    awful.key({ modkey }, ";", leaved.keys.focus)

or (to allow focusing containers as well)

    awful.key({ modkey }, ";", leaved.keys.focus(true))

To minimize the container of the current client, use `minContainer`:

    awful.key({ modkey, "Shift" }, "n", leaved.keys.minContainer)

TODO
----

This project is incomplete, there are a couple (a lot of) things missing and just as many bugs

* Best way to hide non selected tab?
* Allowing changing how nodes are labelled when using swap/focus
* Add more using containers support
* Add mouse scaling support
* And more

Bugs
----

* Properly clean up on layout switch
* Couple bugs with client size minimums, figure out better resizing rules
* A couple display bugs after redrawing
