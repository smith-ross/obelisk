local App = require("components/Component")
local Box = require("components/Box")

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