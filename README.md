# FiveM Universal Bridge System

QB-Core、ESX、QBox、Standaloneに対応した統合ブリッジシステム

## 🌟 特徴

- **マルチフレームワーク対応**: QB-Core, ESX, QBox, Standalone
- **インベントリシステム対応**: ox_inventory, qb-inventory, qs-inventory
- **通知システム対応**: ox_lib, qb-core, esx, okokNotify, ss_notify
- **TextUI対応**: ox_lib, okokTextUI, jg-textui, ss_textui, qb-core
- **Target対応**: ox_target, qb-target, qtarget
- **Progress Bar対応**: ox_lib, progressbar, qb-core, esx_progressbar
- **Input/Menu対応**: ox_lib, qb-input, qb-menu, nh-context
- **Fuel対応**: LegacyFuel, ox_fuel, ps-fuel, cdn-fuel, qs-fuelstations
- **Vehicle Keys対応**: qb-vehiclekeys, qs-vehiclekeys, cd_garage, wasabi_carlock

## 📁 ファイル構造

```
bridge/
├── fxmanifest.lua
├── shared/
│   ├── config.lua
│   ├── main.lua
│   └── utils.lua
├── server/
│   ├── main.lua
│   └── modules/
│       ├── callback.lua
│       ├── player.lua
│       ├── money.lua
│       ├── inventory.lua
│       ├── logger.lua
│       ├── stash.lua
│       ├── society.lua
│       └── vehicle_extras.lua
└── client/
    ├── main.lua
    └── modules/
        ├── callback.lua
        ├── notify.lua
        ├── vehicles.lua
        ├── draw.lua
        ├── utils.lua
        ├── target.lua
        ├── progressbar.lua
        ├── input.lua
        ├── stash.lua
        └── vehicle_extras.lua
```

## 🚀 インストール

1. `bridge` フォルダをサーバーの `resources` フォルダに配置
2. `server.cfg` に以下を追加:

```cfg
ensure bridge
```

## 📖 使用方法

### 基本的な使い方

```lua
local Bridge = exports['bridge']:GetBridge()

-- フレームワークの準備を待つ
Bridge.WaitForReady()
```

### プレイヤー機能 (Server)

```lua
-- プレイヤーデータ取得
local Player = Bridge.GetPlayer(source)

-- プレイヤー名取得
local name = Bridge.GetPlayerName(source)

-- ジョブ取得
local job, grade = Bridge.GetJob(source)

-- ジョブチェック
if Bridge.HasJob(source, 'police', 2) then
    print('警察官 グレード2以上')
end

-- 全プレイヤー取得
local players = Bridge.GetPlayers()
```

### お金の管理 (Server)

```lua
-- 所持金取得
local cash = Bridge.GetMoney(source, 'cash')
local bank = Bridge.GetMoney(source, 'bank')

-- お金を追加
Bridge.AddMoney(source, 1000, 'cash', '給料')

-- お金を削除
Bridge.RemoveMoney(source, 500, 'bank', '購入')

-- 送金
Bridge.TransferMoney(source, targetSource, 1000, '送金')
```

### インベントリ (Server)

```lua
-- アイテム追加
Bridge.AddItem(source, 'water', 5)

-- アイテム削除
Bridge.RemoveItem(source, 'bread', 2)

-- アイテム所持チェック
if Bridge.HasItem(source, 'lockpick', 1) then
    print('ロックピックを持っています')
end

-- アイテム情報取得
local item = Bridge.GetItem(source, 'phone')
```

### スタッシュ/ストレージ (Server)

```lua
-- スタッシュ登録
Bridge.RegisterStash('police_evidence', {
    label = '証拠品保管庫',
    slots = 50,
    weight = 100000,
    owner = false
})

-- スタッシュを開く
Bridge.OpenStash(source, 'police_evidence')

-- トランク/グローブボックス
Bridge.OpenTrunk(source, plate)
Bridge.OpenGlovebox(source, plate)
```

### Society/Gang マネー (Server)

```lua
-- ソサエティの資金取得
Bridge.GetSocietyMoney('police', function(money)
    print('警察の資金: $' .. money)
end)

-- 資金追加
Bridge.AddSocietyMoney('police', 10000)

-- 資金削除
Bridge.RemoveSocietyMoney('police', 5000)

-- ギャング資金 (QB-Core)
local gangMoney = Bridge.GetGangMoney('ballas')
Bridge.AddGangMoney('ballas', 5000)
```

### 車両キー (Server/Client)

```lua
-- キー付与 (Server)
Bridge.GiveVehicleKeys(source, plate)

-- キー削除 (Server)
Bridge.RemoveVehicleKeys(source, plate)

-- キー所持チェック (Client)
if Bridge.HasVehicleKeys(plate) then
    print('キーを持っています')
end
```

### Callback システム

```lua
-- Server側: Callback登録
Bridge.RegisterCallback('myresource:getData', function(source, cb, arg1, arg2)
    local data = {
        result = arg1 + arg2
    }
    cb(data)
end)

-- Client側: Callbackを呼び出し
Bridge.TriggerCallback('myresource:getData', function(data)
    print('結果:', data.result)
end, 5, 10)
```

### 通知 (Client)

```lua
Bridge.Notify('タイトル', 'メッセージ', 'success', 5000)
-- type: 'success', 'error', 'info', 'warning'
```

### TextUI (Client)

```lua
-- 表示
Bridge.ShowTextUI('[E] ドアを開ける', 'right')

-- 非表示
Bridge.HideTextUI()
```

### Progress Bar (Client)

```lua
local success = Bridge.ShowProgress({
    duration = 5000,
    label = '修理中...',
    canCancel = true,
    disable = {
        move = true,
        car = true,
        combat = true,
    },
    animation = {
        dict = 'mini@repair',
        anim = 'fixing_a_player',
        flag = 49
    },
    prop = {
        model = 'prop_tool_wrench',
        bone = 57005,
        pos = vector3(0.1, 0.0, 0.0),
        rot = vector3(0.0, 0.0, 0.0)
    }
})

if success then
    print('修理完了')
else
    print('修理キャンセル')
end
```

### Input Dialog (Client)

```lua
local input = Bridge.ShowInput({
    header = 'プレイヤー情報',
    inputs = {
        {
            name = 'name',
            label = '名前',
            type = 'text',
            required = true
        },
        {
            name = 'age',
            label = '年齢',
            type = 'number',
            required = true
        }
    }
})

if input then
    print('名前:', input.name)
    print('年齢:', input.age)
end
```

### Menu/Context (Client)

```lua
Bridge.ShowMenu({
    id = 'my_menu',
    title = 'メニュー',
    options = {
        {
            title = 'オプション1',
            description = '説明文',
            icon = 'fas fa-star',
            onSelect = function()
                print('オプション1が選択されました')
            end
        },
        {
            title = 'オプション2',
            event = 'myresource:option2',
            args = {data = 'test'}
        }
    }
})
```

### Target System (Client)

```lua
-- エンティティにターゲット追加
Bridge.AddTargetEntity(entity, {
    {
        name = 'interact',
        label = '話しかける',
        icon = 'fas fa-comments',
        onSelect = function(data)
            print('話しかけました')
        end
    }
})

-- モデルにターゲット追加
Bridge.AddTargetModel({'prop_atm_01', 'prop_atm_02'}, {
    {
        name = 'use_atm',
        label = 'ATMを使う',
        icon = 'fas fa-credit-card',
        onSelect = function()
            -- ATMを開く処理
        end
    }
})

-- ボックスゾーン追加
local zoneId = Bridge.AddBoxZone({
    name = 'shop_zone',
    coords = vector3(0.0, 0.0, 0.0),
    size = vector3(2.0, 2.0, 2.0),
    rotation = 0.0,
    debug = false,
    options = {
        {
            name = 'open_shop',
            label = 'ショップを開く',
            icon = 'fas fa-shopping-cart',
            onSelect = function()
                print('ショップを開きました')
            end
        }
    }
})
```

### 車両 (Client)

```lua
-- 車両スポーン
Bridge.SpawnVehicle('adder', vector3(0, 0, 0), 0.0, function(vehicle)
    print('車両がスポーンしました: ' .. vehicle)
end)

-- 最も近い車両を取得
local vehicle, distance = Bridge.GetClosestVehicle(GetEntityCoords(PlayerPedId()), 5.0)

-- 燃料取得/設定
local fuel = Bridge.GetVehicleFuel(vehicle)
Bridge.SetVehicleFuel(vehicle, 50.0)
```

### Logger (Server)

```lua
-- 基本ログ
Bridge.Log(source, 'item_purchase', 'プレイヤーがアイテムを購入しました')

-- Discord Webhook
Bridge.SendWebhook(
    'WEBHOOK_URL',
    'アイテム購入',
    'プレイヤーがアイテムを購入しました',
    0x00FF00
)

-- 詳細なDiscordログ
Bridge.SendDiscordLog(
    'WEBHOOK_URL',
    'Server Logger',
    'プレイヤーアクション',
    {
        {name = 'プレイヤー', value = 'John Doe', inline = true},
        {name = 'アクション', value = '購入', inline = true},
        {name = '金額', value = '$1000', inline = true}
    },
    0x3498DB
)

-- プレイヤーアクションログ
Bridge.LogPlayerAction(source, 'WEBHOOK_URL', '車両購入', {
    {name = '車両', value = 'Adder', inline = true},
    {name = '価格', value = '$50000', inline = true}
}, 0x00FF00)
```

### Utils (共通)

```lua
-- 距離計算
local distance = Bridge.GetDistance(coords1, coords2)

-- テーブルユーティリティ
local isEmpty = Bridge.IsTableEmpty(tbl)
local copy = Bridge.DeepCopy(tbl)
local contains = Bridge.TableContains(tbl, value)

-- 文字列ユーティリティ
local parts = Bridge.SplitString("hello,world", ",")
local trimmed = Bridge.Trim("  text  ")

-- 数値ユーティリティ
local clamped = Bridge.Clamp(value, 0, 100)
local rounded = Bridge.Round(3.14159, 2)

-- エラーハンドリング
Bridge.Try(function()
    -- 実行したいコード
    error("テストエラー")
end).catch(function(err)
    print("エラー:", err)
end).finally(function()
    print("最終処理")
end)
```

## ⚙️ Config設定

`shared/config.lua` でデフォルト設定を変更できます:

```lua
Config.DefaultSettings = {
    notify = "ox",    -- "qb" | "esx" | "ox" | "okok" | "ss" | "standalone"
    textui = "jg",    -- "okok" | "jg" | "ss" | "qb" | "standalone"
}
```

## 🔧 依存関係

### 必須
- なし (スタンドアロンで動作)

### オプション
- `ox_lib` - 推奨 (Menu, Input, Progress, Target等)
- `oxmysql` - データベース操作に使用
- フレームワーク (qb-core, es_extended, qbox のいずれか)
- インベントリシステム
- 通知システム
- その他の連携リソース

## 📝 ライセンス

MIT License

## 🤝 貢献

プルリクエストを歓迎します!

## 💬 サポート

問題が発生した場合は、GitHubのIssuesで報告してください。

## 🔄 更新履歴

### v2.0.0
- 初回リリース
- QB-Core, ESX, QBox対応
- 全主要機能実装
