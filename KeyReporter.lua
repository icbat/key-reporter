local _, namespace = ...
local L = namespace.L

-- Alternate testing method
-- print(BuildMessage())

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

local function FindKeystone()
    for container = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
        for slot = 1, C_Container.GetContainerNumSlots(container) do
            local itemInfo = C_Container.GetContainerItemInfo(container, slot)

            if itemInfo and itemInfo["hyperlink"]:match("|Hkeystone:") then
                return container, slot
            end
        end
    end
end

local function BuildMessage()
    local container, slot = FindKeystone()

    if not container then
        return L["I have no key."]
    end

    return C_Container.GetContainerItemLink(container, slot)
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
