local function debugPrint(message)
    if _G.Debug then
        print("[Debug] " .. message)
    end
end

local mapImages = {
    ["Blade Works"] = "https://static.wikia.nocookie.net/tdx/images/9/9b/Blade_Works.png",
    ["Deserted Island"] = "https://static.wikia.nocookie.net/tdx/images/9/98/Deserted_Island_Preview.png",
    ["Dead End Valley"] = "https://static.wikia.nocookie.net/tdx/images/b/ba/DeadEndValley.png",
    ["Misleading Pond"] = "https://static.wikia.nocookie.net/tdx/images/b/bc/Misleading_Pond_Map.png",
    ["Obscure Island"] = "https://static.wikia.nocookie.net/tdx/images/1/1f/Obscure_island_map.png",
    ["Scorched Passage"] = "https://static.wikia.nocookie.net/tdx/images/0/0b/Scorched_Passage.png",
    ["SFOTH"] = "https://static.wikia.nocookie.net/tdx/images/d/dd/Sfoth.png",
    ["Sorrows Harbor"] = "https://static.wikia.nocookie.net/tdx/images/5/58/SorrowsHarborIcon.png",
    ["Unforgiving Winter"] = "https://static.wikia.nocookie.net/tdx/images/4/43/Unforgiving_Winter_map.png",
    ["Volcanic Mishap"] = "https://static.wikia.nocookie.net/tdx/images/d/d8/Volcanomishap.png",
    ["Winter Fort"] = "https://static.wikia.nocookie.net/tdx/images/a/a6/Winter_Fort.png",
    ["Western"] = "https://static.wikia.nocookie.net/tdx/images/9/95/Western.png",
    ["Borderlands"] = "https://static.wikia.nocookie.net/tdx/images/0/09/Borderlands.png",
    ["Military HQ"] = "https://static.wikia.nocookie.net/tdx/images/f/fb/MilitaryHQ.png",
    ["Pond"] = "https://static.wikia.nocookie.net/tdx/images/1/10/Pond.png",
    ["Grasslands"] = "https://static.wikia.nocookie.net/tdx/images/6/6c/Grasslands.png",
    ["Santa's Stronghold"] = "https://static.wikia.nocookie.net/tdx/images/4/44/SantasStrongholdIcon.png",
    ["Assembly Line"] = "https://static.wikia.nocookie.net/tdx/images/0/08/Assembly_Line.png",
    ["Chalet"] = "https://static.wikia.nocookie.net/tdx/images/f/f7/Chalet.png",
    ["Cow Annoyance"] = "https://static.wikia.nocookie.net/tdx/images/0/03/CowAnnoyanceIcon.png",
    ["Blox Out"] = "https://static.wikia.nocookie.net/tdx/images/2/2a/Blox_Island.png",
    ["Limbo"] = "https://static.wikia.nocookie.net/tdx/images/b/bc/Limbo.png",
    ["Military Harbor"] = "https://static.wikia.nocookie.net/tdx/images/2/21/Military_harbour.png",
    ["Purgatory"] = "https://static.wikia.nocookie.net/tdx/images/d/d3/Purgatory.png",
    ["Secret Forest"] = "https://static.wikia.nocookie.net/tdx/images/a/a2/Secretforest.png",
    ["Vapor City"] = "https://static.wikia.nocookie.net/tdx/images/8/87/Vapor_Downtown.png",
    ["Vinland"] = "https://static.wikia.nocookie.net/tdx/images/c/cd/Vinland.png",
    ["Ancient Sky Island"] = "https://static.wikia.nocookie.net/tdx/images/8/8a/AncientSkyIslandIcon.png",
    ["Apocalypse"] = "https://static.wikia.nocookie.net/tdx/images/6/6b/ApocalypseIcon.png",
    ["Moon Outpost"] = "https://static.wikia.nocookie.net/tdx/images/9/95/Moon_Outpost_img.png",
    ["Singularity"] = "https://static.wikia.nocookie.net/tdx/images/d/d0/Singularity.png",
    ["Treasure Cove"] = "https://static.wikia.nocookie.net/tdx/images/8/8a/TreasureCoveBig.png",
    ["Fort Summit"] = "https://static.wikia.nocookie.net/tdx/images/9/96/FortSummit.png",
    ["Oil Rig"] = "https://static.wikia.nocookie.net/tdx/images/b/bd/OilRigIcon.png",
    ["Research Base"] = "https://static.wikia.nocookie.net/tdx/images/1/18/Research_Base.png",
    ["Highrise"] = "https://static.wikia.nocookie.net/tdx/images/8/85/HighriseIcon.png"
}
local defaultImageUrl = "https://tr.rbxcdn.com/421a8d5168e96328405673beadab22ce/768/432/Image/Png"

repeat
    task.wait()
until game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui") and
      game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Interface") and
      game:GetService("Players").LocalPlayer.PlayerGui.Interface:FindFirstChild("GameOverScreen")
debugPrint("GameOverScreen Found")

local request = request or http_request or syn.request or HttpPost
local Players = game:GetService("Players").LocalPlayer
local Interface = Players.PlayerGui.Interface
local GameOverScreen = Interface.GameOverScreen
debugPrint("Wait for the game to end")

local function getEmbedColor()
    if GameOverScreen.Main.VictoryText.Visible then
        debugPrint("Victory detected")
        return 0x15d415
    elseif GameOverScreen.Main.DefeatText.Visible then
        debugPrint("Defeat detected")
        return 0xd41515
    else
        return 0x424c51
    end
end

local mapImagesUpper = {}
for key, value in pairs(mapImages) do
    mapImagesUpper[key:upper()] = value
end

local function getMapImageUrl(mapName)
    local url = mapImagesUpper[mapName] or defaultImageUrl
    debugPrint("Map image URL for " .. mapName .. ": " .. url)
    return url
end

local function SendMessageEMBED(url, embed)
    local http = game:GetService("HttpService")
    local headers = {
        ["Content-Type"] = "application/json"
    }
    local data = {
        ["embeds"] = {embed}
    }
    local body = http:JSONEncode(data)
    local success, err = pcall(function()
        request({
            Url = url,
            Method = "POST",
            Headers = headers,
            Body = body
        })
    end)

    if success then
        debugPrint("Webhook sent successfully")
    else
        warn("[Webhook] request failed: " .. tostring(err))
    end
end

local function sendWebhook()
    local mapImageUrl = getMapImageUrl(GameOverScreen.Main.InfoFrame.Map.Text)
    local TitleMsg
    local fields = {
        {name = "**XP:**", value = GameOverScreen.Main.RewardsFrame.InnerFrame.XP.TextLabel.Text, inline = true},
        {name = "**Gold:**", value = GameOverScreen.Main.RewardsFrame.InnerFrame.Gold.TextLabel.Text, inline = true}
    }

    local powerUpsContainer = GameOverScreen.Rewards.Content:FindFirstChild("PowerUps1")
    
    if powerUpsContainer and #powerUpsContainer.Items:GetChildren() > 0 then
        TitleMsg = "**You triumphed!**"
        debugPrint("Victory detected, adding reward fields")
        for _, drop in pairs(powerUpsContainer.Items:GetChildren()) do
            if drop:IsA("Frame") and drop.Name ~= "ItemTemplate" then
                table.insert(fields, {name = "**" .. drop.NameText.Text .. ":**", value = drop.CountText.Text, inline = true})
            end
        end
    else
        TitleMsg = "**Better luck next time!**"
    end

    debugPrint("Title message: " .. TitleMsg)

    local embed = {
        author = {
            name = "Tower Defense X  |  Notification system",
            icon_url = "https://i.imgur.com/aPNN9Lp.png"
        },
        title = "**Player: ||" .. Players.Name .. "||**  |  " .. TitleMsg,
        description = string.format(
            "**Map:** %s\n**Mode:** %s\n**Time:** %s\n**Wave:** %s",
            GameOverScreen.Main.InfoFrame.Map.Text,
            GameOverScreen.Main.InfoFrame.Mode.Text,
            GameOverScreen.Main.InfoFrame.Time.Text,
            (Interface.GameInfoBar.Wave.WaveText.Text):match("%d+")
        ),
        color = getEmbedColor(),
        fields = fields,
        image = {
            url = mapImageUrl
        },
        thumbnail = {
            url = "https://i.imgur.com/MWxktrO.png"
        },
        footer = {
            text = "By SploeCyber - TDX IS GOAT!",
            icon_url = "https://i.imgur.com/prXYlyH.png"
        },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ", os.time())
    }    
    
    debugPrint("Sending webhook")
    SendMessageEMBED(_G.Webhook, embed)

    if _G.returnLobby then
        game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RequestTeleportToLobby"):FireServer()
        debugPrint("Taking you back to the lobby.")
    end
end


GameOverScreen:GetPropertyChangedSignal("Visible"):Connect(function()
    debugPrint("GameOverScreen visibility changed")
    task.spawn(sendWebhook)
end)
