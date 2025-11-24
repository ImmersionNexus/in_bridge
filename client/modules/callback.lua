--=========================================================================================================
--                                    CALLBACK SYSTEM (統合版)
--=========================================================================================================

Bridge.ServerCallbacks = {}
Bridge.CurrentRequestId = 0

if IsDuplicityVersion() then
    -- ========== SERVER SIDE ==========
    
    --- コールバックを登録
    --- @param name string
    --- @param callback function
    function Bridge.RegisterCallback(name, callback)
        Bridge.ServerCallbacks[name] = callback
    end
    
    --- コールバックリクエストを受信
    RegisterNetEvent('bridge:server:triggerCallback', function(name, requestId, ...)
        local src = source
        
        if Bridge.ServerCallbacks[name] then
            Bridge.ServerCallbacks[name](src, function(...)
                TriggerClientEvent('bridge:client:triggerCallback', src, requestId, ...)
            end, ...)
        else
            print('[Bridge ERROR] Callback not found: ' .. name)
            TriggerClientEvent('bridge:client:triggerCallback', src, requestId, nil)
        end
    end)

else
    -- ========== CLIENT SIDE ==========
    
    Bridge.ClientCallbacks = {}
    
    --- サーバーコールバックを呼び出し
    --- @param name string
    --- @param callback function
    --- @param ... any
    function Bridge.TriggerCallback(name, callback, ...)
        Bridge.CurrentRequestId = Bridge.CurrentRequestId + 1
        local requestId = Bridge.CurrentRequestId
        
        Bridge.ClientCallbacks[requestId] = callback
        
        TriggerServerEvent('bridge:server:triggerCallback', name, requestId, ...)
    end
    
    --- コールバックレスポンスを受信
    RegisterNetEvent('bridge:client:triggerCallback', function(requestId, ...)
        if Bridge.ClientCallbacks[requestId] then
            Bridge.ClientCallbacks[requestId](...)
            Bridge.ClientCallbacks[requestId] = nil
        end
    end)
    
    --- クライアントコールバックを登録
    --- @param name string
    --- @param callback function
    function Bridge.RegisterClientCallback(name, callback)
        Bridge.ServerCallbacks[name] = callback
    end
    
    --- クライアントコールバックを呼び出し
    RegisterNetEvent('bridge:client:executeCallback', function(name, requestId, ...)
        if Bridge.ServerCallbacks[name] then
            Bridge.ServerCallbacks[name](function(...)
                TriggerServerEvent('bridge:server:callbackResponse', requestId, ...)
            end, ...)
        end
    end)
end

-- SERVER側: クライアントコールバックを呼び出す
if IsDuplicityVersion() then
    Bridge.ClientRequests = {}
    
    --- クライアントコールバックを呼び出し
    --- @param source number
    --- @param name string
    --- @param callback function
    --- @param ... any
    function Bridge.TriggerClientCallback(source, name, callback, ...)
        Bridge.CurrentRequestId = Bridge.CurrentRequestId + 1
        local requestId = Bridge.CurrentRequestId
        
        Bridge.ClientRequests[requestId] = callback
        
        TriggerClientEvent('bridge:client:executeCallback', source, name, requestId, ...)
    end
    
    --- クライアントからのレスポンスを受信
    RegisterNetEvent('bridge:server:callbackResponse', function(requestId, ...)
        if Bridge.ClientRequests[requestId] then
            Bridge.ClientRequests[requestId](...)
            Bridge.ClientRequests[requestId] = nil
        end
    end)
end
