--=========================================================================================================
--                                    JSON STORAGE SYSTEM
--=========================================================================================================
-- このモジュールをfxmanifest.luaに追加してください:
-- server_scripts {
--     ...
--     'server/modules/storage.lua',
-- }
--=========================================================================================================

if IsDuplicityVersion() then
    -- ========== SERVER SIDE ONLY ==========
    
    local resourceName = GetCurrentResourceName()
    local dataPath = 'data/'
    
    --- ディレクトリが存在するか確認し、なければ作成
    --- @param path string
    --- @return boolean
    local function EnsureDirectory(path)
        local fullPath = GetResourcePath(resourceName) .. '/' .. path
        
        -- ディレクトリの存在確認
        local dir = io.open(fullPath, 'r')
        if dir then
            dir:close()
            return true
        end
        
        -- ディレクトリを作成
        os.execute('mkdir "' .. fullPath .. '"')
        return true
    end
    
    --- ファイルパスを正規化
    --- @param filename string
    --- @param customPath string|nil
    --- @return string
    local function GetFilePath(filename, customPath)
        local basePath = customPath or dataPath
        EnsureDirectory(basePath)
        
        -- .json拡張子を自動追加
        if not filename:match('%.json$') then
            filename = filename .. '.json'
        end
        
        return GetResourcePath(resourceName) .. '/' .. basePath .. filename
    end
    
    --=========================================================================================================
    --                                     PUBLIC FUNCTIONS
    --=========================================================================================================
    
    --- JSONデータをファイルに保存
    --- @param filename string - ファイル名（拡張子なしでもOK）
    --- @param data table - 保存するデータ
    --- @param customPath string|nil - カスタムパス（デフォルト: 'data/'）
    --- @return boolean - 成功したかどうか
    function Bridge.SaveJSON(filename, data, customPath)
        if type(data) ~= 'table' then
            print('[Bridge ERROR] SaveJSON: data must be a table')
            return false
        end
        
        local filePath = GetFilePath(filename, customPath)
        
        local success, encoded = pcall(json.encode, data)
        if not success then
            print('[Bridge ERROR] SaveJSON: Failed to encode JSON - ' .. tostring(encoded))
            return false
        end
        
        local file = io.open(filePath, 'w')
        if not file then
            print('[Bridge ERROR] SaveJSON: Failed to open file - ' .. filePath)
            return false
        end
        
        file:write(encoded)
        file:close()
        
        print('[Bridge] JSON saved: ' .. filePath)
        return true
    end
    
    --- JSONファイルからデータを読み込み
    --- @param filename string - ファイル名（拡張子なしでもOK）
    --- @param default table|nil - ファイルが存在しない場合のデフォルト値
    --- @param customPath string|nil - カスタムパス（デフォルト: 'data/'）
    --- @return table|nil - 読み込んだデータ、失敗時はデフォルト値またはnil
    function Bridge.LoadJSON(filename, default, customPath)
        local filePath = GetFilePath(filename, customPath)
        
        local file = io.open(filePath, 'r')
        if not file then
            print('[Bridge] LoadJSON: File not found - ' .. filePath)
            return default
        end
        
        local content = file:read('*a')
        file:close()
        
        if not content or content == '' then
            print('[Bridge] LoadJSON: File is empty - ' .. filePath)
            return default
        end
        
        local success, decoded = pcall(json.decode, content)
        if not success then
            print('[Bridge ERROR] LoadJSON: Failed to decode JSON - ' .. tostring(decoded))
            return default
        end
        
        print('[Bridge] JSON loaded: ' .. filePath)
        return decoded
    end
    
    --- ファイルが存在するかチェック
    --- @param filename string
    --- @param customPath string|nil
    --- @return boolean
    function Bridge.FileExists(filename, customPath)
        local filePath = GetFilePath(filename, customPath)
        local file = io.open(filePath, 'r')
        if file then
            file:close()
            return true
        end
        return false
    end
    
    --- JSONファイルを削除
    --- @param filename string
    --- @param customPath string|nil
    --- @return boolean
    function Bridge.DeleteJSON(filename, customPath)
        local filePath = GetFilePath(filename, customPath)
        
        if not Bridge.FileExists(filename, customPath) then
            print('[Bridge] DeleteJSON: File not found - ' .. filePath)
            return false
        end
        
        local success = os.remove(filePath)
        if success then
            print('[Bridge] JSON deleted: ' .. filePath)
            return true
        else
            print('[Bridge ERROR] DeleteJSON: Failed to delete - ' .. filePath)
            return false
        end
    end
    
    --- すべてのJSONファイルをリスト表示（指定ディレクトリ内）
    --- @param customPath string|nil
    --- @return table - ファイル名のリスト
    function Bridge.ListJSONFiles(customPath)
        local basePath = customPath or dataPath
        local fullPath = GetResourcePath(resourceName) .. '/' .. basePath
        local files = {}
        
        -- Windowsの場合
        local handle = io.popen('dir "' .. fullPath .. '*.json" /B 2>nul')
        if handle then
            for filename in handle:lines() do
                table.insert(files, filename)
            end
            handle:close()
        end
        
        -- Linuxの場合（上記が失敗した場合）
        if #files == 0 then
            handle = io.popen('ls "' .. fullPath .. '"*.json 2>/dev/null')
            if handle then
                for filename in handle:lines() do
                    table.insert(files, filename)
                end
                handle:close()
            end
        end
        
        return files
    end
    
    --- JSON内の特定のキーを更新（部分更新）
    --- @param filename string
    --- @param key string
    --- @param value any
    --- @param customPath string|nil
    --- @return boolean
    function Bridge.UpdateJSON(filename, key, value, customPath)
        local data = Bridge.LoadJSON(filename, {}, customPath)
        if not data then
            print('[Bridge ERROR] UpdateJSON: Failed to load existing data')
            return false
        end
        
        data[key] = value
        return Bridge.SaveJSON(filename, data, customPath)
    end
    
    --- JSONファイルをバックアップ
    --- @param filename string
    --- @param customPath string|nil
    --- @return boolean
    function Bridge.BackupJSON(filename, customPath)
        local data = Bridge.LoadJSON(filename, nil, customPath)
        if not data then
            print('[Bridge ERROR] BackupJSON: Failed to load data')
            return false
        end
        
        local timestamp = os.date('%Y%m%d_%H%M%S')
        local backupName = filename:gsub('%.json$', '') .. '_backup_' .. timestamp
        
        return Bridge.SaveJSON(backupName, data, customPath)
    end
    
    --=========================================================================================================
    --                                     ASYNC VERSIONS (非同期版)
    --=========================================================================================================
    
    --- 非同期でJSONを保存
    --- @param filename string
    --- @param data table
    --- @param callback function|nil
    --- @param customPath string|nil
    function Bridge.SaveJSONAsync(filename, data, callback, customPath)
        CreateThread(function()
            local success = Bridge.SaveJSON(filename, data, customPath)
            if callback then
                callback(success)
            end
        end)
    end
    
    --- 非同期でJSONを読み込み
    --- @param filename string
    --- @param callback function
    --- @param default table|nil
    --- @param customPath string|nil
    function Bridge.LoadJSONAsync(filename, callback, default, customPath)
        CreateThread(function()
            local data = Bridge.LoadJSON(filename, default, customPath)
            callback(data)
        end)
    end
    
    --=========================================================================================================
    --                                     INITIALIZATION
    --=========================================================================================================
    
    -- 起動時にdataディレクトリを作成
    CreateThread(function()
        EnsureDirectory(dataPath)
        print('[Bridge] JSON Storage System initialized')
    end)
    
else
    print('[Bridge WARNING] JSON Storage functions are only available on server-side')
end
