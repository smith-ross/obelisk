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
    while true do
        for _, service in pairs(ServiceRunner.__registeredServices) do
            if service.onUpdate then
                service.onUpdate(DELTA)
            end
        end
        os.sleep(DELTA)
    end
end

function ServiceRunner.registerService(serviceName, service)
    if ServiceRunner.__registeredServices[serviceName] then error ("Service already exists") end
    ServiceRunner.__registeredServices[serviceName] = service
    return service
end

return ServiceRunner