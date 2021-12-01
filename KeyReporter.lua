local _, namespace = ...
local L = namespace.L

-- incoming chat event name -> channel to respond in
local eventToChannel = {
    -- uncomment for testing
    -- CHAT_MSG_SAY = "EMOTE", -- This addon cannot send to SAY

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

    local covenantSuffix = ""
    local covenantID = C_Covenants.GetActiveCovenantID()
    if covenantID ~= 0 then
        local covenantName = C_Covenants.GetCovenantData(covenantID)['name']
        covenantSuffix = " (" .. covenantName .. ")"
    end

    if not mapID then
        return L["I have no key."]
    end

    return "" .. C_ChallengeMode.GetMapUIInfo(mapID) .. " " .. C_MythicPlus.GetOwnedKeystoneLevel() .. covenantSuffix
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

local function FindKeystone()
    for container = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
        for slot = 1, GetContainerNumSlots(container) do
            local _, _, _, _, _, _, slotLink, _, _, slotItemID = GetContainerItemInfo(container, slot)
            if slotLink and slotLink:match("|Hkeystone:") then
                return container, slot
            end
        end
    end
end

local function InsertKeystone()
    local container, slot = FindKeystone()
    if not container then
        return
    end

    PickupContainerItem(container, slot)
    if (CursorHasItem()) then
        C_ChallengeMode.SlotKeystone()
    end
end

-- invisible frame for updating/hooking events
local i = CreateFrame("frame")
i:SetScript("OnEvent", InsertKeystone)
i:RegisterEvent("CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN")
