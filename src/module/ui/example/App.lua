local App = require("module/ui/components/Component")
local Box = require("module/ui/components/Box")

return App({
    Box({
        position = {x = 10, y = 10}
    }),
    Box({
        position = {x = 30, y = 10}
    }),
    Box({
        position = {x = 10, y = 50}
    }),
})