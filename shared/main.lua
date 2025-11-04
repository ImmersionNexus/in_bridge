Bridge = {}
Bridge.Framework = nil
Bridge.Inventory = nil
Bridge.Ready = false

function Bridge.Init()
    -- フレームワーク検出
    if GetResourceState('qb-core') == 'started' then
        Bridge.Framework = exports['qb-core']:GetCoreObject()
        Bridge.FrameworkName = 'qbcore'
        print('[Bridge] QB-Core が検出されました')
    elseif GetResourceState('es_extended') == 'started' then
        Bridge.Framework = exports['es_extended']:getSharedObject()
        Bridge.FrameworkName = 'esx'
        print('[Bridge] ESX が検出されました')
    else
        Bridge.FrameworkName = 'standalone'
        print('[Bridge] フレームワークが検出されませんでした (スタンドアロンモード)')
    end

    -- インベントリシステム検出
    if GetResourceState('ox_inventory') == 'started' then
        Bridge.Inventory = 'ox_inventory'
        print('[Bridge] ox_inventory が検出されました')
    elseif GetResourceState('qb-inventory') == 'started' then
        Bridge.Inventory = 'qb-inventory'
        print('[Bridge] qb-inventory が検出されました')
    elseif GetResourceState('qs-inventory') == 'started' then
        Bridge.Inventory = 'qs-inventory'
        print('[Bridge] qs-inventory が検出されました')
    end
    
    Bridge.Ready = true
    print('[Bridge] 初期化完了')
end

-- Configのバリデーション
function Bridge.ValidateConfig()
    if not Config or not Config.DefaultSettings then
        print('[Bridge] WARNING: Config が見つかりません。デフォルト設定を使用します。')
        Config = {
            DefaultSettings = {
                notify = "standalone",
                textui = "standalone"
            }
        }
    end
end

-- 初期化を待つ関数
function Bridge.WaitForReady()
    while not Bridge.Ready do
        Wait(100)
    end
end

-- 初期化実行
CreateThread(function()
    Bridge.ValidateConfig()
    Bridge.Init()
end)

-- エクスポート（サーバーとクライアント共通）
if IsDuplicityVersion() then
    -- Server側
    exports('GetBridge', function()
        return Bridge
    end)
else
    -- Client側
    exports('GetBridge', function()
        return Bridge
    end)
end