local App = require("module/ui/components/Component")
local TestComponent = require("module/ui/example/TestComponent")

return App:new({
    TestComponent({
        id = "Test1",
        position = {x = 10, y = 10}
    }),
    TestComponent({
        id = "Test2",
        position = {x = 30, y = 10}
    }),
    TestComponent({
        id = "Test3",
        position = {x = 10, y = 50}
    }),
})