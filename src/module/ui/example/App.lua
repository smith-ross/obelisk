local App = require("module/ui/components/Component")
local TestComponent = require("module/ui/example/TestComponent")

return App:new():extend(nil, nil, {
    TestComponent({
        id = "Test1",
        position = {x = 2, y = 2},
        size = {x = 2, y = 2},
    }),
    TestComponent({
        id = "Test2",
        position = {x = 10, y = 10},
        size = {x = 2, y = 2},
    }),
    TestComponent({
        id = "Test3",
        position = {x = 5, y = 5},
        size = {x = 2, y = 2},
    }),
})