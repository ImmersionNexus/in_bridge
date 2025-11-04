-- アイテム追加
function Bridge.AddItem(source, item, amount, slot, metadata)
    amount = amount or 1
    
    if Bridge.Inventory == 'ox_inventory' then
        return exports.ox_inventory:AddItem(source, item, amount, metadata, slot)
    elseif Bridge.Inventory == 'qb-inventory' then
        local Player = Bridge.GetPlayer(source)
        if Player then
            return Player.Functions.AddItem(item, amount, slot, metadata)
        end
    elseif Bridge.Inventory == 'qs-inventory' then
        return exports['qs-inventory']:AddItem(source, item, amount, slot, metadata)
    end
    return false
end

-- アイテム削除
function Bridge.RemoveItem(source, item, amount, slot, metadata)
    amount = amount or 1
    
    if Bridge.Inventory == 'ox_inventory' then
        return exports.ox_inventory:RemoveItem(source, item, amount, metadata, slot)
    elseif Bridge.Inventory == 'qb-inventory' then
        local Player = Bridge.GetPlayer(source)
        if Player then
            return Player.Functions.RemoveItem(item, amount, slot)
        end
    elseif Bridge.Inventory == 'qs-inventory' then
        return exports['qs-inventory']:RemoveItem(source, item, amount, slot)
    end
    return false
end

-- アイテム所持チェック
function Bridge.HasItem(source, item, amount)
    amount = amount or 1
    
    if Bridge.Inventory == 'ox_inventory' then
        local count = exports.ox_inventory:Search(source, 'count', item)
        return count >= amount
    elseif Bridge.Inventory == 'qb-inventory' then
        local Player = Bridge.GetPlayer(source)
        if Player then
            local item = Player.Functions.GetItemByName(item)
            return item and item.amount >= amount
        end
    elseif Bridge.Inventory == 'qs-inventory' then
        local hasItem = exports['qs-inventory']:GetItemTotalAmount(source, item)
        return hasItem >= amount
    end
    return false
end

-- アイテム情報取得
function Bridge.GetItem(source, item)
    if Bridge.Inventory == 'ox_inventory' then
        return exports.ox_inventory:GetItem(source, item)
    elseif Bridge.Inventory == 'qb-inventory' then
        local Player = Bridge.GetPlayer(source)
        if Player then
            return Player.Functions.GetItemByName(item)
        end
    elseif Bridge.Inventory == 'qs-inventory' then
        return exports['qs-inventory']:GetItem(source, item)
    end
    return nil
end