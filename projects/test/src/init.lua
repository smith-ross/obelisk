package.path = package.path..";../../../src/?.lua"
local obelisk = require("Obelisk")
local service = obelisk.m("service")

require("services/TestService")

obelisk.init()
obelisk.withParallel(function()
    while true do
        os.sleep(0)
    end
end)