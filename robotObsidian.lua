local r = require("robot")
local c = require("component")

print("*** Start ***")

while true do

    _, type = r.detect()

    if type == "solid" then
        r.swing()
    else
        check, _ = r.fill()

        if check == nil then
            drum, count = r.drainDown(16000)

            if drum == false or count < 1000 then
                break
            end
        end
    end
end

print("*** Stop ***")
