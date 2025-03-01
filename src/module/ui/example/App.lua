local Component = require("module/ui/components/Component")
local TestComponent = require("module/ui/example/TestComponent")

return function(id) 
    return Component:new()(id or "app", {
        TestComponent:withProps("Test1", {
            id = "Test1",
            position = {x = 2, y = 2},
            size = {x = 2, y = 2},
        })(),
        TestComponent:withProps("Test2", {
            id = "Test2",
            position = {x = 10, y = 10},
            size = {x = 2, y = 2},
            color = colors.red,
        })(),
        TestComponent:withProps("Test3", {
            id = "Test3",
            position = {x = 5, y = 5},
            size = {x = 2, y = 2},
        })(),
    })
end