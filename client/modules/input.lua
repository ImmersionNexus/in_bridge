--=========================================================================================================
--                                    INPUT & MENU SYSTEM (統合版)
--=========================================================================================================

--- 入力ダイアログを表示
--- @param data table
--- @return table|nil - 入力された値
function Bridge.ShowInput(data)
    local input = nil
    
    -- ox_lib input
    if GetResourceState('ox_lib') == 'started' and lib and lib.inputDialog then
        input = lib.inputDialog(data.header, data.inputs or data.rows)
    
    -- qb-input
    elseif GetResourceState('qb-input') == 'started' then
        local inputs = {}
        for i, row in ipairs(data.inputs or data.rows or {}) do
            table.insert(inputs, {
                text = row.label,
                name = row.name or "input" .. i,
                type = row.type or "text",
                isRequired = row.required or false,
                default = row.default,
            })
        end
        
        local dialog = exports['qb-input']:ShowInput({
            header = data.header,
            submitText = data.submitText or "Submit",
            inputs = inputs
        })
        
        if dialog then
            input = {}
            for _, row in ipairs(data.inputs or data.rows or {}) do
                input[row.name or "input" .. _] = dialog[row.name or "input" .. _]
            end
        end
    
    -- okokTextUI (簡易版)
    elseif GetResourceState('okokTextUI') == 'started' then
        -- okokTextUI は入力ダイアログをサポートしていないので、フォールバック
        print('[Bridge] okokTextUI does not support input dialogs, falling back to native')
    end
    
    return input
end

--- メニューを表示
--- @param data table
--- @return table|nil
function Bridge.ShowMenu(data)
    -- ox_lib context menu
    if GetResourceState('ox_lib') == 'started' and lib and lib.registerContext then
        local menuId = data.id or 'bridge_menu_' .. math.random(100000, 999999)
        
        lib.registerContext({
            id = menuId,
            title = data.header or data.title,
            options = data.options
        })
        
        lib.showContext(menuId)
        return true
    
    -- qb-menu
    elseif GetResourceState('qb-menu') == 'started' then
        local menuData = {
            {
                header = data.header or data.title,
                isMenuHeader = true
            }
        }
        
        for _, option in ipairs(data.options or {}) do
            table.insert(menuData, {
                header = option.title or option.label,
                txt = option.description,
                params = {
                    event = option.event,
                    isServer = option.serverEvent or false,
                    args = option.args
                }
            })
        end
        
        exports['qb-menu']:openMenu(menuData)
        return true
    
    -- nh-context
    elseif GetResourceState('nh-context') == 'started' then
        TriggerEvent('nh-context:sendMenu', data.options)
        return true
    end
    
    return nil
end

--- コンテキストメニューを閉じる
function Bridge.CloseMenu()
    if GetResourceState('ox_lib') == 'started' and lib and lib.hideContext then
        lib.hideContext()
    elseif GetResourceState('qb-menu') == 'started' then
        exports['qb-menu']:closeMenu()
    elseif GetResourceState('nh-context') == 'started' then
        TriggerEvent('nh-context:closeMenu')
    end
end

--- 確認ダイアログを表示
--- @param data table
--- @return boolean
function Bridge.ShowConfirm(data)
    -- ox_lib alert
    if GetResourceState('ox_lib') == 'started' and lib and lib.alertDialog then
        local alert = lib.alertDialog({
            header = data.header or data.title,
            content = data.message or data.description,
            centered = true,
            cancel = true,
            labels = {
                confirm = data.confirm or 'Confirm',
                cancel = data.cancel or 'Cancel'
            }
        })
        return alert == 'confirm'
    end
    
    -- フォールバック
    return true
end

--- スキルチェックを表示
--- @param difficulty string|table - 'easy'|'medium'|'hard' or custom
--- @return boolean
function Bridge.ShowSkillCheck(difficulty)
    -- ox_lib skillcheck
    if GetResourceState('ox_lib') == 'started' and lib and lib.skillCheck then
        local config = difficulty
        if type(difficulty) == 'string' then
            if difficulty == 'easy' then
                config = {'easy', 'easy'}
            elseif difficulty == 'medium' then
                config = {'easy', 'medium'}
            elseif difficulty == 'hard' then
                config = {'medium', 'hard', 'hard'}
            end
        end
        return lib.skillCheck(config)
    
    -- ps-ui skillcheck
    elseif GetResourceState('ps-ui') == 'started' then
        local success = false
        exports['ps-ui']:Circle(function(result)
            success = result
        end, 2, 10) -- 2 rounds, 10 seconds
        return success
    end
    
    -- フォールバック
    return true
end
