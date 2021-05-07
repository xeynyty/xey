local r = require("robot")
local c = require("component")
local inv = c.inventory_controller
local magnet = c.tractor_beam

local function takeFromRobot()
    local name = "minecraft:flint_and_steel"

    local size = r.inventorySize()

    for slot = 1, size do
        local item = inv.getStackInInternalSlot(slot)

        if item and item.name == name then
            r.select(slot)
            inv.equip()
            return true
        end
    end
    return false
end

local function takeFromChest()
    local side = 1
    local name = "minecraft:flint_and_steel"

    local chest = inv.getInventorySize(side)
    if chest then
        for slot = 1, chest do
            local item = inv.getStackInSlot(side,slot)
            if item and item.name == name then
                inv.suckFromSlot(1,slot)

                takeFromRobot()

                return true
            end
        end
    end
    return false
end

local function checkFlint()
    fire, _ = r.durability()

    if fire == nil then
        local check
        local first = takeFromRobot()

            if first == true then
                check = true
            else
                if first == false then
                    check = takeFromChest()
                end
            end

            if check == true then
                print("I take a new flint!")
                return true
            else
                if check == false then
                    print("*** *** ***\nI can't take a new flint!\n*** *** ***")
                    return false
                end
            end
    else
        return true
    end
end

local function farm()
    while true do
        local _, check = r.detect()

        if r.durability() == nil then
            break
        else
            if check == "air" then
                r.use()
            end
        end

        r.turnLeft()
        magnet.suck()
    end
end

local function drop()
    local size = inv.getInventorySize(1)
    local mySize = r.inventorySize()

    for mySlot = 1, mySize do
        local myItem = inv.getStackInInternalSlot(mySlot)

        if myItem and myItem.name == "enderio:item_material" then
            for slot = 1, size do
                local item = inv.getStackInSlot(1,slot)

                if item == nil then
                    r.select(mySlot)
                    inv.dropIntoSlot(1,slot)
                else
                    if item.name == "enderio:item_material" and item.size < item.maxSize then
                        r.select(mySlot)
                        local count = item.maxSize - item.size
                        inv.dropIntoSlot(1,slot,count)
                    end
                end
            end
        end
    end
end

print("Ah Shit, Here We Go Again")
print(os.date())


while true do
    checkFlint()
    r.select(1)
    drop()

    farm()
end