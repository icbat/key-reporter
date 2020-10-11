local eventChannelMap = {
    -- uncomment for testing
    -- CHAT_MSG_SAY = "EMOTE", -- This addon cannot send to SAY
    CHAT_MSG_GUILD = "GUILD",
    CHAT_MSG_PARTY = "PARTY",
    CHAT_MSG_PARTY_LEADER = "PARTY",
    CHAT_MSG_RAID = "RAID",
    CHAT_MSG_RAID_LEADER = "RAID",
    CHAT_MSG_INSTANCE_CHAT = "INSTANCE_CHAT",
    CHAT_MSG_INSTANCE_CHAT_LEADER = "INSTANCE_CHAT",
}

local function BuildMessage()
    if C_MythicPlus.IsWeeklyRewardAvailable() then 
        return "I need to open my chest!"
    end

    local mapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID()

    if not mapID then 
        return "I have no key"
    end

    return "" .. C_ChallengeMode.GetMapUIInfo(mapID) .. " " .. C_MythicPlus.GetOwnedKeystoneLevel()
end

local function LookForChatCommand(self, event, text)
    if text ~= "!keys" then return end
    assert(eventChannelMap[event], "Unexpected event:  " .. event .. ". Please alert addon author via GitHub")
    SendChatMessage(BuildMessage(), eventChannelMap[event])
end


-- invisible frame for updating/hooking events
local f = CreateFrame("frame")

f:SetScript("OnEvent", LookForChatCommand)

-- real events
f:RegisterEvent("CHAT_MSG_GUILD")

f:RegisterEvent("CHAT_MSG_PARTY")
f:RegisterEvent("CHAT_MSG_PARTY_LEADER")

f:RegisterEvent("CHAT_MSG_RAID")
f:RegisterEvent("CHAT_MSG_RAID_LEADER")

f:RegisterEvent("CHAT_MSG_INSTANCE_CHAT")
f:RegisterEvent("CHAT_MSG_INSTANCE_CHAT_LEADER")
