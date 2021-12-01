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
local f = CreateFrame("frame")
f:SetScript("OnEvent", InsertKeystone)
f:RegisterEvent("CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN")
