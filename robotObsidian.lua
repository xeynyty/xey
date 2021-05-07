local r = require("robot")
local c = require("component")
local inv = c.inventory_controller

while true do

    _, type = r.detect()

    if type == "solid" then
        r.swing()
    else
        r.turnAround()
        inv.equip()
        r.use()
        r.turnAround()
        r.use()
        inv.equip()
    end

end