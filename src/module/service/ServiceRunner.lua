local ServiceRunner = {}
ServiceRunner.__registeredServices = {}
ServiceRunner.__updateCoroutine = nil

local DELTA = 1/60

function ServiceRunner.start()
    for _, service in pairs(ServiceRunner.__registeredServices) do
        if service.onStart then
            service.onStart()
        end
    end
end

function ServiceRunner.startUpdate()
    ServiceRunner.__updateCoroutine = coroutine.create(function()
        local timerID = os.startTimer(DELTA)  -- Start a repeating timer
        while true do
            local event, param = os.pullEvent()  -- Wait for an event
            
            if event == "timer" and param == timerID then
                for _, service in pairs(ServiceRunner.__registeredServices) do
                    if service.onUpdate then
                        service.onUpdate(DELTA)
                    end
                end
                timerID = os.startTimer(DELTA)  -- Restart the timer
            end
        end
    end)()
end

function ServiceRunner.registerService(serviceName, service)
    if ServiceRunner.__registeredServices[serviceName] then error ("Service already exists") end
    ServiceRunner.__registeredServices[serviceName] = service
    return service
end

return ServiceRunner