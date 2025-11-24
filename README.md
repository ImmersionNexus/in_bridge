<div align="center">

# 🌉 in_bridge

### FiveM Universal Bridge System

[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](https://github.com/ImmersionNexus/in_bridge/releases)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![FiveM](https://img.shields.io/badge/FiveM-Ready-orange.svg)](https://fivem.net/)
[![Lua](https://img.shields.io/badge/Lua-5.4-purple.svg)](https://www.lua.org/)

**QB-Core • ESX • QBox • Standalone**

[📖 Documentation](#-usage) • [🚀 Installation](#-installation) • [🐛 Issues](https://github.com/ImmersionNexus/in_bridge/issues)

---

_Build framework-independent FiveM resources with ease_

[🇯🇵 日本語版はこちら](README_JP.md)

</div>

---

## ✨ Features

<table>
<tr>
<td width="50%">

### 🎯 Multi-Framework Support

- QB-Core
- ESX (es_extended)
- QBox
- Standalone

</td>
<td width="50%">

### 📦 Inventory Systems

- ox_inventory
- qb-inventory
- qs-inventory

</td>
</tr>
<tr>
<td>

### 🔔 Notification Systems

- ox_lib
- QB-Core
- ESX
- okokNotify
- ss_notify
- in_notify

</td>
<td>

### 🎯 Target Systems

- ox_target
- qb-target
- qtarget

</td>
</tr>
<tr>
<td>

### ⏳ Progress Bars

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

### ⛽ Fuel Systems

- LegacyFuel
- ox_fuel
- ps-fuel
- cdn-fuel
- qs-fuelstations

</td>
<td>

### 🔑 Vehicle Keys

- qb-vehiclekeys
- qs-vehiclekeys
- cd_garage
- wasabi_carlock

</td>
</tr>
</table>

---

## 📊 Statistics

| Item                 | Count             |
| -------------------- | ----------------- |
| 📁 Total Files       | 27+               |
| 🔧 Export Functions  | 80+               |
| 🔌 Supported Systems | 30+               |
| 🌐 Languages         | English, Japanese |

---

## 🚀 Installation

### 1. Download

```bash
cd resources
git clone https://github.com/ImmersionNexus/in_bridge.git in_bridge
```

### 2. Add to server.cfg

```cfg
# Start before other resources
ensure in_bridge
```

### 3. Configuration (Optional)

Edit `shared/config.lua`:

```lua
Config.Lang = 'en'  -- 'en' or 'ja'

Config.DefaultSettings = {
    notify = "ox",    -- Notification system to use
    textui = "jg",    -- TextUI system to use
}
```

---

## 📖 Usage

### Basic

```lua
local Bridge = exports['in_bridge']:GetBridge()

-- Wait for framework to be ready
Bridge.WaitForReady()

-- Framework detection
if Bridge.FrameworkName == 'qbcore' then
    print('QB-Core detected')
end
```

---

## 🖥️ Server Side API

<details>
<summary><b>👤 Player Management</b></summary>

```lua
-- Get player data
local Player = Bridge.GetPlayer(source)

-- Get player name
local name = Bridge.GetPlayerName(source)

-- Get identifier
local identifier = Bridge.GetIdentifier(source)

-- Get job
local job, grade = Bridge.GetJob(source)

-- Check job
if Bridge.HasJob(source, 'police', 2) then
    print('Police officer grade 2 or higher')
end

-- Check multiple jobs
if Bridge.HasJob(source, {'police', 'sheriff'}, 0) then
    print('Law enforcement')
end

-- Get gang (QB-Core)
local gang, gangGrade = Bridge.GetGang(source)

-- Get all players
local players = Bridge.GetPlayers()
```

</details>

<details>
<summary><b>💰 Money Management</b></summary>

```lua
-- Get money
local cash = Bridge.GetMoney(source, 'cash')
local bank = Bridge.GetMoney(source, 'bank')

-- Add money
Bridge.AddMoney(source, 1000, 'cash', 'Salary')

-- Remove money
Bridge.RemoveMoney(source, 500, 'bank', 'Purchase')

-- Bank operations
local bankMoney = Bridge.GetBankMoney(source)
Bridge.AddBankMoney(source, 5000, 'Deposit')
Bridge.RemoveBankMoney(source, 2000, 'Withdrawal')

-- Transfer money
Bridge.TransferMoney(source, targetSource, 1000, 'Transfer')

-- Offline deposit
Bridge.AddMoneyOffline(identifier, 1000, 'bank')
```

</details>

<details>
<summary><b>📦 Inventory</b></summary>

```lua
-- Add item
Bridge.AddItem(source, 'water', 5)

-- Add item with metadata
Bridge.AddItem(source, 'weapon_pistol', 1, nil, {
    serial = 'ABC123',
    durability = 100
})

-- Remove item
Bridge.RemoveItem(source, 'bread', 2)

-- Check if has item
if Bridge.HasItem(source, 'lockpick', 1) then
    print('Has lockpick')
end

-- Get item info
local item = Bridge.GetItem(source, 'phone')
```

</details>

<details>
<summary><b>📦 Stash/Storage</b></summary>

```lua
-- Register stash
Bridge.RegisterStash('police_evidence', {
    label = 'Evidence Locker',
    slots = 50,
    weight = 100000,
    owner = false
})

-- Open stash
Bridge.OpenStash(source, 'police_evidence')

-- Trunk/Glovebox
Bridge.OpenTrunk(source, plate)
Bridge.OpenGlovebox(source, plate)

-- Get stash items
local items = Bridge.GetStashItems('police_evidence')

-- Clear stash
Bridge.ClearStash('police_evidence')
```

</details>

<details>
<summary><b>🏢 Society/Gang Money</b></summary>

```lua
-- Get society money
Bridge.GetSocietyMoney('police', function(money)
    print('Police funds: $' .. money)
end)

-- Add/Remove funds
Bridge.AddSocietyMoney('police', 10000)
Bridge.RemoveSocietyMoney('police', 5000)

-- Gang money (QB-Core only)
local gangMoney = Bridge.GetGangMoney('ballas')
Bridge.AddGangMoney('ballas', 5000)
Bridge.RemoveGangMoney('ballas', 2000)
```

</details>

<details>
<summary><b>🔑 Vehicle Keys</b></summary>

```lua
-- Give keys
Bridge.GiveVehicleKeys(source, plate)

-- Remove keys
Bridge.RemoveVehicleKeys(source, plate)

-- Check keys
local hasKeys = Bridge.HasVehicleKeys(source, plate)
```

</details>

<details>
<summary><b>📝 Logging & Discord</b></summary>

```lua
-- Basic log
Bridge.Log(source, 'item_purchase', 'Player purchased an item')

-- Discord Webhook (Simple)
Bridge.SendWebhook(
    'WEBHOOK_URL',
    'Item Purchase',
    'Player purchased an item',
    0x00FF00  -- Green
)

-- Discord Embed (Detailed)
Bridge.SendDiscordLog(
    'WEBHOOK_URL',
    'Server Logger',
    'Player Action',
    {
        {name = 'Player', value = 'John Doe', inline = true},
        {name = 'Action', value = 'Purchase', inline = true},
        {name = 'Amount', value = '$1000', inline = true}
    },
    0x3498DB  -- Blue
)

-- Player action log
Bridge.LogPlayerAction(source, 'WEBHOOK_URL', 'Vehicle Purchase', {
    {name = 'Vehicle', value = 'Adder', inline = true},
    {name = 'Price', value = '$50000', inline = true}
}, 0x00FF00)
```

</details>

<details>
<summary><b>🔄 Callback System</b></summary>

```lua
-- Register callback
Bridge.RegisterCallback('myresource:getData', function(source, cb, arg1, arg2)
    local data = {
        result = arg1 + arg2
    }
    cb(data)
end)

-- Trigger client callback
Bridge.TriggerClientCallback(source, 'myresource:clientData', function(result)
    print('Result from client:', result)
end, 'arg1', 'arg2')
```

</details>

---

## 🎮 Client Side API

<details>
<summary><b>🔔 Notifications</b></summary>

```lua
Bridge.Notify('Title', 'Message', 'success', 5000)
-- type: 'success', 'error', 'info', 'warning'
```

</details>

<details>
<summary><b>📺 TextUI</b></summary>

```lua
-- Show
Bridge.ShowTextUI('[E] Open Door', 'right')

-- Hide
Bridge.HideTextUI()
```

</details>

<details>
<summary><b>⏳ Progress Bar</b></summary>

```lua
local success = Bridge.ShowProgress({
    duration = 5000,
    label = 'Repairing...',
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
    print('Repair complete')
else
    print('Repair cancelled')
end

-- Cancel
Bridge.CancelProgress()

-- Check if active
if Bridge.IsProgressActive() then
    print('Progress is active')
end
```

</details>

<details>
<summary><b>📝 Input/Menu</b></summary>

```lua
-- Input Dialog
local input = Bridge.ShowInput({
    header = 'Player Info',
    inputs = {
        {name = 'name', label = 'Name', type = 'text', required = true},
        {name = 'age', label = 'Age', type = 'number', required = true}
    }
})

if input then
    print('Name:', input.name)
    print('Age:', input.age)
end

-- Context Menu
Bridge.ShowMenu({
    id = 'my_menu',
    title = 'Menu',
    options = {
        {
            title = 'Option 1',
            description = 'Description',
            icon = 'fas fa-star',
            onSelect = function()
                print('Selected')
            end
        }
    }
})

-- Close menu
Bridge.CloseMenu()

-- Confirm dialog
local confirmed = Bridge.ShowConfirm({
    header = 'Confirm',
    message = 'Are you sure you want to delete?'
})

-- Skill check
local success = Bridge.ShowSkillCheck('medium')
```

</details>

<details>
<summary><b>🎯 Target System</b></summary>

```lua
-- Entity target
Bridge.AddTargetEntity(entity, {
    {
        name = 'interact',
        label = 'Talk',
        icon = 'fas fa-comments',
        onSelect = function(data)
            print('Talking')
        end
    }
})

-- Model target
Bridge.AddTargetModel({'prop_atm_01', 'prop_atm_02'}, {
    {
        name = 'use_atm',
        label = 'Use ATM',
        icon = 'fas fa-credit-card',
        onSelect = function()
            -- ATM logic
        end
    }
})

-- Box zone
local zoneId = Bridge.AddBoxZone({
    name = 'shop_zone',
    coords = vector3(0.0, 0.0, 0.0),
    size = vector3(2.0, 2.0, 2.0),
    rotation = 0.0,
    debug = false,
    options = {
        {
            name = 'open_shop',
            label = 'Open Shop',
            icon = 'fas fa-shopping-cart',
            onSelect = function()
                print('Shop opened')
            end
        }
    }
})

-- Remove zone
Bridge.RemoveZone(zoneId)

-- Global player/vehicle targets
Bridge.AddGlobalPlayer(options)
Bridge.AddGlobalVehicle(options)
```

</details>

<details>
<summary><b>🚗 Vehicles</b></summary>

```lua
-- Spawn vehicle
Bridge.SpawnVehicle('adder', vector3(0, 0, 0), 0.0, function(vehicle)
    print('Vehicle spawned:', vehicle)
end)

-- Delete vehicle
Bridge.DeleteVehicle(vehicle)

-- Get player vehicle
local vehicle = Bridge.GetPlayerVehicle()

-- Get closest vehicle
local vehicle, distance = Bridge.GetClosestVehicle(coords, 5.0)

-- Fuel
local fuel = Bridge.GetVehicleFuel(vehicle)
Bridge.SetVehicleFuel(vehicle, 100.0)

-- Check keys
if Bridge.HasVehicleKeys(plate) then
    print('Has keys')
end
```

</details>

<details>
<summary><b>🎨 Drawing & UI</b></summary>

```lua
-- 3D Text
Bridge.DrawText3D(coords, 'Text')

-- Marker
Bridge.DrawMarker(1, coords, vector3(1.0, 1.0, 1.0), {r=255, g=0, b=0, a=100})

-- Help text
Bridge.ShowHelpText('[E] Interact')
```

</details>

<details>
<summary><b>🔄 Callback (Client)</b></summary>

```lua
-- Trigger server callback
Bridge.TriggerCallback('myresource:getData', function(data)
    print('Result:', data.result)
end, arg1, arg2)

-- Register client callback
Bridge.RegisterClientCallback('myresource:clientCheck', function(cb, data)
    cb(true)
end)
```

</details>

---

## 🔧 Shared API (Utils)

<details>
<summary><b>📐 Distance & Coordinates</b></summary>

```lua
local distance = Bridge.GetDistance(coords1, coords2)
local isNearby = Bridge.IsPlayerNearby(coords, 5.0)
```

</details>

<details>
<summary><b>📋 Table Operations</b></summary>

```lua
local isEmpty = Bridge.IsTableEmpty(tbl)
local copy = Bridge.DeepCopy(tbl)
local contains = Bridge.TableContains(tbl, value)
local keys = Bridge.GetTableKeys(tbl)
```

</details>

<details>
<summary><b>📝 String Operations</b></summary>

```lua
local parts = Bridge.SplitString("hello,world", ",")
local trimmed = Bridge.Trim("  text  ")
local capitalized = Bridge.Capitalize("hello")
```

</details>

<details>
<summary><b>🔢 Number Operations</b></summary>

```lua
local clamped = Bridge.Clamp(value, 0, 100)
local rounded = Bridge.Round(3.14159, 2)
local random = Bridge.Random(1, 100)
```

</details>

<details>
<summary><b>⏰ Time Operations</b></summary>

```lua
local hours, minutes, seconds = Bridge.MsToTime(360000)
local formatted = Bridge.FormatTime(hours, minutes, seconds)
```

</details>

<details>
<summary><b>🧮 Math Functions</b></summary>

```lua
local lerped = Bridge.Lerp(0, 100, 0.5)  -- 50
local angle = Bridge.GetAngleBetweenPoints(x1, y1, x2, y2)
```

</details>

<details>
<summary><b>⚠️ Error Handling</b></summary>

```lua
Bridge.Try(function()
    -- Code to execute
    error("Test error")
end).catch(function(err)
    print("Error:", err)
end).finally(function()
    print("Cleanup")
end)

-- Simple version
local success, result = Bridge.SafeCall(function()
    return "OK"
end)
```

</details>

<details>
<summary><b>🌐 Localization</b></summary>

```lua
-- Get localized text
local text = Bridge.L('not_enough_money')
local formatted = Bridge.L('money_added', 1000)

-- Change language
Bridge.SetLang('en')

-- Get available languages
local langs = Bridge.GetAvailableLanguages()

-- Add custom locale
Bridge.AddLocale('en', 'custom_key', 'Custom text')
Bridge.AddLocales('en', {
    key1 = 'Text 1',
    key2 = 'Text 2'
})
```

</details>

---

## 📁 File Structure

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
│   ├── config.lua          # Configuration
│   ├── locales.lua         # Localization
│   ├── main.lua            # Initialization
│   └── utils.lua           # Utilities
│
├── 📂 server/
│   ├── main.lua
│   └── modules/
│       ├── callback.lua        # Callbacks
│       ├── player.lua          # Player management
│       ├── money.lua           # Money management
│       ├── inventory.lua       # Inventory
│       ├── logger.lua          # Logging & Discord
│       ├── stash.lua           # Storage
│       ├── society.lua         # Society funds
│       └── vehicle_extras.lua  # Vehicle keys
│
└── 📂 client/
    ├── main.lua
    └── modules/
        ├── callback.lua        # Callbacks
        ├── notify.lua          # Notifications
        ├── vehicles.lua        # Vehicles
        ├── draw.lua            # Drawing & UI
        ├── utils.lua           # Utilities
        ├── target.lua          # Target system
        ├── progressbar.lua     # Progress bar
        ├── input.lua           # Input & Menu
        ├── stash.lua           # Storage
        └── vehicle_extras.lua  # Fuel & Keys
```

---

## ⚙️ Dependencies

### Required

None (Works standalone)

### Recommended

| Resource  | Purpose                             |
| --------- | ----------------------------------- |
| `ox_lib`  | Menu, Input, Progress, Target, etc. |
| `oxmysql` | Database operations                 |

### Optional

- Framework (qb-core, es_extended, qbox)
- Inventory system
- Notification system
- Target system
- Other integrated resources

---

## ❓ FAQ

<details>
<summary><b>Q: Can I use QB-Core and ESX at the same time?</b></summary>

A: No, please use only one framework.

</details>

<details>
<summary><b>Q: Can I use it standalone?</b></summary>

A: Yes, basic functions work without any framework.

</details>

<details>
<summary><b>Q: Is QBox supported?</b></summary>

A: Yes, QBox is fully supported as it's based on QB-Core.

</details>

<details>
<summary><b>Q: Can I use it with a custom framework?</b></summary>

A: Yes, you can customize the files in the `modules/` folder.

</details>

<details>
<summary><b>Q: How do I add a new notification system?</b></summary>

A: Edit `client/modules/notify.lua` and add a new condition branch for your system.

</details>

---

## 🤝 Contributing

Pull requests are welcome!

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

MIT License - See [LICENSE](LICENSE) for details

---

## 🔄 Changelog

### v2.0.0 (Latest)

- ✨ Added Callback system
- ✨ Integrated Target system
- ✨ Integrated Progress Bar
- ✨ Integrated Input/Menu system
- ✨ Added Stash/Storage system
- ✨ Added Society/Gang money management
- ✨ Integrated Vehicle Keys system
- ✨ Integrated Fuel system
- ✨ Added localization (English/Japanese)
- ✨ Added error handling (Try-Catch)
- 🎨 Complete documentation overhaul

### v1.0.0

- 🎉 Initial release
- ✅ QB-Core, ESX, QBox support
- ✅ Basic features implemented

---

## 💬 Support

- 🐛 Bug Reports: [GitHub Issues](https://github.com/ImmersionNexus/in_bridge/issues)
- 💡 Feature Requests: [GitHub Issues](https://github.com/ImmersionNexus/in_bridge/issues)
- 💬 Discord: [Join our server](https://discord.gg/yourdiscord)

---

<div align="center">

**Made with ❤️ by [ImmersionNexus](https://github.com/ImmersionNexus)**

⭐ If this project helped you, please give it a star!

</div>
