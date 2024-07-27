local BanAPI = {}
local banDataStore = game:GetService("DataStoreService"):GetDataStore("BanDataStore")
local caseIDStore = game:GetService("DataStoreService"):GetDataStore("CaseIDStore")
local caseCounterStore = game:GetService("DataStoreService"):GetDataStore("CaseCounterStore")

local function getNextCaseID()
    local success, caseID = pcall(function()
        return caseCounterStore:UpdateAsync("LastCaseID", function(lastCaseID)
            lastCaseID = lastCaseID or 0
            return lastCaseID + 1
        end)
    end)
    if success then
        return caseID
    else
        warn("Failed to get next case ID: " .. tostring(caseID))
        return nil
    end
end

function BanAPI.BanUser(Player, Reason)
    local caseID = getNextCaseID()
    if not caseID then
        return nil
    end
    local playerId = Player.UserId
    local banInfo = {
        Player = Player.Name,
        CaseID = caseID,
        Reason = Reason,
        Banstatus = "Active"
    }
    banDataStore:SetAsync(tostring(playerId), banInfo)
    caseIDStore:SetAsync(tostring(caseID), banInfo)
    return caseID
end

function BanAPI.UnBanUser(PlayerID)
    local banInfo = banDataStore:GetAsync(tostring(PlayerID))
    if banInfo then
        banInfo.Banstatus = "Resolved"
        banDataStore:SetAsync(tostring(PlayerID), banInfo)
        caseIDStore:SetAsync(tostring(banInfo.CaseID), banInfo)
    end
end

function BanAPI.Check(Player)
    local playerId = Player.UserId
    local banInfo = banDataStore:GetAsync(tostring(playerId))
    if banInfo and banInfo.Banstatus == "Active" then
        Player:Kick("You are banned. Reason: " .. banInfo.Reason)
    end
end

function BanAPI.CaseCheck(caseID)
    local caseInfo = caseIDStore:GetAsync(tostring(caseID))
    if caseInfo then
        return caseInfo
    end
end

return BanAPI
