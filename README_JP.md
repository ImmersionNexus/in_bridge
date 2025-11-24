<div align="center">

# 🌉 in_bridge

### FiveM ユニバーサルブリッジシステム

[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](https://github.com/ImmersionNexus/in_bridge/releases)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![FiveM](https://img.shields.io/badge/FiveM-Ready-orange.svg)](https://fivem.net/)
[![Lua](https://img.shields.io/badge/Lua-5.4-purple.svg)](https://www.lua.org/)

**QB-Core • ESX • QBox • Standalone**

[📖 ドキュメント](#-使用方法) • [🚀 インストール](#-インストール) • [💬 Discord](https://discord.gg/yourdiscord) • [🐛 Issues](https://github.com/ImmersionNexus/in_bridge/issues)

---

*フレームワークに依存しない、統合されたFiveMリソース開発を実現*

[🇺🇸 English Version](README.md)

</div>

---

## ✨ 特徴

<table>
<tr>
<td width="50%">

### 🎯 マルチフレームワーク対応
- QB-Core
- ESX (es_extended)
- QBox
- Standalone

</td>
<td width="50%">

### 📦 インベントリシステム
- ox_inventory
- qb-inventory
- qs-inventory

</td>
</tr>
<tr>
<td>

### 🔔 通知システム
- ox_lib
- QB-Core
- ESX
- okokNotify
- ss_notify
- in_notify

</td>
<td>

### 🎯 ターゲットシステム
- ox_target
- qb-target
- qtarget

</td>
</tr>
<tr>
<td>

### ⏳ プログレスバー
- ox_lib
- progressbar
- QB-Core
- esx_progressbar

</td>
<td>

### 📝 Input/Menu
- ox_lib
- qb-input
- qb-menu
- nh-context

</td>
</tr>
<tr>
<td>

### ⛽ 燃料システム
- LegacyFuel
- ox_fuel
- ps-fuel
- cdn-fuel
- qs-fuelstations

</td>
<td>

### 🔑 車両キー
- qb-vehiclekeys
- qs-vehiclekeys
- cd_garage
- wasabi_carlock

</td>
</tr>
</table>

---

## 📊 統計

| 項目 | 数値 |
|------|------|
| 📁 総ファイル数 | 27+ |
| 🔧 エクスポート関数 | 80+ |
| 🔌 対応システム | 30+ |
| 🌐 対応言語 | 日本語・英語 |

---

## 🚀 インストール

### 1. ダウンロード

```bash
cd resources
git clone https://github.com/ImmersionNexus/in_bridge.git in_bridge
```

### 2. server.cfg に追加

```cfg
# 他のリソースより先に起動
ensure in_bridge
```

### 3. 設定 (オプション)

`shared/config.lua` を編集:

```lua
Config.Lang = 'ja'  -- 'ja' または 'en'

Config.DefaultSettings = {
    notify = "ox",    -- 使用する通知システム
    textui = "jg",    -- 使用するTextUIシステム
}
```

---

## 📖 使用方法

### 基本

```lua
local Bridge = exports['in_bridge']:GetBridge()

-- フレームワークの準備を待つ
Bridge.WaitForReady()

-- フレームワーク検出
if Bridge.FrameworkName == 'qbcore' then
    print('QB-Core が検出されました')
end
```

---

## 🖥️ Server Side API

<details>
<summary><b>👤 プレイヤー管理</b></summary>

```lua
-- プレイヤーデータ取得
local Player = Bridge.GetPlayer(source)

-- プレイヤー名取得
local name = Bridge.GetPlayerName(source)

-- 識別子取得
local identifier = Bridge.GetIdentifier(source)

-- ジョブ取得
local job, grade = Bridge.GetJob(source)

-- ジョブチェック
if Bridge.HasJob(source, 'police', 2) then
    print('警察官 グレード2以上')
end

-- 複数ジョブチェック
if Bridge.HasJob(source, {'police', 'sheriff'}, 0) then
    print('法執行機関')
end

-- ギャング取得 (QB-Core)
local gang, gangGrade = Bridge.GetGang(source)

-- 全プレイヤー取得
local players = Bridge.GetPlayers()
```

</details>

<details>
<summary><b>💰 お金管理</b></summary>

```lua
-- 所持金取得
local cash = Bridge.GetMoney(source, 'cash')
local bank = Bridge.GetMoney(source, 'bank')

-- お金を追加
Bridge.AddMoney(source, 1000, 'cash', '給料')

-- お金を削除
Bridge.RemoveMoney(source, 500, 'bank', '購入')

-- 銀行操作
local bankMoney = Bridge.GetBankMoney(source)
Bridge.AddBankMoney(source, 5000, '入金')
Bridge.RemoveBankMoney(source, 2000, '出金')

-- 送金
Bridge.TransferMoney(source, targetSource, 1000, '送金')

-- オフライン入金
Bridge.AddMoneyOffline(identifier, 1000, 'bank')
```

</details>

<details>
<summary><b>📦 インベントリ</b></summary>

```lua
-- アイテム追加
Bridge.AddItem(source, 'water', 5)

-- メタデータ付きアイテム追加
Bridge.AddItem(source, 'weapon_pistol', 1, nil, {
    serial = 'ABC123',
    durability = 100
})

-- アイテム削除
Bridge.RemoveItem(source, 'bread', 2)

-- アイテム所持チェック
if Bridge.HasItem(source, 'lockpick', 1) then
    print('ロックピックを持っています')
end

-- アイテム情報取得
local item = Bridge.GetItem(source, 'phone')
```

</details>

<details>
<summary><b>📦 スタッシュ/ストレージ</b></summary>

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

-- スタッシュの中身取得
local items = Bridge.GetStashItems('police_evidence')

-- スタッシュクリア
Bridge.ClearStash('police_evidence')
```

</details>

<details>
<summary><b>🏢 ソサエティ/ギャング資金</b></summary>

```lua
-- ソサエティの資金取得
Bridge.GetSocietyMoney('police', function(money)
    print('警察の資金: $' .. money)
end)

-- 資金追加/削除
Bridge.AddSocietyMoney('police', 10000)
Bridge.RemoveSocietyMoney('police', 5000)

-- ギャング資金 (QB-Core専用)
local gangMoney = Bridge.GetGangMoney('ballas')
Bridge.AddGangMoney('ballas', 5000)
Bridge.RemoveGangMoney('ballas', 2000)
```

</details>

<details>
<summary><b>🔑 車両キー</b></summary>

```lua
-- キー付与
Bridge.GiveVehicleKeys(source, plate)

-- キー削除
Bridge.RemoveVehicleKeys(source, plate)

-- キー所持チェック
local hasKeys = Bridge.HasVehicleKeys(source, plate)
```

</details>

<details>
<summary><b>📝 ログ & Discord</b></summary>

```lua
-- 基本ログ
Bridge.Log(source, 'item_purchase', 'プレイヤーがアイテムを購入しました')

-- Discord Webhook (シンプル)
Bridge.SendWebhook(
    'WEBHOOK_URL',
    'アイテム購入',
    'プレイヤーがアイテムを購入しました',
    0x00FF00  -- 緑色
)

-- Discord Embed (詳細)
Bridge.SendDiscordLog(
    'WEBHOOK_URL',
    'Server Logger',
    'プレイヤーアクション',
    {
        {name = 'プレイヤー', value = 'John Doe', inline = true},
        {name = 'アクション', value = '購入', inline = true},
        {name = '金額', value = '$1000', inline = true}
    },
    0x3498DB  -- 青色
)

-- プレイヤーアクションログ
Bridge.LogPlayerAction(source, 'WEBHOOK_URL', '車両購入', {
    {name = '車両', value = 'Adder', inline = true},
    {name = '価格', value = '$50000', inline = true}
}, 0x00FF00)
```

</details>

<details>
<summary><b>🔄 Callback システム</b></summary>

```lua
-- Callback登録
Bridge.RegisterCallback('myresource:getData', function(source, cb, arg1, arg2)
    local data = {
        result = arg1 + arg2
    }
    cb(data)
end)

-- クライアントコールバック呼び出し
Bridge.TriggerClientCallback(source, 'myresource:clientData', function(result)
    print('クライアントからの結果:', result)
end, 'arg1', 'arg2')
```

</details>

---

## 🎮 Client Side API

<details>
<summary><b>🔔 通知</b></summary>

```lua
Bridge.Notify('タイトル', 'メッセージ', 'success', 5000)
-- type: 'success', 'error', 'info', 'warning'
```

</details>

<details>
<summary><b>📺 TextUI</b></summary>

```lua
-- 表示
Bridge.ShowTextUI('[E] ドアを開ける', 'right')

-- 非表示
Bridge.HideTextUI()
```

</details>

<details>
<summary><b>⏳ プログレスバー</b></summary>

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

-- キャンセル
Bridge.CancelProgress()

-- 実行中チェック
if Bridge.IsProgressActive() then
    print('プログレス実行中')
end
```

</details>

<details>
<summary><b>📝 Input/Menu</b></summary>

```lua
-- Input Dialog
local input = Bridge.ShowInput({
    header = 'プレイヤー情報',
    inputs = {
        {name = 'name', label = '名前', type = 'text', required = true},
        {name = 'age', label = '年齢', type = 'number', required = true}
    }
})

if input then
    print('名前:', input.name)
    print('年齢:', input.age)
end

-- Context Menu
Bridge.ShowMenu({
    id = 'my_menu',
    title = 'メニュー',
    options = {
        {
            title = 'オプション1',
            description = '説明文',
            icon = 'fas fa-star',
            onSelect = function()
                print('選択されました')
            end
        }
    }
})

-- メニューを閉じる
Bridge.CloseMenu()

-- 確認ダイアログ
local confirmed = Bridge.ShowConfirm({
    header = '確認',
    message = '本当に削除しますか？'
})

-- スキルチェック
local success = Bridge.ShowSkillCheck('medium')
```

</details>

<details>
<summary><b>🎯 ターゲットシステム</b></summary>

```lua
-- エンティティターゲット
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

-- モデルターゲット
Bridge.AddTargetModel({'prop_atm_01', 'prop_atm_02'}, {
    {
        name = 'use_atm',
        label = 'ATMを使う',
        icon = 'fas fa-credit-card',
        onSelect = function()
            -- ATM処理
        end
    }
})

-- ボックスゾーン
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

-- ゾーン削除
Bridge.RemoveZone(zoneId)

-- グローバルプレイヤー/車両ターゲット
Bridge.AddGlobalPlayer(options)
Bridge.AddGlobalVehicle(options)
```

</details>

<details>
<summary><b>🚗 車両</b></summary>

```lua
-- 車両スポーン
Bridge.SpawnVehicle('adder', vector3(0, 0, 0), 0.0, function(vehicle)
    print('車両がスポーンしました:', vehicle)
end)

-- 車両削除
Bridge.DeleteVehicle(vehicle)

-- プレイヤーの車両取得
local vehicle = Bridge.GetPlayerVehicle()

-- 最も近い車両
local vehicle, distance = Bridge.GetClosestVehicle(coords, 5.0)

-- 燃料
local fuel = Bridge.GetVehicleFuel(vehicle)
Bridge.SetVehicleFuel(vehicle, 100.0)

-- キー所持チェック
if Bridge.HasVehicleKeys(plate) then
    print('キーを持っています')
end
```

</details>

<details>
<summary><b>🎨 描画 & UI</b></summary>

```lua
-- 3Dテキスト
Bridge.DrawText3D(coords, 'テキスト')

-- マーカー
Bridge.DrawMarker(1, coords, vector3(1.0, 1.0, 1.0), {r=255, g=0, b=0, a=100})

-- ヘルプテキスト
Bridge.ShowHelpText('[E] インタラクト')
```

</details>

<details>
<summary><b>🔄 Callback (Client)</b></summary>

```lua
-- サーバーコールバック呼び出し
Bridge.TriggerCallback('myresource:getData', function(data)
    print('結果:', data.result)
end, arg1, arg2)

-- クライアントコールバック登録
Bridge.RegisterClientCallback('myresource:clientCheck', function(cb, data)
    cb(true)
end)
```

</details>

---

## 🔧 Shared API (Utils)

<details>
<summary><b>📐 距離 & 座標</b></summary>

```lua
local distance = Bridge.GetDistance(coords1, coords2)
local isNearby = Bridge.IsPlayerNearby(coords, 5.0)
```

</details>

<details>
<summary><b>📋 テーブル操作</b></summary>

```lua
local isEmpty = Bridge.IsTableEmpty(tbl)
local copy = Bridge.DeepCopy(tbl)
local contains = Bridge.TableContains(tbl, value)
local keys = Bridge.GetTableKeys(tbl)
```

</details>

<details>
<summary><b>📝 文字列操作</b></summary>

```lua
local parts = Bridge.SplitString("hello,world", ",")
local trimmed = Bridge.Trim("  text  ")
local capitalized = Bridge.Capitalize("hello")
```

</details>

<details>
<summary><b>🔢 数値操作</b></summary>

```lua
local clamped = Bridge.Clamp(value, 0, 100)
local rounded = Bridge.Round(3.14159, 2)
local random = Bridge.Random(1, 100)
```

</details>

<details>
<summary><b>⏰ 時間操作</b></summary>

```lua
local hours, minutes, seconds = Bridge.MsToTime(360000)
local formatted = Bridge.FormatTime(hours, minutes, seconds)
```

</details>

<details>
<summary><b>🧮 数学関数</b></summary>

```lua
local lerped = Bridge.Lerp(0, 100, 0.5)  -- 50
local angle = Bridge.GetAngleBetweenPoints(x1, y1, x2, y2)
```

</details>

<details>
<summary><b>⚠️ エラーハンドリング</b></summary>

```lua
Bridge.Try(function()
    -- 実行したいコード
    error("テストエラー")
end).catch(function(err)
    print("エラー:", err)
end).finally(function()
    print("最終処理")
end)

-- シンプル版
local success, result = Bridge.SafeCall(function()
    return "OK"
end)
```

</details>

<details>
<summary><b>🌐 多言語対応</b></summary>

```lua
-- ローカライズテキスト取得
local text = Bridge.L('not_enough_money')
local formatted = Bridge.L('money_added', 1000)

-- 言語変更
Bridge.SetLang('ja')

-- 利用可能な言語
local langs = Bridge.GetAvailableLanguages()

-- カスタムロケール追加
Bridge.AddLocale('ja', 'custom_key', 'カスタムテキスト')
Bridge.AddLocales('ja', {
    key1 = 'テキスト1',
    key2 = 'テキスト2'
})
```

</details>

---

## 📁 ファイル構造

```
in_bridge/
├── 📄 fxmanifest.lua
├── 📖 README.md
├── 📖 README_JP.md
├── 📖 INSTALL.md
├── 📖 FEATURES.md
├── 💻 EXAMPLES.lua
│
├── 📂 shared/
│   ├── config.lua          # 設定
│   ├── locales.lua         # 多言語対応
│   ├── main.lua            # 初期化
│   └── utils.lua           # ユーティリティ
│
├── 📂 server/
│   ├── main.lua
│   └── modules/
│       ├── callback.lua        # コールバック
│       ├── player.lua          # プレイヤー管理
│       ├── money.lua           # お金管理
│       ├── inventory.lua       # インベントリ
│       ├── logger.lua          # ログ & Discord
│       ├── stash.lua           # ストレージ
│       ├── society.lua         # ソサエティ資金
│       └── vehicle_extras.lua  # 車両キー
│
└── 📂 client/
    ├── main.lua
    └── modules/
        ├── callback.lua        # コールバック
        ├── notify.lua          # 通知
        ├── vehicles.lua        # 車両
        ├── draw.lua            # 描画 & UI
        ├── utils.lua           # ユーティリティ
        ├── target.lua          # ターゲット
        ├── progressbar.lua     # プログレスバー
        ├── input.lua           # Input & Menu
        ├── stash.lua           # ストレージ
        └── vehicle_extras.lua  # 燃料 & キー
```

---

## ⚙️ 依存関係

### 必須
なし (スタンドアロンで動作)

### 推奨
| リソース | 用途 |
|----------|------|
| `ox_lib` | Menu, Input, Progress, Target等 |
| `oxmysql` | データベース操作 |

### オプション
- フレームワーク (qb-core, es_extended, qbox)
- インベントリシステム
- 通知システム
- ターゲットシステム
- その他連携リソース

---

## ❓ FAQ

<details>
<summary><b>Q: QB-CoreとESXを同時に使えますか？</b></summary>

A: いいえ、1つのフレームワークのみ使用してください。

</details>

<details>
<summary><b>Q: スタンドアロンで使えますか？</b></summary>

A: はい、フレームワークなしでも基本機能は動作します。

</details>

<details>
<summary><b>Q: QBoxに対応していますか？</b></summary>

A: はい、QBoxはQB-Coreベースなので完全に対応しています。

</details>

<details>
<summary><b>Q: カスタムフレームワークで使えますか？</b></summary>

A: `modules/` 内のファイルを編集してカスタマイズできます。

</details>

<details>
<summary><b>Q: 新しい通知システムを追加するには？</b></summary>

A: `client/modules/notify.lua` を編集して、新しいシステムの条件分岐を追加してください。

</details>

---

## 🤝 コントリビューション

プルリクエストを歓迎します！

1. このリポジトリをフォーク
2. 機能ブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'Add amazing feature'`)
4. ブランチをプッシュ (`git push origin feature/amazing-feature`)
5. プルリクエストを作成

---

## 📄 ライセンス

MIT License - 詳細は [LICENSE](LICENSE) を参照

---

## 🔄 更新履歴

### v2.0.0 (最新)
- ✨ Callback システム追加
- ✨ Target システム統合
- ✨ Progress Bar 統合
- ✨ Input/Menu システム統合
- ✨ Stash/Storage システム追加
- ✨ Society/Gang 資金管理追加
- ✨ Vehicle Keys システム統合
- ✨ Fuel システム統合
- ✨ 多言語対応 (日本語/英語)
- ✨ エラーハンドリング (Try-Catch)
- 🎨 ドキュメント全面改訂

### v1.0.0
- 🎉 初回リリース
- ✅ QB-Core, ESX, QBox対応
- ✅ 基本機能実装

---

## 💬 サポート

- 🐛 バグ報告: [GitHub Issues](https://github.com/ImmersionNexus/in_bridge/issues)
- 💡 機能リクエスト: [GitHub Issues](https://github.com/ImmersionNexus/in_bridge/issues)
- 💬 Discord: [Join our server](https://discord.gg/yourdiscord)

---

<div align="center">

**Made with ❤️ by [ImmersionNexus](https://github.com/ImmersionNexus)**

⭐ このプロジェクトが役に立ったら、スターをお願いします！

</div>
