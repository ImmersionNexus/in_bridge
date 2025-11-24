fx_version 'cerulean'
game 'gta5'

author 'Your Team'
description 'FiveM Universal Bridge System - QB-Core, ESX, QBox対応'
version '2.0.0'
lua54 'yes'

-- Shared (両方で使う)
shared_scripts {
    '@ox_lib/init.lua', -- ox_lib を使う場合
    'shared/config.lua',
    'shared/locales.lua',
    'shared/main.lua',
    'shared/utils.lua',
}

-- Server側
server_scripts {
    '@oxmysql/lib/MySQL.lua', -- MySQL を使う場合
    'server/main.lua',
    'server/modules/callback.lua',
    'server/modules/player.lua',
    'server/modules/money.lua',
    'server/modules/inventory.lua',
    'server/modules/logger.lua',
    'server/modules/stash.lua',
    'server/modules/society.lua',
    'server/modules/vehicle_extras.lua',
}

-- Client側
client_scripts {
    'client/main.lua',
    'client/modules/callback.lua',
    'client/modules/notify.lua',
    'client/modules/vehicles.lua',
    'client/modules/draw.lua',
    'client/modules/utils.lua',
    'client/modules/target.lua',
    'client/modules/progressbar.lua',
    'client/modules/input.lua',
    'client/modules/stash.lua',
    'client/modules/vehicle_extras.lua',
}

-- 依存関係（オプション）
dependencies {
    '/server:5848',  -- 最小サーバーバージョン
    '/onesync',      -- OneSync推奨
}

-- エクスポート
server_exports {
    'GetBridge'
}

client_exports {
    'GetBridge'
}

-- 提供されるエクスポート一覧
exports {
    -- Framework
    'GetFramework',
    'GetFrameworkName',
    
    -- Player (Server)
    'GetPlayer',
    'GetIdentifier',
    'GetPlayerName',
    'GetJob',
    'HasJob',
    'GetGang',
    'DoesPlayerExist',
    'GetPlayers',
    
    -- Money (Server)
    'GetMoney',
    'AddMoney',
    'RemoveMoney',
    'GetBankMoney',
    'AddBankMoney',
    'RemoveBankMoney',
    'TransferMoney',
    'AddMoneyOffline',
    
    -- Society (Server)
    'GetSocietyMoney',
    'AddSocietyMoney',
    'RemoveSocietyMoney',
    'GetGangMoney',
    'AddGangMoney',
    'RemoveGangMoney',
    
    -- Inventory (Server)
    'AddItem',
    'RemoveItem',
    'HasItem',
    'GetItem',
    
    -- Stash (Server/Client)
    'RegisterStash',
    'OpenStash',
    'GetStashItems',
    'ClearStash',
    'OpenTrunk',
    'OpenGlovebox',
    
    -- Vehicle Keys (Server/Client)
    'GiveVehicleKeys',
    'RemoveVehicleKeys',
    'HasVehicleKeys',
    
    -- Fuel (Client)
    'GetVehicleFuel',
    'SetVehicleFuel',
    
    -- Logger (Server)
    'Log',
    'SendWebhook',
    'SendDiscordLog',
    'LogPlayerAction',
    
    -- Callback (Server/Client)
    'RegisterCallback',
    'TriggerCallback',
    'RegisterClientCallback',
    'TriggerClientCallback',
    
    -- Notify (Client)
    'Notify',
    
    -- Vehicles (Client)
    'SpawnVehicle',
    'DeleteVehicle',
    'GetPlayerVehicle',
    'GetClosestVehicle',
    
    -- Draw (Client)
    'DrawText3D',
    'DrawMarker',
    'ShowTextUI',
    'HideTextUI',
    
    -- Target (Client)
    'AddTargetEntity',
    'RemoveTargetEntity',
    'AddTargetModel',
    'RemoveTargetModel',
    'AddBoxZone',
    'RemoveZone',
    'AddGlobalPlayer',
    'AddGlobalVehicle',
    
    -- Progress (Client)
    'ShowProgress',
    'CancelProgress',
    'IsProgressActive',
    
    -- Input/Menu (Client)
    'ShowInput',
    'ShowMenu',
    'CloseMenu',
    'ShowConfirm',
    'ShowSkillCheck',
    
    -- Utils (Shared)
    'GetDistance',
    'IsPlayerNearby',
    'IsControlPressed',
    'ShowHelpText',
    'Try',
    'SafeCall',
    'IsTableEmpty',
    'DeepCopy',
    'TableContains',
    'GetTableKeys',
    'SplitString',
    'Trim',
    'Capitalize',
    'Clamp',
    'Round',
    'Random',
    'MsToTime',
    'FormatTime',
    'Lerp',
    'GetAngleBetweenPoints',

    -- Locale (Shared)
    'GetLocaleText',
    'L',
    'GetCurrentLang',
    'SetLang',
    'GetAvailableLanguages',
    'AddLocale',
    'AddLocales',
}
