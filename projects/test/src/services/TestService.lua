package.path = package.path..";../../../../../src/?.lua"

local obelisk = require("Obelisk")
local TestComponent = require("module/ui/example/TestComponent")
local service = obelisk.m("service")
local ui = obelisk.m("ui")

service.registerService("UIService", {
    onStart = function()
        print("Started Test Service")
    end,
    onUpdate = function()
        term.clear()
        term.setBackgroundColor(colors.black)
        term.setCursorPos(0,0)
        ui.App({
            TestComponent:withProps({
                id = "Test1",
                position = {x = 2, y = 2},
                size = {x = 2, y = 2},
            })(),
            TestComponent:withProps({
                id = "Test2",
                position = {x = 10, y = 10},
                size = {x = 2, y = 2},
                color = colors.red,
            })(),
            TestComponent:withProps({
                id = "Test3",
                position = {x = 5, y = 5},
                size = {x = 2, y = 2},
            })(),
        })
    end
})