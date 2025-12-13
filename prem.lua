-- =========================
-- 🔥 MANUAL SAVE CONFIG SYSTEM
-- =========================

local HttpService = game:GetService("HttpService")

-- ✅ CONFIG FOLDER & FILE PATH
local CONFIG_FOLDER = "VyperAutoFish"
local CONFIG_FILE = CONFIG_FOLDER .. "/config.json"

-- ✅ DEFAULT CONFIG
local Config = {
    FishingDelay = 0.7,
    CancelDelay = 1.5, 
    LegitTapSpeed = 0.05,
    TapRandomization = 0.02
}

-- ✅ GLOBAL VARIABLES
FishingDelay = Config.FishingDelay
CancelDelay = Config.CancelDelay
LegitTapSpeed = Config.LegitTapSpeed
TapRandomization = Config.TapRandomization

-- ✅ CEK/BIKIN FOLDER
local function EnsureFolderExists()
    if not isfolder(CONFIG_FOLDER) then
        print("📁 [SETUP] Creating config folder:", CONFIG_FOLDER)
        makefolder(CONFIG_FOLDER)
        print("✅ [SETUP] Folder created!")
    else
        print("📁 [SETUP] Folder already exists:", CONFIG_FOLDER)
    end
end

-- ✅ SAVE CONFIG KE FILE (MANUAL)
function SaveConfig()
    print("💾 [SAVE] Saving config...")
    
    local success, err = pcall(function()
        -- Pastikan folder ada
        EnsureFolderExists()
        
        -- Convert config ke JSON
        local jsonData = HttpService:JSONEncode(Config)
        
        print("📝 [DEBUG] JSON Data:", jsonData)
        print("📝 [DEBUG] File Path:", CONFIG_FILE)
        
        -- Tulis ke file
        writefile(CONFIG_FILE, jsonData)
    end)
    
    if success then
        print("✅ [SAVE] SUCCESS! Config saved to:", CONFIG_FILE)
        printConfigStatus()
    else
        warn("❌ [SAVE] FAILED! Error:", err)
    end
end

-- ✅ LOAD CONFIG DARI FILE
function LoadConfig()
    print("🔄 [LOAD] Loading config...")
    
    -- Pastikan folder ada
    EnsureFolderExists()
    
    -- Cek apakah file config ada
    if isfile(CONFIG_FILE) then
        print("📁 [LOAD] Config file found! Loading...")
        
        local success, result = pcall(function()
            -- Baca file
            local jsonData = readfile(CONFIG_FILE)
            print("📝 [DEBUG] Read JSON:", jsonData)
            
            -- Parse JSON ke table
            local loadedConfig = HttpService:JSONDecode(jsonData)
            
            -- Update config
            for key, value in pairs(loadedConfig) do
                Config[key] = value
            end
            
            -- Update global variables
            FishingDelay = Config.FishingDelay
            CancelDelay = Config.CancelDelay
            LegitTapSpeed = Config.LegitTapSpeed
            TapRandomization = Config.TapRandomization
        end)
        
        if success then
            print("✅ [LOAD] SUCCESS! Config loaded!")
        else
            warn("❌ [LOAD] FAILED! Error:", result)
            warn("⚠️ Using default config...")
        end
    else
        print("⚠️ [LOAD] No saved config found")
        print("💡 [TIP] Adjust settings then click 'Save Config' button")
    end
    
    printConfigStatus()
end

-- ✅ PRINT CONFIG STATUS
function printConfigStatus()
    print("=== CURRENT CONFIG ===")
    print("🎣 FishingDelay:", Config.FishingDelay)
    print("⚡ CancelDelay:", Config.CancelDelay)
    print("👆 LegitTapSpeed:", Config.LegitTapSpeed)
    print("🎲 TapRandomization:", Config.TapRandomization)
    print("======================")
end

-- ✅ LOAD CONFIG SAAT SCRIPT START
LoadConfig()

-- ========================================
-- Disini
-- ========================================
print("🚀 Loading King Vyper UI...")

local VyperUI = loadstring(game:HttpGet("https://gitlab.com/blazars1/blazarsui/-/raw/main/VyperUI_V4_Finalnew5.lua"))()





-- SERVICES
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
local VirtualInputManager = game:GetService("VirtualInputManager")

-- REMOTE FUNCTIONS
   local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
    local REEquipToolFromHotbar = net["RE/EquipToolFromHotbar"]
    local RFChargeFishingRod = net["RF/ChargeFishingRod"]
    local RFRequestFishingMinigameStarted = net["RF/RequestFishingMinigameStarted"]
    local REUpdateChargeState = net["RE/UpdateChargeState"]
    local REFishCaught = net["RE/FishCaught"]
    local REFishingCompleted = net["RE/FishingCompleted"]
    local RFCancelFishingInputs = net["RF/CancelFishingInputs"]  -- atau nama yang mirip
    local RFUpdateAutoFishingState = net["RF/UpdateAutoFishingState"]

    local SellItemsRemote = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/SellAllItems"]


-- VARIABLES
local AutoFishEnabled = false
local FishingDelay = 0.7  -- Default delay
local LockPositionEnabled = false
local OriginalPosition = nil
local Player = Players.LocalPlayer
local AutoSellEnabled = false
local LegitFishEnabled = false
local LegitTapSpeed = 0.05
local TapRandomization = 0.02
-- === CONFIG ===
local WEBHOOK_ENABLED = true


-- Window
local Window = VyperUI:CreateWindow({
    Title = "King Vypers | PREMIUM",
    Subtitle = "Enjoyyy",
    Size = UDim2.new(0, 500, 0, 350)
})

do
    local oldDestroy = Window.Destroy
    Window.Destroy = function(...)
        WEBHOOK_ENABLED = false
        print("🛑 UI window closed → Webhook DISABLED")
        return oldDestroy(...)
    end
end




local HomeTab = Window:CreateTab({
    Title = "Fish",
    Icon = "🐟"
})

local ShopTab = Window:CreateTab({
    Title = "Shop",
    Icon = "🛒"
})

local WebhookTab = Window:CreateTab({
    Title = "Webhook",
    Icon = "🔔"
})

local TeleportTab = Window:CreateTab({
    Title = "Teleport",
    Icon = "⏩"
})

local QuestTab = Window:CreateTab({
    Title = "Quest",
    Icon = "📑"
})

local JungleTab = Window:CreateTab({
    Title = "Jungle Quest", 
    Icon = "🌴"
})

local AutoTab = Window:CreateTab({
    Title = "Auto",
    Icon = "🔥"
})

local PlayerTab = Window:CreateTab({
    Title = "Player",
    Icon = "☠️"
})


-- ========================================
-- Webhook with Discord Mention (DUAL WEBHOOK SUPPORT)
-- ========================================


local WEBHOOK_URL_1 = "https://discord.com/api/webhooks/1446671790704165004/VKT9twaiYRus_P_-XgVgQOoxnjZMwg32awpfWcERP7FUpZK3aX0BbjZPeuRLmdZepO9b"  -- Default webhook
local WEBHOOK_URL_2 = ""  -- User custom webhook (kosong by default)

-- Ambil event ikan
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Event = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/ObtainedNewFishNotification"]

-- Load module items dan variants dari ReplicatedStorage
local itemsModule = require(ReplicatedStorage:WaitForChild("Items"))
local variantsModule = require(ReplicatedStorage:WaitForChild("Variants"))

-- Get local player
local LocalPlayer = Players.LocalPlayer

-- === CUSTOM DISCORD CONFIG ===
local DiscordUserID = ""  -- Default kosong, user harus isi via UI
local CustomUsername = LocalPlayer.Name  -- Fallback display name

-- === DATA TIER ===
local TIER_NAMES = {
    [1] = "Common",
    [2] = "Uncommon", 
    [3] = "Rare",
    [4] = "Epic",
    [5] = "Legendary",
    [6] = "Mythic",
    [7] = "SECRET"
}

-- Fungsi untuk convert tier number ke nama
local function getTierName(tierNumber)
    return TIER_NAMES[tierNumber] or "Unknown"
end

-- Fungsi untuk cari ikan berdasarkan Item ID
local function getFishData(itemId)
    for _, fish in pairs(itemsModule) do
        if fish.Data and fish.Data.Id == itemId then
            return fish
        end
    end
    return nil
end

-- Fungsi untuk cari variant berdasarkan Variant ID
local function getVariantData(variantId)
    if not variantId then return nil end
    
    for _, variant in pairs(variantsModule) do
        if variant.Data and variant.Data.Id == variantId then
            return variant
        end
    end
    return nil
end

-- Fungsi kirim ke satu webhook
local function sendWebhookRequest(webhookUrl, jsonData, webhookName)
    if not WEBHOOK_ENABLED then return end
    local success, response = pcall(function()
        local request = (syn and syn.request) or 
                       (http and http.request) or 
                       (http_request) or 
                       (request)
        
        if not request then
            error("❌ HTTP request function not found!")
        end
        
        return request({
            Url = webhookUrl,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonData
        })
    end)
    
    if success then
        print("✅ " .. webhookName .. " sent successfully!")
        if response then
            print("📡 Response Status:", response.StatusCode or "N/A")
        end
    else
        warn("❌ Failed to send " .. webhookName .. "!")
        warn("Error:", tostring(response))
    end
end

-- Fungsi kirim embed ke Discord dengan mention (DUAL WEBHOOK)
local function sendToDiscord(fishName, weight, tierNumber, sellPrice, icon, variantData, displayName, userID)
    print("🚀 Preparing to send webhook...")
    print("Display Name:", displayName)
    print("Discord User ID:", userID)
    print("Fish Name:", fishName)
    print("Weight:", weight)
    print("Tier Number:", tierNumber)
    
    -- Convert tier number ke nama
    local tierName = getTierName(tierNumber)
    print("Tier Name:", tierName)
    print("Sell Price:", sellPrice)
    
    if variantData then
        print("Variant Name:", variantData.Data.Name)
        print("Variant Multiplier:", variantData.SellMultiplier)
    end
    
    -- Validasi icon URL
    local validIcon = (icon and icon ~= "" and string.match(icon, "^http")) and icon or "https://i.imgur.com/placeholder.png"
    
    -- Build fields
    local fields = {
        {["name"] = "Player", ["value"] = displayName, ["inline"] = true},
        {["name"] = "Fish Name", ["value"] = tostring(fishName), ["inline"] = true},
        {["name"] = "Weight", ["value"] = tostring(weight) .. " kg", ["inline"] = true},
        {["name"] = "Tier", ["value"] = tierName, ["inline"] = true}
    }
    
    -- Mutation field
    if variantData then
        table.insert(fields, {
            ["name"] = "Mutation", 
            ["value"] = "✨ " .. variantData.Data.Name .. " (" .. tostring(variantData.SellMultiplier) .. "x)", 
            ["inline"] = true
        })
    else
        table.insert(fields, {
            ["name"] = "Mutation", 
            ["value"] = "None", 
            ["inline"] = true
        })
    end
    
    -- Sell Price (dengan multiplier kalau ada variant)
    local finalSellPrice = variantData and (sellPrice * (variantData.SellMultiplier or 1)) or sellPrice
    table.insert(fields, {
        ["name"] = "Sell Price", 
        ["value"] = "$" .. tostring(math.floor(finalSellPrice)), 
        ["inline"] = true
    })
    
    -- Ubah color kalau variant
    local embedColor = variantData and 16776960 or 16711680  -- Gold kalau variant, merah untuk SECRET
    
    -- Build mention string
    local mentionText = ""
    if userID and userID ~= "" then
        mentionText = "<@" .. userID .. "> "  -- Format mention Discord: <@USER_ID>
    end
    
    local embed = {
        ["content"] = mentionText .. "🎣 **SECRET FISH CAUGHT!**",  -- Mention di content
        ["embeds"] = {{
            ["title"] = "🔥 SECRET FISH CAUGHT! 🔥",
            ["color"] = embedColor,
            ["fields"] = fields,
            ["thumbnail"] = {["url"] = validIcon},
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            ["footer"] = {
                ["text"] = "Caught by " .. displayName
            }
        }}
    }

    local jsonData = HttpService:JSONEncode(embed)

    -- Kirim ke Webhook 1 (Default)
    print("📤 Sending to Webhook 1 (Default)...")
    sendWebhookRequest(WEBHOOK_URL_1, jsonData, "Webhook 1 (Default)")
    
    -- Kirim ke Webhook 2 (Custom) kalau URL nya ada
    if WEBHOOK_URL_2 and WEBHOOK_URL_2 ~= "" and string.match(WEBHOOK_URL_2, "^https://discord.com/api/webhooks/") then
        print("📤 Sending to Webhook 2 (Custom)...")
        task.wait(0.5)  -- Delay kecil biar ga spam rate limit
        sendWebhookRequest(WEBHOOK_URL_2, jsonData, "Webhook 2 (Custom)")
    else
        print("⚠️ Webhook 2 is empty or invalid, skipping...")
    end
    
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
end

-- Listen event dan kirim ke Discord
Event.OnClientEvent:Connect(function(itemId, metadata, extraData, boolFlag)
    local fishData = getFishData(itemId)
    if not fishData then return end

    -- ✅ FILTER: SECRET ONLY
    if fishData.Data.Tier ~= 7 then
        return
    end

    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("🔥 SECRET FISH DETECTED!")
    print("Name:", fishData.Data.Name)
    print("Weight:", metadata.Weight)
    print("Tier:", getTierName(fishData.Data.Tier))

    -- Check variant / mutation
    local variantData = nil
    if metadata.Variant then
        variantData = getVariantData(metadata.Variant)
    end

    -- ✅ KIRIM DISCORD (SECRET SAJA)
    sendToDiscord(
        fishData.Data.Name,
        metadata.Weight,
        fishData.Data.Tier,
        fishData.SellPrice,
        fishData.Data.Icon,
        variantData,
        CustomUsername,
        DiscordUserID
    )
end)


print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("✅ Fish Logger Active! (SECRET ONLY MODE)")
print("🎣 Player:", LocalPlayer.Name)
print("🔥 Only SECRET tier fish will be sent to Discord!")
print("📡 Webhook 1 (Default): ACTIVE")
if WEBHOOK_URL_2 ~= "" then
    print("📡 Webhook 2 (Custom): ACTIVE")
else
    print("📡 Webhook 2 (Custom): NOT SET")
end
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

-- ========================================
-- UI INPUT UNTUK WEBHOOK URL, DISCORD USER ID & USERNAME
-- ========================================

-- Input Custom Webhook URL (Webhook 2)
VyperUI:CreateTextBox(WebhookTab, {
    Title = "Custom Webhook URL (Optional)",
    Subtitle = "Add your own Discord webhook",
    Placeholder = "https://discord.com/..",
    Default = "",
    Callback = function(value)
        if value and value ~= "" and value ~= " " then
            -- Validasi URL webhook Discord
            if string.match(value, "^https://discord.com/api/webhooks/%d+/[%w_%-]+$") then
                WEBHOOK_URL_2 = value
                print("✅ [CHANGE] Custom Webhook URL -> SET")
                print("📡 Webhook 2 will receive notifications!")
            else
                warn("⚠️ Invalid Discord Webhook URL!")
                warn("Format: https://discord.com/api/webhooks/ID/TOKEN")
            end
        else
            WEBHOOK_URL_2 = ""
            print("⚠️ [RESET] Custom Webhook URL -> Empty (Only default webhook)")
        end
    end
})

-- Input Discord User ID (untuk mention)
VyperUI:CreateTextBox(WebhookTab, {
    Title = "Discord User ID",
    Subtitle = "For mention in Discord",
    Placeholder = "your Discord User ID",
    Default = "",
    Callback = function(value)
        if value and value ~= "" and value ~= " " then
            -- Validasi hanya angka
            if tonumber(value) then
                DiscordUserID = value
                print("✅ [CHANGE] Discord User ID ->", value)
            else
                warn("⚠️ Invalid User ID! Must be numbers only")
            end
        else
            DiscordUserID = ""
            print("⚠️ [RESET] Discord User ID -> Empty (No mention)")
        end
    end
})

-- Input Display Username (opsional, untuk display di embed)
VyperUI:CreateTextBox(WebhookTab, {
    Title = "Display Username",
    Subtitle = "Custom display name",
    Placeholder = "Enter display name...",
    Default = LocalPlayer.Name,
    Callback = function(value)
        if value and value ~= "" and value ~= " " then
            CustomUsername = value
            print("✅ [CHANGE] Display Username ->", value)
        else
            CustomUsername = LocalPlayer.Name
            print("⚠️ [RESET] Display Username -> Default:", LocalPlayer.Name)
        end
    end
})

VyperUI:CreateTextParagraph(WebhookTab, {
    Title = "📖 How to Get Discord Webhook URL?",
    Lines = {
        "1. Go to Discord Server Settings",
        "2. Click 'Integrations' → 'Webhooks'",
        "3. Click 'New Webhook'",
        "4. Choose channel & copy webhook URL",
        "5. Paste it in the textbox above!",
        "",
        "🔥 TIP: You can use 2 webhooks!",
        "- Webhook 1: Default (hardcoded)",
        "- Webhook 2: Your custom webhook"
    }
})

VyperUI:CreateTextParagraph(WebhookTab, {
    Title = "📖 How to Get Discord User ID?",
    Lines = {
        "1. Open Discord Settings",
        "2. Go to 'Advanced' tab",
        "3. Enable 'Developer Mode'",
        "4. Right-click your profile",
        "5. Click 'Copy User ID'",
        "6. Paste it in the textbox above!"
    }
})


-- ========================================
-- Auto Fish
-- ========================================
local AutoFishSection = VyperUI:CreateCollapsibleSection(HomeTab, {
    Title = "Auto Fish",
    DefaultExpanded = false,
})

VyperUI:CreateSection(AutoFishSection, "Auto Fishing System")
local function GeneratePerfectClickValue()
    -- FORMAT: 0.9695933353646502
    -- Pattern: 0.96xxxxxxx (12-15 digits)
    
    local base = 0.96  -- Base value
    local randomDigits = math.random(959333, 999999)  -- Random 6 digits
    local decimalPart = randomDigits / 1000000  -- Convert to decimal
    
    return base + decimalPart
end
local function Fishing1()
    local processToggle = 1 -- 1 atau 2
    
    spawn(function()
        while AutoFishEnabled do
            pcall(function()
                if processToggle == 1 then
                    -- PROCESS 1
                    RFChargeFishingRod:InvokeServer(workspace:GetServerTimeNow())
                    task.wait(0.3)
                    local perfectArgs = {
                        -1.333184814453125,
                        GeneratePerfectClickValue(),
                        workspace:GetServerTimeNow()
                    }
                    RFRequestFishingMinigameStarted:InvokeServer(unpack(perfectArgs))
                    task.wait(FishingDelay)
                    REFishingCompleted:FireServer()
                    task.wait(CancelDelay)
                    RFCancelFishingInputs:InvokeServer()
                    
                    processToggle = 2 -- Switch ke process 2
                    
                else
                    -- PROCESS 2  
                    RFChargeFishingRod:InvokeServer(workspace:GetServerTimeNow())
                    task.wait(0.3)
                    local perfectArgs = {
                        -1.333184814453125,
                        GeneratePerfectClickValue(),
                        workspace:GetServerTimeNow()
                    }
                    RFRequestFishingMinigameStarted:InvokeServer(unpack(perfectArgs))
                    task.wait(FishingDelay)
                    REFishingCompleted:FireServer()
                    task.wait(CancelDelay)
                    RFCancelFishingInputs:InvokeServer()
                    
                    processToggle = 1 -- Switch ke process 1
                end
            end)
            -- TIDAK ADA WAIT DI SINI - LANGSUNG PROCESS BERIKUTNYA!
        end
    end)
end



local function Blatant()
        while AutoFishEnabled do
            pcall(function()
                        RFChargeFishingRod:InvokeServer(1)
                        RFRequestFishingMinigameStarted:InvokeServer(
                            math.random(-1, 1),
                            1,
                            math.random(1000000, 9999999)
                        )
                
                task.wait(FishingDelay)
                REFishingCompleted:FireServer()
                
                task.wait(CancelDelay)
                RFCancelFishingInputs:InvokeServer()
            end)
        end
end


VyperUI:CreateNumericInput(AutoFishSection, {
    Title = "Fish Delay",
    Subtitle = "Naikin Jika Ikan Ga Keangkat",
    Min = 0.3,
    Max = 3.5,
    Default = Config.FishingDelay or 1.0,
    Increment = 0.01,
    DecimalPlaces = 2,
    Suffix = "s",
    Callback = function(value)
        Config.FishingDelay = value
        FishingDelay = value
        print("⚡ [CHANGE] FishingDelay ->", value, "(Not saved yet)")
    end
})

VyperUI:CreateNumericInput(AutoFishSection, {
    Title = "Cancel Delay",
    Subtitle = "Lempar Rod Selanjutnya",
    Min = 0.1,
    Max = 1.5,
    Default = Config.CancelDelay or 0.5,
    Increment = 0.01,
    DecimalPlaces = 2,
    Suffix = "s",
    Callback = function(value)
        Config.CancelDelay = value
        CancelDelay = value
        print("⚡ [CHANGE] CancelDelay ->", value, "(Not saved yet)")
    end
})




VyperUI:CreateToggle(AutoFishSection, {
    Title = "Auto Fish",
    Subtitle = "Fast 1x",
    Default = false,
    Callback = function(state)
        AutoFishEnabled = state
        if state then
            print("🟢 STEALTH MODE ACTIVATED - Humanized patterns")
            Blatant()
        else
            print("🔴 AUTO FISH STOPPED")
        end
    end
})

VyperUI:CreateToggle(AutoFishSection, {
    Title = "Auto Fish",
    Subtitle = "80% Perfeck",
    Default = false,
    Callback = function(state)
        AutoFishEnabled = state
        if state then
            print("🟢 STEALTH MODE ACTIVATED - Humanized patterns")
            Fishing1()
        else
            print("🔴 AUTO FISH STOPPED")
        end
    end
})
-- ========================================
-- Blatant
-- ========================================
-- ========================================
-- FIXED BLATANT FISHING (PARALLEL EXECUTION)
-- ========================================
-- BLATANT FISH (GAME ASLI - FULL PARAM MATCH)
-- ========================================

BlatantFishingDelay = 0.70
BlatantCancelDelay = 0.30
AutoFishEnabled = false

local BlatantFishSection = VyperUI:CreateCollapsibleSection(HomeTab, {
    Title = "Fish Blatant",
    DefaultExpanded = false,
})

VyperUI:CreateSection(BlatantFishSection, "⚡ Fast Fishing System")


-- SAFE PARALLEL EXECUTION
local function safeFire(func)
    task.spawn(function()
        pcall(func)
    end)
end


-- MAIN LOOP (PARAMETER SESUAI GAME TEMEN LU)
local function UltimateBypassFishing()
    task.spawn(function()
        while AutoFishEnabled do
            local currentTime = workspace:GetServerTimeNow()

            -- CAST
            safeFire(function()
                RFChargeFishingRod:InvokeServer({[1] = currentTime})
            end)

            safeFire(function()
                RFRequestFishingMinigameStarted:InvokeServer(1, 0, currentTime)
            end)

            task.wait(BlatantFishingDelay)

            -- COMPLETE
            safeFire(function()
                REFishingCompleted:FireServer()
            end)

            task.wait(BlatantCancelDelay)

            -- CANCEL
            safeFire(function()
                RFCancelFishingInputs:InvokeServer()
            end)

            task.wait() -- anti-freeze
        end
    end)
end


-- UI: Fish Delay
VyperUI:CreateNumericInput(BlatantFishSection, {
    Title = "Fish Delay",
    Subtitle = "Naikin Jika Ikan Ga Keangkat",
    Min = 0.3,
    Max = 3.5,
    Default = 0.70,
    Increment = 0.01,
    DecimalPlaces = 2,
    Suffix = "s",
    Callback = function(v)
        BlatantFishingDelay = v
    end
})

-- UI: Cancel Delay
VyperUI:CreateNumericInput(BlatantFishSection, {
    Title = "Cancel Delay",
    Subtitle = "Lempar Rod Selanjutnya",
    Min = 0.1,
    Max = 1.5,
    Default = 0.30,
    Increment = 0.01,
    DecimalPlaces = 2,
    Suffix = "s",
    Callback = function(v)
        BlatantCancelDelay = v
    end
})

-- TOGGLE
VyperUI:CreateToggle(BlatantFishSection, {
    Title = "Auto Fish",
    Subtitle = "⚡ Optimized 2x Speed",
    Default = false,
    Callback = function(state)
        AutoFishEnabled = state
        if state then
            print("🟢 BLATANT FISH: ENABLED")
            UltimateBypassFishing()
        else
            print("🔴 AUTO FISH STOPPED")
        end
    end
})


-- ========================================
-- Legit Fish
-- ========================================
local LegitFishSection = VyperUI:CreateCollapsibleSection(HomeTab, {
    Title = "Fish Legit",
    DefaultExpanded = false,
})

VyperUI:CreateSection(LegitFishSection, "Fitur Fishing Legit")

local function VirtualTap()
    -- Simulate tap di center screen (ga pake mouse movement)
    local screenSize = workspace.CurrentCamera.ViewportSize
    local centerX = screenSize.X / 2
    local centerY = screenSize.Y / 2
    
    -- Virtual tap tanpa input mouse
    VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 0)
    task.wait(0.001)
    VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 0)
end

local function LegitFastTap()
    while LegitFishEnabled do
        -- Random delay biar keliatan human-like
        local randomDelay = LegitTapSpeed + math.random(-TapRandomization * 100, TapRandomization * 100) / 100
        
        VirtualTap()
        task.wait(randomDelay)
    end
end

-- ========================================
-- 🤖 ENABLE AUTO FISHING STATE
-- ========================================
local function EnableAutoFishingState()
    local args = { true }
    RFUpdateAutoFishingState:InvokeServer(unpack(args))
    print("🟢 Auto Fishing State: ENABLED")
end

local function DisableAutoFishingState()
    local args = { false }
    RFUpdateAutoFishingState:InvokeServer(unpack(args))
    print("🔴 Auto Fishing State: DISABLED")
end

-- ========================================
-- 🎮 UI CONTROLS
-- ========================================
VyperUI:CreateButton(LegitFishSection, {
    Title = "🎯 Toggle Legit Fast Tap",
    Subtitle = "Click to ON/OFF | Virtual tap tanpa mouse",
    Callback = function()
        LegitFishEnabled = not LegitFishEnabled
        
        if LegitFishEnabled then
            print("🟢 LEGIT FAST TAP: ON")
            EnableAutoFishingState()
            spawn(LegitFastTap)
        else
            print("🔴 LEGIT FAST TAP: OFF")
            DisableAutoFishingState()
        end
    end
})

-- 👆 TAP SPEED SLIDER
VyperUI:CreateSlider(LegitFishSection, {
    Title = "⚡ Tap Speed",
    Subtitle = "Delay antar tap (semakin kecil = semakin cepat)",
    Min = 0.01,
    Max = 0.15,
    Default = Config.LegitTapSpeed,
    Increment = 0.01,
    Callback = function(value)
        local newValue = tonumber(string.format("%.2f", value))
        Config.LegitTapSpeed = newValue
        LegitTapSpeed = newValue
        
        print("👆 [CHANGE] LegitTapSpeed ->", newValue, "(Not saved yet)")
    end
})
-- 🎲 TAP RANDOMIZATION SLIDER
VyperUI:CreateSlider(LegitFishSection, {
    Title = "🎲 Tap Randomization", 
    Subtitle = "Variasi timing biar human-like",
    Min = 0,
    Max = 0.05,
    Default = Config.TapRandomization,
    Increment = 0.005,
    Callback = function(value)
        local newValue = tonumber(string.format("%.3f", value))
        Config.TapRandomization = newValue
        TapRandomization = newValue
        
        print("🎲 [CHANGE] TapRandomization ->", newValue, "(Not saved yet)")
    end
})


-- ========================================
-- AUTO REJOIN ON DISCONNECT
-- ========================================


local AutoRejoinEnabled = false

-- Function untuk auto rejoin pas disconnect
local function SetupAutoRejoin()
    Players.LocalPlayer.OnTeleport:Connect(function(State)
        if State == Enum.TeleportState.Started then
            print("🔄 Teleporting...")
        end
    end)

    game:GetService("GuiService").ErrorMessageChanged:Connect(function()
        if AutoRejoinEnabled then
            print("🔄 Disconnect detected! Rejoining...")
            task.wait(1)
            TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
        end
    end)

    game:GetService("CoreGui").DescendantAdded:Connect(function(x)
        if AutoRejoinEnabled and x.Name == "ErrorPrompt" then
            print("🔄 Error detected! Rejoining...")
            task.wait(1)
            TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
        end
    end)
end



-- ⚡ ANIMATION BLOCKER
local function BlockFishingAnimations()
    while AutoFishEnabled do
        local char = Player.Character or Player.CharacterAdded:Wait()
        local humanoid = char:FindFirstChildOfClass("Humanoid")

        if humanoid then
            for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                if track.Name ~= "Walk" and track.Name ~= "Run" then
                    track:Stop()
                end
            end
        end

        task.wait(0.05)
    end
end





local PopupBlockerActive = false
local OriginalConnections = {}
local CustomConnection = nil

local function EnablePopupBlocker()
    if PopupBlockerActive then return end

    task.spawn(function()
        task.wait(1)

        local remote = net["RE/ObtainedNewFishNotification"]
        if not remote then
            warn("❌ Remote 'RE/ObtainedNewFishNotification' not found!")
            return
        end

        -- Backup dan disable original
        OriginalConnections = {}
        for _, conn in ipairs(getconnections(remote.OnClientEvent)) do
            table.insert(OriginalConnections, conn)
            conn:Disable()
        end

        -- Buat koneksi custom (disimpan biar bisa di-disconnect)
        CustomConnection = remote.OnClientEvent:Connect(function(_, _, notifConfig, flag)
            for _, conn in ipairs(OriginalConnections) do
                pcall(conn.Function, nil, nil, notifConfig, flag)
            end
        end)

        PopupBlockerActive = true
        print("✅ Popup blocker enabled")
    end)
end

local function DisablePopupBlocker()
    if not PopupBlockerActive then return end

    local remote = net["RE/ObtainedNewFishNotification"]
    if not remote then return end

    -- Hapus koneksi custom
    if CustomConnection then
        CustomConnection:Disconnect()
        CustomConnection = nil
    end

    -- Restore original connections
    for _, conn in ipairs(OriginalConnections) do
        conn:Enable()
    end

    OriginalConnections = {}
    PopupBlockerActive = false

    print("❎ Popup blocker disabled (restored clean)")
end

---------------------------------------------------------------------
-- 📷 INFINITE ZOOM CAMERA
---------------------------------------------------------------------
local InfiniteZoomEnabled = false

local function EnableInfiniteZoom()
    if InfiniteZoomEnabled then
        print("⚠️ Infinite zoom already enabled!")
        return
    end
    
    local Player = game.Players.LocalPlayer
    
    -- Set max zoom distance
    Player.CameraMaxZoomDistance = math.huge
    Player.CameraMinZoomDistance = 0.5
    
    InfiniteZoomEnabled = true
    print("✅ Infinite camera zoom enabled!")
    print("📷 Zoom out as far as you want!")
end

local function DisableInfiniteZoom()
    if not InfiniteZoomEnabled then return end
    
    local Player = game.Players.LocalPlayer
    
    -- Reset ke default Roblox
    Player.CameraMaxZoomDistance = 128
    Player.CameraMinZoomDistance = 0.5
    
    InfiniteZoomEnabled = false
    print("🔴 Infinite zoom disabled - Reset to default (128 studs)")
end






VyperUI:CreateSection(HomeTab, "Fitur Fishing System")
--jalan di air






VyperUI:CreateButton(HomeTab, {
    Title = "Save Config",
    Description = "Simpan pengaturan",
    Callback = function()
        SaveConfig()
        print("Config berhasil disimpan!")
    end
})
-- =========================
-- 🔄 RESET TO DEFAULT BUTTON
-- =========================

VyperUI:CreateButton(HomeTab, {
    Title = "Reset Config",
    Description = "Kembalikan ke pengaturan awal",
    Callback = function()
        Config.FishingDelay = 0.7
        Config.CancelDelay = 1.5
        Config.LegitTapSpeed = 0.05
        Config.TapRandomization = 0.02
        
        FishingDelay = Config.FishingDelay
        CancelDelay = Config.CancelDelay
        LegitTapSpeed = Config.LegitTapSpeed
        TapRandomization = Config.TapRandomization
        
        print("🔄 Config direset ke default! (Klik 'Save Config' untuk menyimpan)")
        printConfigStatus()
    end
})


-- ========================================
-- PERMANENT VFX REMOVER (Rod Effects)
-- ========================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoveVFXEnabled = false
local MonitorConnection = nil

-- Function untuk hapus VFX langsung
local function DeleteVFX()
    local vfx = ReplicatedStorage:FindFirstChild("VFX")
    if vfx then
        vfx:Destroy()
        print("🗑️ VFX deleted permanently.")
    else
        warn("❌ VFX folder not found.")
    end
end

-- Toggle untuk ON/OFF remover
local function ToggleVFX(enabled)
    RemoveVFXEnabled = enabled

    if enabled then
        print("🔴 Removing VFX...")
        DeleteVFX()

        -- Monitor kalau game spawn ulang VFX
        if MonitorConnection then
            MonitorConnection:Disconnect()
        end

        MonitorConnection = ReplicatedStorage.ChildAdded:Connect(function(child)
            if child.Name == "VFX" then
                task.wait(0.05)
                child:Destroy()
                print("🔄 Auto-deleted respawned VFX")
            end
        end)

        print("✅ VFX removal active.")
    else
        print("🟢 VFX remover disabled.")

        if MonitorConnection then
            MonitorConnection:Disconnect()
            MonitorConnection = nil
        end
    end
end

VyperUI:CreateToggle(HomeTab, {
    Title = "Remove Skin",
    Subtitle = "(permanent delete)",
    Default = false,
    Callback = function(state)
        ToggleVFX(state)
    end
})




VyperUI:CreateToggle(HomeTab, {
    Title = "Hide Big Popup",
    Subtitle = "Apalu ha?",
    Default = false,
    Callback = function(state)
        if state then
            EnablePopupBlocker()
            print("🟢 BIG POPUP BLOCKER ENABLED")
        else
            DisablePopupBlocker()
            print("🔴 Popup blocker OFF")
        end
    end
})



VyperUI:CreateToggle(HomeTab, {
    Title = "Auto Rejoin",
    Subtitle = "Otomatis rejoin",
    Default = false,
    Callback = function(state)
        AutoRejoinEnabled = state
        if state then
            print("🟢 AUTO REJOIN ACTIVATED")
            SetupAutoRejoin()
        else
            print("🔴 AUTO REJOIN DISABLED")
        end
    end
})



VyperUI:CreateToggle(HomeTab, {
    Title = "Infinite Camera Zoom",
    Subtitle = "Zoom out",
    Default = false,
    Callback = function(state)
        if state then
            EnableInfiniteZoom()
        else
            DisableInfiniteZoom()
        end
    end
})

VyperUI:CreateToggle(HomeTab, {
    Title = "Block Animations",
    Subtitle = "Stop semua animasi",
    Default = false,
    Callback = function(state)
        BlockAnimationsEnabled = state
        if state then
            print("🟢 BLOCK ANIMATIONS: ON")
            spawn(BlockFishingAnimations)  -- jalankan loop
        else
            print("🔴 BLOCK ANIMATIONS: OFF")
        end
    end
})

VyperUI:CreateToggle(HomeTab, {
    Title = "Lock Position",
    Subtitle = "Cegah Player Berpindah",
    Default = false,
    Callback = function(state)
        LockPositionEnabled = state

        if state then
            -- Simpan posisi DAN ROTASI saat toggle diaktifkan
            local character = Player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local rootPart = character.HumanoidRootPart
                OriginalPosition = rootPart.Position
                OriginalRotation = rootPart.CFrame  -- ⬅️ SIMPAN ROTASI JUGA!
                print("🔒 Position lock ENABLED - Position & rotation saved")

                -- Jaga posisi DAN ROTASI agar tidak berubah
                task.spawn(function()
                    while LockPositionEnabled and character and character.Parent do
                        if rootPart and OriginalPosition and OriginalRotation then
                            -- HILANGIN VELOCITY
                            rootPart.Velocity = Vector3.new(0, 0, 0)
                            rootPart.RotVelocity = Vector3.new(0, 0, 0)
                            
                            -- LOCK POSISI + ROTASI
                            rootPart.CFrame = OriginalRotation  -- ⬅️ PAKE ROTASI ASLI!
                        end
                        task.wait(0.1)
                    end
                end)
            end
        else
            OriginalPosition = nil
            OriginalRotation = nil
            print("🔓 Position lock DISABLED")
        end
    end
})

-- Fungsi jual item
local function SellItems()
    print("💰 Selling items...")
    pcall(function()
        SellItemsRemote:InvokeServer()
        print("💰 SELL: Items terjual")
    end)
end


VyperUI:CreateSection(ShopTab, "💰 Auto Sell Settings")

-- 🔘 Tombol manual: Sell Items Once
VyperUI:CreateButton(ShopTab, {
    Title = "Sell Items Once",
    Subtitle = "Jual semua item sekarang",
    Callback = function()
        SellItems()
    end
})

-- ========================================
-- AUTO SELL SYSTEM (ADJUSTABLE)
-- ========================================
local SellInterval = 300  -- Default 5 menit (dalam detik)

-- SLIDER WAKTU SELL
VyperUI:CreateSlider(ShopTab, {
    Title = "⏱️ Sell Interval Menit",
    Subtitle = "Atur jeda waktu auto sell (dalam menit)",
    Min = 1,      -- Minimal 1 menit
    Max = 60,     -- Maksimal 1 jam
    Default = 5,  -- Default 5 menit (RECOMMENDED)
    Increment = 1,
    Callback = function(value)
        SellInterval = value * 60  -- Convert menit ke detik
        print("⏱️ Sell interval diatur ke:", value, "menit")
    end
})

-- TOGGLE AUTO SELL
VyperUI:CreateToggle(ShopTab, {
    Title = "Auto Sell",
    Subtitle = "Jual otomatis",
    Default = false,
    Callback = function(state)
        AutoSellEnabled = state
        if state then
            print("🟢 AUTO SELL STARTED - Interval:", SellInterval/60, "menit")

            task.spawn(function()
                while AutoSellEnabled do
                    pcall(function()
                        SellItemsRemote:InvokeServer()
                        print("💰 SELL: Items terjual! Next sell dalam", SellInterval/60, "menit")
                    end)

                    -- Countdown dengan check setiap detik
                    for i = SellInterval, 1, -1 do
                        if not AutoSellEnabled then break end
                        task.wait(1)
                    end
                end
            end)

        else
            print("🔴 AUTO SELL STOPPED")
        end
    end
})

VyperUI:CreateSection(ShopTab, "Buy Totem")

-- ========================================
-- SHOP: BUY TOTEM (REMOTE PURCHASE)
-- ========================================

local SelectedTotemID = 8  -- Default ID (bakal diganti pas pilih dropdown)
local TotemAmount = 1      -- Jumlah totem yang mau dibeli

-- Data totem (sesuaiin sama ID di game lu)
local TotemList = {
    ["Totem Mutasi"] = 8,   -- ID totem mutasi
    ["Totem Lucky"] = 5     -- ID totem lucky (ganti sesuai game lu)
}

-- Remote untuk beli totem
local BuyTotemRemote = game:GetService("ReplicatedStorage")
    :WaitForChild("Packages", 9e9)
    :WaitForChild("_Index", 9e9)
    :WaitForChild("sleitnick_net@0.2.0", 9e9)
    :WaitForChild("net", 9e9)
    :WaitForChild("RF/PurchaseMarketItem", 9e9)

-- DROPDOWN: Pilih Jenis Totem
VyperUI:CreateDropdown(ShopTab, {
    Title = "🗿 Pilih Jenis Totem",
    Subtitle = "Pilih totem yang mau dibeli",
    Options = {"Totem Mutasi", "Totem Lucky"},
    Default = "Totem Mutasi",
    Callback = function(selected)
        SelectedTotemID = TotemList[selected]
        print("🗿 Totem dipilih:", selected, "| ID:", SelectedTotemID)
    end
})

-- NUMERIC INPUT: Atur Jumlah Totem
VyperUI:CreateNumericInput(ShopTab, {
    Title = "🔢 Jumlah Totem",
    Subtitle = "Atur berapa totem yang mau dibeli",
    Min = 1,
    Max = 100,
    Default = 1,
    Increment = 1,
    DecimalPlaces = 0,  -- Ga pake desimal, karena ini jumlah
    Suffix = "x",
    Callback = function(value)
        TotemAmount = value
        print("🔢 Jumlah totem diatur ke:", value)
    end
})

-- BUTTON: Beli Totem
VyperUI:CreateButton(ShopTab, {
    Title = "🛒 Beli Totem Sekarang",
    Subtitle = "Klik untuk membeli totem yang dipilih",
    Callback = function()
        local success = 0
        local failed = 0
        
        print("🛒 Memulai pembelian", TotemAmount, "totem...")
        
        for i = 1, TotemAmount do
            local args = {
                [1] = SelectedTotemID
            }
            
            local ok, err = pcall(function()
                BuyTotemRemote:InvokeServer(unpack(args))
            end)
            
            if ok then
                success = success + 1
            else
                failed = failed + 1
                warn("❌ Gagal beli totem ke-" .. i .. ":", err)
            end
            
            task.wait(0.1)  -- Delay dikit biar ga spam
        end
        
        print("✅ SELESAI! Berhasil:", success, "| Gagal:", failed)
    end
})



-- ========================================
-- Teleport Tab
-- ========================================

-- 🌍 SECTION: TELEPORT SYSTEM
VyperUI:CreateSection(TeleportTab, "Teleport to Island")

-- 🌿 Daftar lokasi teleport
local TeleportLocations = {
    ["🌿 Ancient Jungle"] = CFrame.new(1836.47, 30, -596.10),
    ["🌿 Coral Reefs"] = CFrame.new(-2883.47, 60, 2008.82),
    ["🌿 Crystal Island"] = CFrame.new(979.64, 30, 4896.57),
    ["🌿 Esoteric Depths"] = CFrame.new(3108.01, -1280, 1424.69),
    ["🌿 Esoteric Island"] = CFrame.new(2061.67, 40, 1359.32),
    ["🌿 Fisherman Island"] = CFrame.new(14.21, 25, 2892.73),
    ["🌿 Kohana"] = CFrame.new(-685.85, 35, 594.94),
    ["🌿 Lost Isle"] = CFrame.new(-3725.72, -160, -1387.91),
    ["🌿 Mount Hallow"] = CFrame.new(1963.96, 40, 3090.38),
    ["🌿 Tropical Grove"] = CFrame.new(-2169.64, 70, 3697.78),
    ["🌿 Sisyphus Statue"] = CFrame.new(-3702.8, -135.6, -1022.0),
    ["🌿 Treasure Room"] = CFrame.new(-3595.1, -266.5, -1581.3),
    ["🌿 Underground Cellar"] = CFrame.new(2114.45, -91.20, -731.67),
    ["🌿 Seacred Temple"] = CFrame.new(1479.67, 40.62, -589.61),
    ["🌿 Acient Ruin"] = CFrame.new(6045.40234375, -588.600830078125, 4608.9375),
    ["🌿 Iron Cavern"] = CFrame.new(-8847.40, -564.60, 156.93),
    ["🌿 Iron Cavern Cafe"] = CFrame.new(-8627.40, -547.60, 145.93),
    ["🌿 Classic Island"] = CFrame.new(1271.40, 59.60, 2879.93)
}



-- 🧭 Daftar lokasi NPC
local TeleportNPCs = {
    ["🧙‍♂️ ALEX"] = CFrame.new(48.093082427978516, 17.49609375, 2877.1337890625),
    ["👽 Alien Merchant"] = CFrame.new(-132.127685546875, 2.7175116539001465, 2757.4619140625),
    ["👦 Aura Kid"] = CFrame.new(71.09320831298828, 18.533523559570312, 2830.35888671875),
    ["🤠 Billy Bob"] = CFrame.new(79.843017578125, 18.659088134765625, 2876.6337890625),
    ["🛶 Boat Expert"] = CFrame.new(33.31800079345703, 9.800000190734863, 2783.009033203125),
    ["👻 Ghost"] = CFrame.new(2083.015869140625, 116.37538146972656, 3061.132080078125),
    ["🎃 Hallow Guardian"] = CFrame.new(1812.379150390625, 22.867568969726562, 3083.647216796875),
    ["🐴 Headless Horseman"] = CFrame.new(1869.5625, 24.270931243896484, 3059.702880859375),
    ["👨 Joe"] = CFrame.new(144.04344177246094, 20.483728408813477, 2862.3837890625),
    ["🎃 Pumpkin Bandit"] = CFrame.new(1964.0299072265625, 39.40044403076172, 3147.499267578125),
    ["👨 Ron"] = CFrame.new(-51.706790924072266, 17.333524703979492, 2859.558837890625),
    ["🗺️ Scared Guide"] = CFrame.new(1898.953369140625, 23.625404357910156, 3103.867431640625),
    ["🔬 Scientis"] = CFrame.new(-7.986289024353027, 17.408599853515625, 2885.480712890625),
    ["👨 Scott"] = CFrame.new(-17.127307891845703, 9.531585693359375, 2703.35888671875),
    ["👨 Seth"] = CFrame.new(111.5931396484375, 17.40863037109375, 2877.1337890625),
    ["🎣 Silly Fisherman"] = CFrame.new(101.947265625, 9.531571388244629, 2705.8447265625),
    ["🏛️ Temple Guardian"] = CFrame.new(1491.4769287109375, 127.49998474121094, -593.1591186523438),
    ["🗺️ Tour Guide"] = CFrame.new(1238.889892578125, 7.8228678703308105, -238.18565368652344),
    ["🧙‍♀️ Witch"] = CFrame.new(1887.964111328125, 22.857566833496094, 3082.594970703125),
    ["🐶 Zombiefied Doge"] = CFrame.new(2172.699951171875, 80.88142395019531, 3325.137451171875)
}

local TeleportEncant = {
    ["🌿 Encant 1 "] = CFrame.new(3234.30, -1302.85, 1399.18),
    ["🌿 Encant 2"] = CFrame.new(1479.67, 127.62, -589.61)
}



-- 🔧 Helper: ambil semua key dari tabel
local function GetTableKeys(tbl)
    local keys = {}
    for name, _ in pairs(tbl) do
        table.insert(keys, name)
    end
    table.sort(keys) -- biar rapi di UI
    return keys
end

-- 🚀 Fungsi teleport (anti nyangkut)
local function TeleportToLocation(locationName, cf)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = player.Character.HumanoidRootPart

        -- Naik dikit biar ga stuck
        local safeCF = cf + Vector3.new(0, 10, 0)
        rootPart.CFrame = safeCF

        task.wait(0.3)
        rootPart.CFrame = cf

        print("🚀 Teleported to:", locationName)
    else
        warn("❌ Cannot teleport - character not found")
    end
end

-- 🏝️ Dropdown: Teleport ke Island
VyperUI:CreateDropdown(TeleportTab, {
    Title = "🌍 Select Island",
    Subtitle = "Pilih lokasi tujuan teleport",
    Options = GetTableKeys(TeleportLocations),
    Default = "🌿 Ancient Jungle",
    Callback = function(selected)
        local cf = TeleportLocations[selected]
        if cf then
            TeleportToLocation(selected, cf)
        else
            warn("❌ Lokasi tidak ditemukan:", selected)
        end
    end
})

VyperUI:CreateSection(TeleportTab, "Teleport to Encant")

VyperUI:CreateDropdown(TeleportTab, {
    Title = "Encant To Encant",
    Subtitle = "Encant Rod",
    Options = GetTableKeys(TeleportEncant),
    Default = "Encant Rod",
    Callback = function(selected)
        local cf = TeleportEncant[selected]
        if cf then
            TeleportToLocation(selected, cf)
        else
            warn("❌ NPC tidak ditemukan:", selected)
        end
    end
})

VyperUI:CreateSection(TeleportTab, "Teleport to event")

-- ========================================
-- TELEPORT TO MEGALODON EVENT (MANUAL)
-- ========================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local MenuRings = workspace:WaitForChild("!!! MENU RINGS")

-- Table untuk nyimpen event yang aktif
local ActiveEvents = {}

-- Function untuk scan semua event yang lagi spawn
local function ScanEvents()
    local events = {}
    
    -- Loop semua child di Menu Rings
    for _, props in pairs(MenuRings:GetChildren()) do
        -- Cek apakah nama folder = "Props"
        if props.Name == "Props" and (props:IsA("Model") or props:IsA("Folder")) then
            -- Ambil child pertama (nama event)
            local eventChild = props:GetChildren()[1]
            
            if eventChild then
                local eventName = eventChild.Name
                -- Simpen ke table: Key = nama event, Value = Props object
                events[eventName] = props
            end
        end
    end
    
    return events
end

-- Function untuk dapetin list nama event (buat Options dropdown)
local function GetEventNames()
    local names = {}
    for eventName, _ in pairs(ActiveEvents) do
        table.insert(names, eventName)
    end
    
    -- Kalau ga ada event, tambahin placeholder
    if #names == 0 then
        table.insert(names, "No Events Available")
    end
    
    return names
end

-- Function teleport
local function TeleportToEvent(eventName)
    -- Jangan teleport kalau placeholder
    if eventName == "No Events Available" then
        warn("⚠️ Belum ada event yang spawn!")
        return
    end
    
    local propsObject = ActiveEvents[eventName]
    
    if not propsObject or not propsObject.Parent then
        warn("❌ Event tidak ditemukan atau sudah despawn:", eventName)
        return
    end
    
    -- Ambil posisi event
    local pivot = propsObject:GetPivot().Position
    
    -- Teleport 10 studs di atas biar ga kejebak
    HumanoidRootPart.CFrame = CFrame.new(pivot + Vector3.new(0, 10, 0))
    print("✅ Teleport ke event:", eventName)
end

-- Scan pertama kali
ActiveEvents = ScanEvents()

-- Buat dropdown
local EventDropdown = VyperUI:CreateDropdown(TeleportTab, {
    Title = "🎯 Teleport to Event",
    Subtitle = "Pilih event yang lagi spawn",
    Options = GetEventNames(),
    Default = GetEventNames()[1],
    Callback = function(selected)
        TeleportToEvent(selected)
    end
})

-- Auto-refresh tiap 30 detik
task.spawn(function()
    while task.wait(30) do
        local success, err = pcall(function()
            -- Scan ulang event
            local newEvents = ScanEvents()
            
            -- Cek apakah ada perubahan
            local hasChanged = false
            
            -- Cek event baru
            for eventName, _ in pairs(newEvents) do
                if not ActiveEvents[eventName] then
                    hasChanged = true
                    print("🆕 Event baru spawn:", eventName)
                end
            end
            
            -- Cek event yang despawn
            for eventName, _ in pairs(ActiveEvents) do
                if not newEvents[eventName] then
                    hasChanged = true
                    print("❌ Event despawn:", eventName)
                end
            end
            
            -- Update kalau ada perubahan
            if hasChanged then
                ActiveEvents = newEvents
                
                -- 🔥 UPDATE DROPDOWN (pake method baru)
                EventDropdown:UpdateOptions(GetEventNames(), GetEventNames()[1])
                
                print("🔄 Dropdown updated! Total events:", #GetEventNames())
            end
        end)
        
        if not success then
            warn("❌ Error saat update dropdown:", err)
        end
    end
end)



VyperUI:CreateSection(TeleportTab, "Teleport to NPC")


-- 🤝 Dropdown: Teleport ke NPC
VyperUI:CreateDropdown(TeleportTab, {
    Title = "🤖 Teleport to NPC",
    Subtitle = "Pergi cepat ke NPC pilihanmu",
    Options = GetTableKeys(TeleportNPCs),
    Default = "🧙‍♂️ Fisherman",
    Callback = function(selected)
        local cf = TeleportNPCs[selected]
        if cf then
            TeleportToLocation(selected, cf)
        else
            warn("❌ NPC tidak ditemukan:", selected)
        end
    end
})



VyperUI:CreateSection(TeleportTab, "Teleport to Player")

-- ==========================
-- 🧍 TELEPORT TO PLAYER
-- ==========================

-- Buat daftar pemain (selain diri sendiri)
local function GetOtherPlayers()
    local players = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Player then
            table.insert(players, plr.Name)
        end
    end

    -- FIX PENTING: kalau kosong, kasih placeholder
    if #players == 0 then
        return {"No Other Players"}
    end

    return players
end

-- Fungsi teleport ke player
local function TeleportToPlayer(targetName)
    -- Jangan teleport kalau placeholder
    if targetName == "No Other Players" then
        warn("⚠️ Ga ada pemain lain di server!")
        return
    end
    
    local targetChar = workspace:FindFirstChild("Characters") and workspace.Characters:FindFirstChild(targetName)
    if targetChar and targetChar:FindFirstChild("HumanoidRootPart") and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = Player.Character.HumanoidRootPart
        local targetCF = targetChar.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
        rootPart.CFrame = targetCF
        print("🚀 Teleported to player:", targetName)
    else
        warn("❌ Gagal teleport ke " .. targetName .. " - player tidak ditemukan atau belum spawn.")
    end
end

-- Dropdown daftar player
local PlayerDropdown = VyperUI:CreateDropdown(TeleportTab, {
    Title = "🧍 Teleport to Player",
    Subtitle = "Pilih pemain untuk teleport",
    Options = GetOtherPlayers(),
    Default = GetOtherPlayers()[1],
    Callback = function(selected)
        TeleportToPlayer(selected)
    end
})

-- Auto-refresh tiap 30 detik
task.spawn(function()
    while task.wait(30) do
        local success, err = pcall(function()
            local newPlayers = GetOtherPlayers()
            local currentPlayers = GetOtherPlayers()
            
            -- Cek apakah ada perubahan
            local hasChanged = false
            
            -- Simple check: bandingkan jumlah player
            if #newPlayers ~= #currentPlayers then
                hasChanged = true
            else
                -- Deep check: bandingkan nama satu-satu
                for i, name in ipairs(newPlayers) do
                    if name ~= currentPlayers[i] then
                        hasChanged = true
                        break
                    end
                end
            end
            
            -- Update kalau ada perubahan
            if hasChanged then
                -- 🔥 UPDATE DROPDOWN
                PlayerDropdown:UpdateOptions(newPlayers, newPlayers[1])
                
                print("🔄 Player list updated! Total players:", #newPlayers)
            end
        end)
        
        if not success then
            warn("❌ Error saat update player list:", err)
        end
    end
end)


-- ========================================
-- Auto Quest
-- ========================================

-- ==================================================
-- QUEST TAB : REALTIME DEEPSEA QUEST TRACKER (FIXED)
-- ==================================================


VyperUI:CreateSection(QuestTab, "Deep Sea Quest Tracker")

-- SERVICES
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- REMOTE FUNCTIONS (SHARED)
local net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
local RFChargeFishingRod = net["RF/ChargeFishingRod"]
local RFRequestFishingMinigameStarted = net["RF/RequestFishingMinigameStarted"]
local REFishingCompleted = net["RE/FishingCompleted"]
local RFCancelFishingInputs = net["RF/CancelFishingInputs"]

-- MODULE REQUIRE
local Replion = require(ReplicatedStorage.Packages.Replion)
local QuestUtility = require(ReplicatedStorage.Shared.Quests.QuestUtility)
local DeepSea = require(ReplicatedStorage.Shared.Quests.QuestList).DeepSea

-- VARIABLES QUEST TAB
local QuestLabels = {}
local QuestAutoFishEnabled = false
local QuestAutoTeleportEnabled = false
local DataReplion = Replion.Client:WaitReplion("Data")

-- QUEST POSITION
local DeepSeaQuestPos = CFrame.new(-3660.084, -134.129, -960.460)

-- 🧭 TELEPORT FUNCTION
local function TeleportToQuest()
    pcall(function()
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = DeepSeaQuestPos
            print("🎯 Teleported to DeepSea Quest!")
        end
    end)
end

-- 🎣 QUEST FISHING FUNCTION (STANDALONE)
local function QuestFishingCycle()
    while QuestAutoFishEnabled do
        pcall(function()
            -- 1. CHARGE ROD
            RFChargeFishingRod:InvokeServer(workspace:GetServerTimeNow())
            task.wait(0.3)
            
            -- 2. START FISHING
            local perfectArgs = {
                -1.333184814453125,
                GeneratePerfectClickValue(),
                workspace:GetServerTimeNow()
            }
            RFRequestFishingMinigameStarted:InvokeServer(unpack(perfectArgs))
            
            -- 3. COMPLETE FISHING
            task.wait(FishingDelay)
            REFishingCompleted:FireServer()
            task.wait(CancelDelay)
            RFCancelFishingInputs:InvokeServer()
        end)
    end
end

-- 🔄 REFRESH QUEST LIST
local function RefreshQuestList()
    pcall(function()
        local questData = DataReplion:Get(DeepSea.ReplionPath)
        if not questData or not questData.Available or not questData.Available.Forever then 
            return 
        end

        local quests = questData.Available.Forever.Quests
        if not quests then return end

        -- Clear previous labels
        for _, lbl in ipairs(QuestLabels) do
            lbl:Set({Title = "", Subtitle = ""})
        end

        -- Update quest progress
        for i, q in ipairs(quests) do
            local questInfo = QuestUtility:GetQuestData("DeepSea", "Forever", q.QuestId)
            if questInfo then
                -- FIXED: Get max value properly
                local maxVal = questInfo.TargetValue or questInfo.Goal or 1
                local progress = math.clamp(q.Progress / maxVal, 0, 1)
                local percent = math.floor(progress * 100)

                local text = string.format("%s - %d%%", questInfo.DisplayName, percent)

                if not QuestLabels[i] then
                    QuestLabels[i] = VyperUI:CreateLabel(QuestTab, { 
                        Title = text,
                        Subtitle = "Progress: " .. q.Progress .. "/" .. maxVal
                    })
                else
                    QuestLabels[i]:Set({
                        Title = text,
                        Subtitle = "Progress: " .. q.Progress .. "/" .. maxVal
                    })
                end
            end
        end
    end)
end

-- 🎯 QUEST CONTROLS
VyperUI:CreateSection(QuestTab, "Quest Controls")

-- Auto Teleport Toggle
VyperUI:CreateToggle(QuestTab, {
    Title = "🚀 Auto Teleport",
    Subtitle = "Teleport ke area DeepSea Quest",
    Default = false,
    Callback = function(state)
        QuestAutoTeleportEnabled = state
        if state then
            TeleportToQuest()
            print("🎯 Auto Teleport: ON")
        else
            print("🔴 Auto Teleport: OFF")
        end
    end
})

-- Manual Teleport Button
VyperUI:CreateButton(QuestTab, {
    Title = "📍 Teleport Now",
    Subtitle = "Manual teleport ke quest area",
    Callback = function()
        TeleportToQuest()
    end
})

-- Auto Fish for Quest Toggle
VyperUI:CreateToggle(QuestTab, {
    Title = "🎣 Quest Auto Fish",
    Subtitle = "Auto fishing khusus untuk quest",
    Default = false,
    Callback = function(state)
        QuestAutoFishEnabled = state
        if state then
            print("🟢 QUEST AUTO FISH: ON")
            spawn(QuestFishingCycle)
        else
            print("🔴 QUEST AUTO FISH: OFF")
        end
    end
})

-- Refresh Quest Button
VyperUI:CreateButton(QuestTab, {
    Title = "🔄 Refresh Quest",
    Subtitle = "Manual refresh quest progress",
    Callback = function()
        RefreshQuestList()
        print("🔁 Quest list refreshed!")
    end
})

-- 📊 QUEST STATUS SECTION
VyperUI:CreateSection(QuestTab, "Quest Progress")

-- Initial load
RefreshQuestList()

-- Real-time tracking
DataReplion:OnChange({DeepSea.Identifier, "Available", "Forever"}, function()
    RefreshQuestList()
end)

-- Auto refresh setiap 10 detik
spawn(function()
    while true do
        wait(10)
        if #QuestLabels > 0 then  -- Only refresh if we have quests
            RefreshQuestList()
        end
    end
end)

print("✅ DEEPSEA QUEST TRACKER LOADED!")

-- ==================================================
-- QUEST UI SECTIONS
-- ==================================================

-- Section Quest Tracker
VyperUI:CreateSection(QuestTab, "🎯 DeepSea Quest Progress")

-- Pertama kali load
RefreshQuestList()

-- Section Auto Quest Control
VyperUI:CreateSection(QuestTab, "⚙️ Auto Quest Control")

VyperUI:CreateToggle(QuestTab, {
	Title = "🚀 Auto Quest Laut Dalam",
	Subtitle = "Teleport ke lokasi + Auto Fish",
	Default = false,
	Callback = function(state)
		AutoQuestEnabled = state

		if state then
			print("🟢 AUTO QUEST STARTED")
			TeleportToQuest()
			task.wait(2)
			AutoFishEnabled = true

			task.spawn(function()
				while AutoQuestEnabled and AutoFishEnabled do
					SmartFishingCycle()
					task.wait()
				end
			end)
		else
			print("🔴 AUTO QUEST STOPPED")
			AutoFishEnabled = false
		end
	end
})

-- ==================================================
-- QUEST TAB : element
-- ==================================================

-- ==================================================
-- ELEMENT JUNGLE QUEST TRACKER
-- ==================================================
VyperUI:CreateSection(JungleTab, "Element Jungle Quest Tracker")

-- MODULE REQUIRE
local ElementJungle = require(ReplicatedStorage.Shared.Quests.QuestList).ElementJungle
local QuestUtility = require(ReplicatedStorage.Shared.Quests.QuestUtility)
local Replion = require(ReplicatedStorage.Packages.Replion)

-- VARIABLES JUNGLE QUEST
local JungleLabels = {}
local JungleAutoEnabled = false
local DataReplion = Replion.Client:WaitReplion("Data")

-- JUNGLE QUEST POSITION
local JungleQuestPos = CFrame.new(2114.449951171875, -91.19999694824219, -736.3800048828125)

-- 🧭 TELEPORT TO JUNGLE
local function TeleportToJungle()
    pcall(function()
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = JungleQuestPos
            print("🌴 Teleported to Element Jungle!")
        end
    end)
end

-- 🔄 REFRESH JUNGLE QUEST LIST
local function RefreshJungleQuests()
    pcall(function()
        local questData = DataReplion:Get(ElementJungle.ReplionPath)
        if not questData or not questData.Available or not questData.Available.Forever then 
            return 
        end

        local quests = questData.Available.Forever.Quests
        if not quests then return end

        -- Clear previous labels
        for _, lbl in ipairs(JungleLabels) do
            lbl:Set({Title = "", Subtitle = ""})
        end

        local totalProgress = 0
        local completedQuests = 0

        -- Update jungle quest progress
        for i, q in ipairs(quests) do
            local questInfo = QuestUtility:GetQuestData("ElementJungle", "Forever", q.QuestId)
            if questInfo then
                -- Get max value dari QuestUtility
                local maxVal = QuestUtility.GetQuestValue(DataReplion, questInfo)
                local progress = math.clamp(q.Progress / maxVal, 0, 1)
                local percent = math.floor(progress * 100)
                
                totalProgress = totalProgress + progress
                if progress >= 1 then
                    completedQuests = completedQuests + 1
                end

                local text = string.format("%s - %d%%", questInfo.DisplayName, percent)

                if not JungleLabels[i] then
                    JungleLabels[i] = VyperUI:CreateLabel(JungleTab, { 
                        Title = text,
                        Subtitle = "Progress: " .. q.Progress .. "/" .. maxVal
                    })
                else
                    JungleLabels[i]:Set({
                        Title = text,
                        Subtitle = "Progress: " .. q.Progress .. "/" .. maxVal
                    })
                end
            end
        end

        -- Calculate overall progress
        local overallPercent = math.floor((totalProgress / #quests) * 100)
        print(string.format("🌴 Jungle Progress: %d%% (Completed: %d/%d)", overallPercent, completedQuests, #quests))
    end)
end

-- 🎯 JUNGLE QUEST CONTROLS
VyperUI:CreateSection(JungleTab, "Jungle Controls")

-- Auto Teleport Toggle
VyperUI:CreateToggle(JungleTab, {
    Title = "🚀 Auto Teleport Jungle",
    Subtitle = "Teleport ke area Element Jungle",
    Default = false,
    Callback = function(state)
        if state then
            TeleportToJungle()
            print("🌴 Auto Teleport Jungle: ON")
        else
            print("🔴 Auto Teleport Jungle: OFF")
        end
    end
})

-- Manual Teleport Button
VyperUI:CreateButton(JungleTab, {
    Title = "📍 Teleport to Jungle",
    Subtitle = "Manual teleport ke jungle area",
    Callback = function()
        TeleportToJungle()
    end
})

-- Refresh Jungle Quest Button
VyperUI:CreateButton(JungleTab, {
    Title = "🔄 Refresh Jungle Quest",
    Subtitle = "Manual refresh jungle quest progress",
    Callback = function()
        RefreshJungleQuests()
        print("🔁 Jungle quest list refreshed!")
    end
})

-- 📊 JUNGLE QUEST STATUS SECTION
VyperUI:CreateSection(JungleTab, "Jungle Quest Progress")

-- Overall Progress Label
local jungleOverallLabel = VyperUI:CreateLabel(JungleTab, {
    Title = "🌴 Jungle Progress: 0%",
    Subtitle = "Completed: 0/0 quests"
})

-- Function untuk update overall progress
local function UpdateOverallProgress()
    pcall(function()
        local questData = DataReplion:Get(ElementJungle.ReplionPath)
        if not questData or not questData.Available or not questData.Available.Forever then 
            return 
        end

        local quests = questData.Available.Forever.Quests
        if not quests then return end

        local totalProgress = 0
        local completedQuests = 0

        for _, q in ipairs(quests) do
            local questInfo = QuestUtility:GetQuestData("ElementJungle", "Forever", q.QuestId)
            if questInfo then
                local maxVal = QuestUtility.GetQuestValue(DataReplion, questInfo)
                local progress = math.clamp(q.Progress / maxVal, 0, 1)
                totalProgress = totalProgress + progress
                if progress >= 1 then
                    completedQuests = completedQuests + 1
                end
            end
        end

        local overallPercent = math.floor((totalProgress / #quests) * 100)
        jungleOverallLabel:Set({
            Title = string.format("🌴 Jungle Progress: %d%%", overallPercent),
            Subtitle = string.format("Completed: %d/%d quests", completedQuests, #quests)
        })
    end)
end

-- REAL-TIME TRACKING
DataReplion:OnChange({ElementJungle.Identifier, "Available", "Forever"}, function()
    RefreshJungleQuests()
    UpdateOverallProgress()
end)

-- Initial load
RefreshJungleQuests()
UpdateOverallProgress()

-- Auto refresh setiap 10 detik
spawn(function()
    while true do
        wait(10)
        if #JungleLabels > 0 then
            RefreshJungleQuests()
            UpdateOverallProgress()
        end
    end
end)

print("✅ ELEMENT JUNGLE QUEST TRACKER LOADED!")
-- ===========================
--Fungsi Player
-- ==========================

-- === Player Utilities (WalkSpeed, JumpPower, Fly, Wallhack, Reset) ===
local DEFAULT_WALKSPEED = 16
local DEFAULT_JUMPPOWER = 50

local Settings = {
    WalkSpeed = DEFAULT_WALKSPEED,
    JumpPower = DEFAULT_JUMPPOWER,
    FlyEnabled = false,
    WallhackEnabled = false
}

local Character = nil
local Humanoid = nil
local RootPart = nil

-- Storage for runtime objects
local FlyObjects = {}
local PlayerHighlights = {} -- [player] = HighlightInstance

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Helper: update local reference to character/humanoid/root
local function UpdateCharacterRefs()
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    Humanoid = Character:FindFirstChildOfClass("Humanoid")
    RootPart = Character:FindFirstChild("HumanoidRootPart")
    if Humanoid then
        Humanoid.WalkSpeed = Settings.WalkSpeed or DEFAULT_WALKSPEED
        Humanoid.JumpPower = Settings.JumpPower or DEFAULT_JUMPPOWER
    end
end

-- Ensure refs exist now
pcall(UpdateCharacterRefs)
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.1)
    UpdateCharacterRefs()
    -- reapply wallhack highlight on respawn if enabled
    if Settings.WallhackEnabled then
        task.wait(0.2)
        -- small delay to ensure other chars exist
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                -- recreate highlight if needed
                if plr.Character and not PlayerHighlights[plr] then
                    local success, highlight = pcall(function()
                        local h = Instance.new("Highlight")
                        h.Adornee = plr.Character
                        h.FillTransparency = 0.6
                        h.OutlineTransparency = 0
                        h.Parent = workspace
                        return h
                    end)
                    if success then PlayerHighlights[plr] = highlight end
                end
            end
        end
    end
end)


-- ==========================
--  PLAYER
-- ==========================
VyperUI:CreateSection(PlayerTab, "Player Modifications")


--Anti AFK
--Anti AFK
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

local lastActivityTime = tick()
local heartbeatConnection


VyperUI:CreateToggle(PlayerTab, {
    Title = "Anti-AFK",
    Subtitle = "Universal",
    Callback = function(state)
        AntiAfkEnabled = state

        if state then
            -- Fungsi asli tetap ada
            AntiAfkConnection = Players.LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(), workspace.CurrentCamera.CFrame)
                print("🔥 Delta Anti-AFK Triggered at " .. os.date("%X"))
            end)

            -- Validasi tambahan 1: Heartbeat prevention setiap 10 menit
            heartbeatConnection = RunService.Heartbeat:Connect(function()
                if tick() - lastActivityTime >= 600 then -- 10 menit
                    VirtualUser:CaptureController()
                    VirtualUser:Button1Down(Vector2.new())
                    wait()
                    VirtualUser:Button1Up(Vector2.new())
                    lastActivityTime = tick()
                end
            end)

            -- Validasi tambahan 2: Force activity setiap 15 detik (invisible)
            spawn(function()
                while AntiAfkEnabled do
                    VirtualUser:CaptureController()
                    wait(15)
                end
            end)

            print("🟢 DELTA ANTI-AFK ON")
        else
            if AntiAfkConnection then
                AntiAfkConnection:Disconnect()
            end
            if heartbeatConnection then
                heartbeatConnection:Disconnect()
            end
            print("🔴 DELTA ANTI-AFK OFF")
        end
    end
})



VyperUI:CreateSlider(PlayerTab, {
    Title = "🏃 Walk Speed",
    Subtitle = "Adjust your walking speed",
    Min = 16,
    Max = 200,
    Default = DEFAULT_WALKSPEED,
    Increment = 1,
    Callback = function(value)
        Settings.WalkSpeed = value
        if Humanoid then
            Humanoid.WalkSpeed = value
        end
        print("Walk Speed set to:", value)
    end
})


VyperUI:CreateSlider(PlayerTab, {
    Title = "🦘 Jump Power",
    Subtitle = "Adjust your jump power",
    Min = 50,
    Max = 300,
    Default = DEFAULT_JUMPPOWER,
    Increment = 1,
    Callback = function(value)
        Settings.JumpPower = value
        if Humanoid then
            Humanoid.JumpPower = value
        end
        print("Jump Power set to:", value)
    end
})

-- ========== Fly (Hover) ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

-- Variables
local FlyEnabled = false
local FlySpeed = 50
local FlyConnection = nil
local FlyBV = nil
local FlyBG = nil

-- Detect platform
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- ========== FLY MODE ==========
local function ToggleFly(state)
    FlyEnabled = state
    local character = Player.Character

    if state then
        print("🚁 FLY MODE ON")

        if not character then return end

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")

        if not rootPart then return end

        -- BodyVelocity (movement)
        FlyBV = Instance.new("BodyVelocity")
        FlyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        FlyBV.Velocity = Vector3.zero
        FlyBV.Parent = rootPart

        -- BodyGyro (rotate mengikuti kamera)
        FlyBG = Instance.new("BodyGyro")
        FlyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        FlyBG.P = 9e4
        FlyBG.CFrame = rootPart.CFrame
        FlyBG.Parent = rootPart

        -- Disable collision
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end

        -- Fly loop
        FlyConnection = RunService.Heartbeat:Connect(function()
            if not FlyEnabled or not rootPart then return end

            local camera = workspace.CurrentCamera
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local moveDirection = Vector3.zero

            -------------------------
            -- MOBILE CONTROL FIX --
            -------------------------
            if isMobile then
                local moveVec = Player:GetControls():GetMoveVector()  -- JOYSTICK INPUT MURNI

                if moveVec.Magnitude > 0 then
                    local cam = camera.CFrame
                    local look = cam.LookVector
                    local right = cam.RightVector

                    -- Buat horizontal vector
                    local flatLook = Vector3.new(look.X, 0, look.Z).Unit
                    local flatRight = Vector3.new(right.X, 0, right.Z).Unit

                    -- Rotasi joystick berdasarkan kamera
                    moveDirection = (flatLook * moveVec.Z) + (flatRight * moveVec.X)
                end

            ------------------------
            -- PC CONTROL (WASD) --
            ------------------------
            else
                local camCFrame = camera.CFrame

                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDirection += camCFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDirection -= camCFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDirection -= camCFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDirection += camCFrame.RightVector
                end

                -- Naik / turun
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveDirection += Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    moveDirection -= Vector3.new(0, 1, 0)
                end
            end

            -- Set velocity jika ada gerakan
            if moveDirection.Magnitude > 0 then
                FlyBV.Velocity = moveDirection.Unit * FlySpeed
            else
                FlyBV.Velocity = Vector3.zero
            end

            -- Camera follow
            FlyBG.CFrame = camera.CFrame

            -- Anti-ragdoll
            if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Physics then
                humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            end
        end)

    else
        print("🔴 FLY MODE OFF")

        -- Disconnect loop
        if FlyConnection then
            FlyConnection:Disconnect()
            FlyConnection = nil
        end

        -- Destroy parts
        if FlyBV then FlyBV:Destroy() FlyBV = nil end
        if FlyBG then FlyBG:Destroy() FlyBG = nil end

        -- Enable collision
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- ========== UI ==========
VyperUI:CreateToggle(PlayerTab, {
    Title = "🚁 Fly Mode",
    Subtitle = isMobile and "Mobile Fly (Thumbstick)" or "PC Fly (WASD)",
    Default = false,
    Callback = function(s)
        ToggleFly(s)
    end
})

VyperUI:CreateSlider(PlayerTab, {
    Title = "✈️ Fly Speed",
    Subtitle = "Kecepatan terbang",
    Min = 20,
    Max = 200,
    Default = 50,
    Increment = 10,
    Callback = function(v)
        FlySpeed = v
    end
})

-- Reset kalau respawn
Player.CharacterAdded:Connect(function()
    task.wait(1)
    if FlyEnabled then ToggleFly(false) end
end)



-- ========== Wallhack (Highlight other players) ==========
local function AddHighlightForPlayer(plr)
    if not plr or plr == LocalPlayer then return end
    if PlayerHighlights[plr] and PlayerHighlights[plr].Parent then return end

    local ok, h = pcall(function()
        local highlight = Instance.new("Highlight")
        highlight.Adornee = plr.Character
        highlight.FillColor = Color3.fromRGB(0, 170, 255)
        highlight.FillTransparency = 0.6
        highlight.OutlineColor = Color3.fromRGB(0, 120, 255)
        highlight.OutlineTransparency = 0
        highlight.Parent = workspace
        return highlight
    end)
    if ok then PlayerHighlights[plr] = h end
end

local function RemoveHighlightForPlayer(plr)
    local h = PlayerHighlights[plr]
    if h and h.Parent then
        h:Destroy()
    end
    PlayerHighlights[plr] = nil
end

-- Toggle wallhack
VyperUI:CreateToggle(PlayerTab, {
    Title = "👁️ Wallhack (Player Highlight)",
    Subtitle = "Tampilkan highlight untuk pemain lain (lihat lewat tembok)",
    Default = false,
    Callback = function(state)
        Settings.WallhackEnabled = state
        if state then
            -- add highlight for current players
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    AddHighlightForPlayer(plr)
                end
            end
            -- connect join/leave
            if not PlayerHighlights._JoinedConn then
                PlayerHighlights._JoinedConn = Players.PlayerAdded:Connect(function(plr)
                    task.wait(0.15)
                    if Settings.WallhackEnabled and plr.Character then AddHighlightForPlayer(plr) end
                end)
            end
            if not PlayerHighlights._CharConn then
                PlayerHighlights._CharConn = Players.PlayerAdded:Connect(function(plr)
                    plr.CharacterAdded:Connect(function()
                        task.wait(0.15)
                        if Settings.WallhackEnabled then AddHighlightForPlayer(plr) end
                    end)
                end)
            end
            print("Wallhack ENABLED")
        else
            -- clear highlights
            for plr,h in pairs(PlayerHighlights) do
                if plr ~= "_JoinedConn" and plr ~= "_CharConn" and h and h.Parent then
                    h:Destroy()
                end
            end
            PlayerHighlights = {}
            print("Wallhack DISABLED")
        end
    end
})

-- Keep highlights in sync when characters load/spawn
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        task.wait(0.1)
        if Settings.WallhackEnabled then AddHighlightForPlayer(plr) end
    end)
end)

-- Remove highlight when player leaves
Players.PlayerRemoving:Connect(function(plr)
    RemoveHighlightForPlayer(plr)
end)


-- ========================================
-- PLAYER TAB - HIDE NAME FEATURE
-- ========================================



-- ⚡ ULTIMATE HIDE NAME (FULL INVISIBLE MODE)
local function UltimateHideName()
    local function hideCharacter(char)
        task.defer(function()
            -- ⚡ HAPUS NAMETAG DARI HEAD
            local head = char:WaitForChild("Head", 5)
            if head then
                for _, v in ipairs(head:GetChildren()) do
                    if v:IsA("BillboardGui") then
                        v:Destroy()
                    end
                end
            end

            -- ⚡ HAPUS SEMUA BILLBOARD GUI DI CHARACTER
            for _, descendant in ipairs(char:GetDescendants()) do
                if descendant:IsA("BillboardGui") then
                    descendant:Destroy()  -- Destroy lebih ampuh dari Enabled = false
                end
            end

            -- ⚡ ANTI-RESPAWN PROTECTION (kalo game respawn ulang nametag)
            while char and char.Parent do
                for _, descendant in ipairs(char:GetDescendants()) do
                    if descendant:IsA("BillboardGui") and descendant.Enabled then
                        descendant:Destroy()
                    end
                end
                task.wait(0.5)  -- Check terus setiap 0.5 detik
            end
        end)
    end

    -- ⚡ AUTO-HIDE SETIAP RESPAWN
    Player.CharacterAdded:Connect(hideCharacter)
    
    -- ⚡ JALANKAN SEKARANG JUGA
    if Player.Character then
        hideCharacter(Player.Character)
    end
end

-- Tambah section baru di Player Tab
VyperUI:CreateSection(PlayerTab, "🎭 Hide Name & Identity")

-- 🔹 Toggle Hide Name
VyperUI:CreateToggle(PlayerTab, {
    Title = "👤 Hide Player Name",
    Subtitle = "Sembunyikan nametag dan identitas",
    Default = false,
    Callback = function(state)
        if state then
            print("🟢 HIDE NAME ACTIVATED")
            UltimateHideName()
        else
            print("🔴 HIDE NAME DISABLED")
            -- Note: Once destroyed, nametag biasanya ga balik kecuali respawn
        end
    end
})

-- 🔹 Tombol manual hide name
VyperUI:CreateButton(PlayerTab, {
    Title = "🎭 Hide Name Now",
    Subtitle = "Manual hide nametag (jika toggle ga work)",
    Callback = function()
        UltimateHideName()
        print("✅ Manual hide name executed")
    end
})

-- ========== Reset Button ==========
VyperUI:CreateButton(PlayerTab, {
    Title = "🔁 Reset Player Settings",
    Subtitle = "Reset WalkSpeed, JumpPower, Fly, Wallhack",
    Callback = function()
        -- reset settings
        Settings.WalkSpeed = DEFAULT_WALKSPEED
        Settings.JumpPower = DEFAULT_JUMPPOWER
        Settings.FlyEnabled = false
        Settings.WallhackEnabled = false

        -- apply to humanoid
        UpdateCharacterRefs()
        if Humanoid then
            Humanoid.WalkSpeed = Settings.WalkSpeed
            Humanoid.JumpPower = Settings.JumpPower
        end

        -- stop fly and remove highlights
        StopFly()
        for plr,h in pairs(PlayerHighlights) do
            if plr ~= "_JoinedConn" and plr ~= "_CharConn" and h and h.Parent then
                h:Destroy()
            end
        end
        PlayerHighlights = {}

        print("🔁 Player settings reset to default")
    end
})




-- ========================================
-- AUTO SPAWN TOTEM DENGAN COLLAPSIBLE SECTION
-- Paste code ini ke script lo (bagian AutoTab)
-- ========================================
-- ========================================
-- AUTO SPAWN TOTEM (3D TRIANGLE FORMATION)
-- ========================================

local AutoTotemSection = VyperUI:CreateCollapsibleSection(AutoTab, {
    Title = "Auto Spawn Totem (3D Triangle Formation)",
    DefaultExpanded = false,
})

-- ========================================
-- VARIABLES & SERVICES
-- ========================================
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

local Net = RS.Packages["_Index"]["sleitnick_net@0.2.0"].net
local SpawnTotemRemote = Net["RE/SpawnTotem"]

local SavedSpot = nil
local TotemCount = 9              -- Fixed: 3 layer x 3 totem
local HorizontalRadius = 50       -- Jarak horizontal ke player (buff range)
local VerticalOffset = 100        -- Jarak vertikal antar layer

local HoldConnection = nil        -- Connection untuk hold position

-- ========================================
-- FUNCTIONS
-- ========================================

-----------------------------------------------------
-- SCAN UUID TOTEM DI INVENTORY
-----------------------------------------------------
local function GetTotemUUIDs()
    local Replion = require(RS.Packages.Replion)
    local clientData = Replion.Client:WaitReplion("Data")
    local inv = clientData:Get("Inventory")
    local list = {}

    if inv and inv.Totems then
        for _, item in pairs(inv.Totems) do
            if item and item.UUID then
                table.insert(list, item.UUID)
            end
        end
    end

    return list
end

-----------------------------------------------------
-- SAVE POSISI PLAYER (CENTER POINT)
-----------------------------------------------------
local function SaveSpot()
    local char = Player.Character
    if not char then return end

    local HRP = char:FindFirstChild("HumanoidRootPart")
    if not HRP then return end

    SavedSpot = HRP.CFrame
    print("📍 Spot disimpan:", HRP.Position)
end

-----------------------------------------------------
-- HITUNG POSISI SEGITIGA 3D (3 LAYER)
-----------------------------------------------------
local function GetTrianglePositions()
    if not SavedSpot then return {} end

    local center = SavedSpot.Position
    local positions = {}

    -- 3 sudut segitiga (120° antar totem)
    local angles = {0, 120, 240}

    -- LAYER 1: TENGAH (sejajar player, Y = 0)
    for i, angle in ipairs(angles) do
        local rad = math.rad(angle)
        local x = center.X + HorizontalRadius * math.cos(rad)
        local z = center.Z + HorizontalRadius * math.sin(rad)

        table.insert(positions, {
            Index = i,
            Layer = "MIDDLE",
            Position = Vector3.new(x, center.Y, z),
            Angle = angle
        })
    end

    -- LAYER 2: ATAS (Y + 100)
    for i, angle in ipairs(angles) do
        local rad = math.rad(angle)
        local x = center.X + HorizontalRadius * math.cos(rad)
        local z = center.Z + HorizontalRadius * math.sin(rad)

        table.insert(positions, {
            Index = i + 3,
            Layer = "TOP",
            Position = Vector3.new(x, center.Y + VerticalOffset, z),
            Angle = angle
        })
    end

    -- LAYER 3: BAWAH (Y - 100)
    for i, angle in ipairs(angles) do
        local rad = math.rad(angle)
        local x = center.X + HorizontalRadius * math.cos(rad)
        local z = center.Z + HorizontalRadius * math.sin(rad)

        table.insert(positions, {
            Index = i + 6,
            Layer = "BOTTOM",
            Position = Vector3.new(x, center.Y - VerticalOffset, z),
            Angle = angle
        })
    end

    return positions
end

-----------------------------------------------------
-- HOLD POSITION (ANTI JATUH)
-----------------------------------------------------
local function HoldPosition(targetCFrame)
    local char = Player.Character
    if not char then return end
    local HRP = char:FindFirstChild("HumanoidRootPart")
    if not HRP then return end

    -- Stop previous hold
    if HoldConnection then
        HoldConnection:Disconnect()
        HoldConnection = nil
    end

    -- Loop: force position setiap frame
    HoldConnection = RunService.Heartbeat:Connect(function()
        if HRP then
            HRP.CFrame = targetCFrame
            HRP.Velocity = Vector3.new(0, 0, 0)
            HRP.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
    end)
end

-----------------------------------------------------
-- STOP HOLD POSITION
-----------------------------------------------------
local function StopHold()
    if HoldConnection then
        HoldConnection:Disconnect()
        HoldConnection = nil
        print("✅ Hold position stopped")
    end
end

-----------------------------------------------------
-- PREVIEW FORMASI SEGITIGA 3D
-----------------------------------------------------
local function TeleportPreview()
    if not SavedSpot then
        warn("❌ Save spot dulu!")
        return
    end

    local char = Player.Character
    if not char then return end
    local HRP = char:FindFirstChild("HumanoidRootPart")
    if not HRP then return end

    local positions = GetTrianglePositions()

    print("\n🔍 PREVIEW TRIANGLE 3D FORMATION =====================")
    print("📏 Horizontal Radius:", HorizontalRadius)
    print("📊 Vertical Offset:", VerticalOffset)
    print("🪬 Total Totem:", TotemCount)
    print("======================================================")

    for _, data in ipairs(positions) do
        local pos = data.Position
        print(string.format("[%s] Totem #%d → Angle %d° | (%.1f, %.1f, %.1f)",
            data.Layer, data.Index, data.Angle, pos.X, pos.Y, pos.Z))

        local targetCFrame = CFrame.new(pos)
        
        -- Hold position biar ga jatuh
        HoldPosition(targetCFrame)
        task.wait(1.5)
    end

    -- Stop hold & balik ke saved spot
    StopHold()
    HRP.CFrame = SavedSpot
    print("🏁 Preview selesai!")
end

-----------------------------------------------------
-- AUTO SPAWN TOTEM (TRIANGLE 3D)
-----------------------------------------------------
local function AutoSpawnTotems()
    if not SavedSpot then
        warn("❌ Save spot dulu!")
        return
    end

    local uuids = GetTotemUUIDs()
    if #uuids < TotemCount then
        warn("❌ Totem kurang! Punya:", #uuids, "| Butuh:", TotemCount)
        return
    end

    local char = Player.Character
    if not char then return end
    local HRP = char:FindFirstChild("HumanoidRootPart")
    if not HRP then return end

    local positions = GetTrianglePositions()

    print("\n🚀 AUTO SPAWN TOTEM (3D TRIANGLE) =====================")
    print("📏 Horizontal Radius:", HorizontalRadius)
    print("📊 Vertical Offset:", VerticalOffset)
    print("🪬 Total Totem:", TotemCount)
    print("=======================================================")

    for _, data in ipairs(positions) do
        local pos = data.Position
        local uuid = uuids[data.Index]

        print(string.format("📍 [%s] Teleport #%d (Angle %d°)",
            data.Layer, data.Index, data.Angle))

        local targetCFrame = CFrame.new(pos)
        
        -- Hold position biar ga jatuh (penting buat layer atas/bawah!)
        HoldPosition(targetCFrame)
        task.wait(1.5)

        print("🪬 Spawn Totem #" .. data.Index .. " | UUID: " .. uuid)
        SpawnTotemRemote:FireServer(uuid)
        task.wait(1.5)
    end

    -- Stop hold & balik ke saved spot
    StopHold()
    HRP.CFrame = SavedSpot
    print("🏁 Semua 9 Totem terpasang dalam formasi segitiga 3D!")
end

-- ========================================
-- UI CONTROLS
-- ========================================

-- 📏 Horizontal Radius (Jarak ke player)
VyperUI:CreateNumericInput(AutoTotemSection, {
    Title = "📏 Horizontal Radius",
    Subtitle = "Jarak totem ke player (min 58 buat jarak 100)",
    Min = 50,              -- UPDATED! Min 58 biar jarak antar totem = 100
    Max = 70,              -- Bisa lebih gede kalau mau lebih aman
    Default = 58,          -- UPDATED!
    Increment = 1,
    DecimalPlaces = 0,
    Callback = function(v)
        HorizontalRadius = v
        print("📏 Horizontal Radius ->", v)
    end
})

-- 📊 Vertical Offset (Jarak antar layer)
VyperUI:CreateNumericInput(AutoTotemSection, {
    Title = "📊 Vertical Offset",
    Subtitle = "Jarak vertikal antar layer",
    Min = 80,
    Max = 120,
    Default = VerticalOffset,
    Increment = 10,
    DecimalPlaces = 0,
    Callback = function(v)
        VerticalOffset = v
        print("📊 Vertical Offset ->", v)
    end
})

-- 📍 Save spot
VyperUI:CreateButton(AutoTotemSection, {
    Title = "📍 Save Spot",
    Subtitle = "Lokasi pusat formasi",
    Callback = SaveSpot
})

-- 🔍 Preview
VyperUI:CreateButton(AutoTotemSection, {
    Title = "🔍 Preview Formation",
    Subtitle = "Cek posisi 9 totem (3 layer)",
    Callback = TeleportPreview
})

-- 🪬 Auto Spawn
VyperUI:CreateButton(AutoTotemSection, {
    Title = "🪬 AUTO SPAWN 9 TOTEM",
    Subtitle = "Triangle 3D Formation",
    Callback = AutoSpawnTotems
})

print("✅ AUTO TOTEM 3D TRIANGLE FORMATION LOADED!")
-- ========================================



