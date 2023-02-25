pCreditStore = pCreditStore or {}
pCreditStore.config = pCreditStore.config or {}
pCredits = pCredits or {}
pPermWeapons = pPermWeapons or {}
function pCreditStore:GetPlayerTokens(ply)
    for k, v in pairs(pCredits.Data) do
        if k == ply:SteamID() then return math.Round(v) end
    end
end

function pCreditStore:GivePlayerTokens(ply, amount)
    for k, v in pairs(pCredits.Data) do
        if k == ply:SteamID() then
            pCredits.Data[k] = v + tonumber(amount)
        end
    end

    file.Write("pcreditstore/credits.txt", util.TableToJSON(pCredits.Data))
end

function pCreditStore:TakePlayerTokens(ply, amount)
    for k, v in pairs(pCredits.Data) do
        if k == ply:SteamID() then
            pCredits.Data[k] = v - tonumber(amount)
        end
    end

    file.Write("pcreditstore/credits.txt", util.TableToJSON(pCredits.Data))
end

function pCreditStore:GetRankBonus(ply)
    local rank = ply:GetUserGroup()

    if pCreditStore.config.RankBonus[rank] then
        return pCreditStore.config.RankBonus[rank]
    else
        return pCreditStore.config.RankBonus["user"]
    end
end

function pCreditStore:LoadUserData(ply)
    local data = {}

    if not file.Exists("pcreditstore/credits.txt", "DATA") then
        data[ply:SteamID()] = 0
        file.Write("pcreditstore/credits.txt", util.TableToJSON(data))
    else
        data = file.Read("pcreditstore/credits.txt", "DATA")
        data = util.JSONToTable(data)

        if not data[ply:SteamID()] then
            data[ply:SteamID()] = 0
            pCredits.Data = data
            file.Write("pcreditstore/credits.txt", util.TableToJSON(data))
        else
            pCredits.Data = data
        end
    end
end

function pCreditStore:AddPermamentWeapon(ply, class)
    data = {}

    if file.Exists("pcreditstore/" .. ply:SteamID64() .. ".txt", "DATA") then
        data = file.Read("pcreditstore/" .. ply:SteamID64() .. ".txt", "DATA")
        data = util.JSONToTable(data)
    end

    table.insert(ply.pPermWeapons, class)
    

    file.Write("pcreditstore/" .. ply:SteamID64() .. ".txt", util.TableToJSON(ply.pPermWeapons))
    ply:Give(class)
end

function pCreditStore:GetPermWeapons(ply)
    data = {}

    if file.Exists("pcreditstore/" .. ply:SteamID64() .. ".txt", "DATA") then
        data = file.Read("pcreditstore/" .. ply:SteamID64() .. ".txt", "DATA")
        data = util.JSONToTable(data)
    end
    ply.pPermWeapons = data
end

function pCreditStore:GivePermamentWeapon(ply)
    if file.Exists("pcreditstore/" .. ply:SteamID64() .. ".txt", "DATA") then
        data = file.Read("pcreditstore/" .. ply:SteamID64() .. ".txt", "DATA")
        data = util.JSONToTable(data)
    end
    for k,v in pairs(data) do
        ply:Give(v)
        ply:SelectWeapon(v)
    end
end