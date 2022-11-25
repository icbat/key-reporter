local _, namespace = ...
local L = namespace.L

-- incoming chat event name -> channel to respond in
local eventToChannel = {
    -- uncomment for testing
    -- CHAT_MSG_SAY = "EMOTE", -- This addon cannot send to SAY, but it can listen for it

    CHAT_MSG_GUILD = "GUILD",
    CHAT_MSG_PARTY = "PARTY",
    CHAT_MSG_PARTY_LEADER = "PARTY",
    CHAT_MSG_RAID = "RAID",
    CHAT_MSG_RAID_LEADER = "RAID",
    CHAT_MSG_INSTANCE_CHAT = "INSTANCE_CHAT",
    CHAT_MSG_INSTANCE_CHAT_LEADER = "INSTANCE_CHAT"
}

local function BuildMessage()
    local mapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID()

    if not mapID then
        return L["I have no key."]
    end

    return "" .. C_ChallengeMode.GetMapUIInfo(mapID) .. " " .. C_MythicPlus.GetOwnedKeystoneLevel()
end

local function LookForChatCommand(self, event, text)
    if text ~= "!keys" then
        return
    end
    SendChatMessage(BuildMessage(), eventToChannel[event])
end

-- invisible frame for updating/hooking events
local f = CreateFrame("frame")

f:SetScript("OnEvent", LookForChatCommand)

table.foreach(eventToChannel, function(eventName)
    f:RegisterEvent(eventName)
end)
