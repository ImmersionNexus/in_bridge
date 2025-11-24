--=========================================================================================================
--                                    VEHICLE KEYS & FUEL SYSTEM
--=========================================================================================================

if IsDuplicityVersion() then
    -- ========== SERVER SIDE ==========
    
    --- 車両キーを付与
    --- @param source number
    --- @param plate string
    function Bridge.GiveVehicleKeys(source, plate)
        if GetResourceState('qb-vehiclekeys') == 'started' then
            TriggerClientEvent('qb-vehiclekeys:client:AddKeys', source, plate)
        elseif GetResourceState('qs-vehiclekeys') == 'started' then
            exports['qs-vehiclekeys']:GiveKeys(source, plate)
        elseif GetResourceState('cd_garage') == 'started' then
            TriggerClientEvent('cd_garage:AddKeys', source, plate)
        elseif GetResourceState('wasabi_carlock') == 'started' then
            exports.wasabi_carlock:GiveKey(source, plate)
        end
    end
    
    --- 車両キーを削除
    --- @param source number
    --- @param plate string
    function Bridge.RemoveVehicleKeys(source, plate)
        if GetResourceState('qb-vehiclekeys') == 'started' then
            TriggerClientEvent('qb-vehiclekeys:client:RemoveKeys', source, plate)
        elseif GetResourceState('qs-vehiclekeys') == 'started' then
            exports['qs-vehiclekeys']:RemoveKeys(source, plate)
        elseif GetResourceState('wasabi_carlock') == 'started' then
            exports.wasabi_carlock:RemoveKey(source, plate)
        end
    end
    
    --- 車両キーを持っているかチェック
    --- @param source number
    --- @param plate string
    --- @return boolean
    function Bridge.HasVehicleKeys(source, plate)
        if GetResourceState('qb-vehiclekeys') == 'started' then
            -- QB VehicleKeys はクライアント側でチェック
            local hasKeys = false
            Bridge.TriggerClientCallback(source, 'bridge:client:hasVehicleKeys', function(result)
                hasKeys = result
            end, plate)
            Wait(100)
            return hasKeys
        elseif GetResourceState('qs-vehiclekeys') == 'started' then
            return exports['qs-vehiclekeys']:HasKeys(source, plate)
        end
        return true -- デフォルトは true
    end

else
    -- ========== CLIENT SIDE ==========
    
    --- 車両キーを持っているかチェック (クライアント側)
    --- @param plate string
    --- @return boolean
    function Bridge.HasVehicleKeys(plate)
        if GetResourceState('qb-vehiclekeys') == 'started' then
            return exports['qb-vehiclekeys']:HasKeys()
        elseif GetResourceState('qs-vehiclekeys') == 'started' then
            return exports['qs-vehiclekeys']:HasKeys(plate)
        elseif GetResourceState('wasabi_carlock') == 'started' then
            return exports.wasabi_carlock:HasKey(plate)
        end
        return true
    end
    
    --- クライアント側のキーチェックコールバック
    Bridge.RegisterClientCallback('bridge:client:hasVehicleKeys', function(cb, plate)
        cb(Bridge.HasVehicleKeys(plate))
    end)
end

--=========================================================================================================
--                                    FUEL SYSTEM (CLIENT SIDE)
--=========================================================================================================

if not IsDuplicityVersion() then
    --- 車両の燃料を取得
    --- @param vehicle number
    --- @return number
    function Bridge.GetVehicleFuel(vehicle)
        if GetResourceState('LegacyFuel') == 'started' then
            return exports['LegacyFuel']:GetFuel(vehicle)
        elseif GetResourceState('ox_fuel') == 'started' then
            return GetVehicleFuelLevel(vehicle)
        elseif GetResourceState('ps-fuel') == 'started' then
            return exports['ps-fuel']:GetFuel(vehicle)
        elseif GetResourceState('cdn-fuel') == 'started' then
            return exports['cdn-fuel']:GetFuel(vehicle)
        elseif GetResourceState('qs-fuelstations') == 'started' then
            return exports['qs-fuelstations']:GetFuel(vehicle)
        else
            return GetVehicleFuelLevel(vehicle)
        end
    end
    
    --- 車両の燃料を設定
    --- @param vehicle number
    --- @param fuel number
    function Bridge.SetVehicleFuel(vehicle, fuel)
        if GetResourceState('LegacyFuel') == 'started' then
            exports['LegacyFuel']:SetFuel(vehicle, fuel)
        elseif GetResourceState('ox_fuel') == 'started' then
            Entity(vehicle).state.fuel = fuel
        elseif GetResourceState('ps-fuel') == 'started' then
            exports['ps-fuel']:SetFuel(vehicle, fuel)
        elseif GetResourceState('cdn-fuel') == 'started' then
            exports['cdn-fuel']:SetFuel(vehicle, fuel)
        elseif GetResourceState('qs-fuelstations') == 'started' then
            exports['qs-fuelstations']:SetFuel(vehicle, fuel)
        else
            SetVehicleFuelLevel(vehicle, fuel + 0.0)
        end
    end
end
