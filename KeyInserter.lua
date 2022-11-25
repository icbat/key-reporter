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

local function InsertKeystone()
    local container, slot = FindKeystone()
    if not container then
        return
    end

    C_Container.PickupContainerItem(container, slot)
    if (CursorHasItem()) then
        C_ChallengeMode.SlotKeystone()
    end
end

-- invisible frame for updating/hooking events
local f = CreateFrame("frame")
f:SetScript("OnEvent", InsertKeystone)
f:RegisterEvent("CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN")
