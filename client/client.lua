RegisterCommand("extrasmenu", function()
    local playerPed = cache.ped
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle == 0 then
        lib.notify({
            title = 'Car Nenu',
            description = 'You are not in a vehicle',
            type = 'error'
        })
        return
    end

    lib.registerContext({
        id = 'carmenu',
        title = "Car menu",
        canClose = true,
        options = {
            {
                title = "Extras",
                description = "Enable or disable extras",
                onSelect = function()
                    OpenMenu("extras", vehicle)
                end
            },
            {
                title = "Livery",
                description = "Enable or disable livery",
                onSelect = function()
                    OpenMenu("livery", vehicle)
                end
            }
        }
    })
    lib.showContext('carmenu')

end)

function OpenMenu(option, vehicle)
    local veh = vehicle
    local options = {}

    if option == "extras" then
        for extraID = 0, 20 do
            if DoesExtraExist(veh, extraID) then
                local isEnabled = IsVehicleExtraTurnedOn(veh, extraID)
                local toggle = isEnabled and "toggle-on" or "toggle-off"
                local toggleColor = isEnabled and "green" or "red"

                table.insert(options, {
                    title = "Toggle Extra ID #" .. extraID,
                    icon = toggle,
                    iconColor = toggleColor,
                    onSelect = function()
                        SetVehicleExtra(veh, extraID, isEnabled and 1 or 0)
                        print(string.format("Toggled Extra %d to %s", extraID, tostring(not isEnabled)))
                        OpenMenu('extras', veh)
                    end
                })
            end
        end

        lib.registerContext({
            id = 'vehicle_extras_menu',
            title = 'Vehicle Extras',
            menu = 'carmenu',
            options = options
        })

        lib.showContext('vehicle_extras_menu')

    elseif option == "livery" then
        local liveryCount = GetVehicleLiveryCount(veh)
        local currentLivery = GetVehicleLivery(veh)

        if liveryCount and liveryCount > 0 then
            for i = 0, liveryCount - 1 do
                local isCurrent = (i == currentLivery)
                local toggle = isCurrent and "toggle-on" or "toggle-off"
                local toggleColor = isCurrent and "green" or "red"

                table.insert(options, {
                    title = "Toogle Livery ID #" .. i,
                    icon = toggle,
                    iconColor = toggleColor,
                    onSelect = function()
                        SetVehicleLivery(veh, i)
                        print("Livery set to ID: " .. i)
                        OpenMenu('livery', veh)
                    end
                })
            end

            lib.registerContext({
                id = 'vehicle_livery_menu',
                title = 'Vehicle Liveries',
                menu = 'carmenu',
                options = options
            })

            lib.showContext('vehicle_livery_menu')
        else
            print("This vehicle has no liveries.")
        end
    end
end