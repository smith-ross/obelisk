package.path = package.path..";../../../../../src/?.lua"

local obelisk = require("Obelisk")
local service = obelisk.m("service")
local ui = obelisk.m("ui")

service.registerService("UIService", {
    onStart = function()
        print("Started Test Service")
    end,
    onUpdate = function()
        ui.App:draw()
    end
})