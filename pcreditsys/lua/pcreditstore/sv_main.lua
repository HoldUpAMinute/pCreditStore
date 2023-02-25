pCreditStore = pCreditStore or {}
pCreditStore.main = {}
pCredits = pCredits or {}
local banner = [[
=========================================
==                                     ==
==                                     ==
==             Version 2               ==
==      pCreditStore Loaded            ==
==    Created By YoWaitAMinute#6897    ==
==                                     ==
==                                     ==
==                                     ==
=========================================
]]
print(banner)


// hook.Add("PlayerInitialSpawn", "pCreditStore:LoadPlayerData", function(ply)
//     timer.Simple(2, function()
//         pCreditStore:LoadUserData(ply)
//     end)
// end)

concommand.Add("pcredits_addpcredits", function(ply, args)
    pCreditStore:GivePlayerTokens(ply, tonumber(args[1]))
end)

concommand.Add("getplytokens", function(ply, args)
ply:ChatPrint("Player Has " .. pCreditStore:GetPlayerTokens(ply) .. " Tokens")
end)

hook.Add("PlayerSay", "pCreditStore:ChatCommansds", function(ply, text)
    if text == "!tokens" then
        ply:ChatPrint("You Have " .. math.Round(pCreditStore:GetPlayerTokens(ply)) .. " Tokens")
    end
end)
// hook.Add("PlayerSay", "pCreditStore:ChatCosmmanssds", function(ply, text)
//     if text == "!settokens" then
//         ply:ChatPrint("You Have " .. math.Round(pCreditStore:GetPlayerTokens(ply)) .. " Tokens")
//     end
// end)

util.AddNetworkString("pCreditStore:PurchaseItem")
util.AddNetworkString("pCreditStore:OpenMenu")
net.Receive("pCreditStore:PurchaseItem", function(_, ply)
    local item = net.ReadInt(32)
    local tokens = pCreditStore:GetPlayerTokens(ply)

    for k, v in pairs(pCreditStore.config.Items) do
        if item == k then
            price = v.price
            class = v.class
            name = v.name
            type = v.type
        end
    end

    if type == "weapon" then
        if ply:HasWeapon(class) then
            ply:ChatPrint("You Already Own " .. name)

            return
        end

        if tokens >= price then
            pCreditStore:TakePlayerTokens(ply, price)
            ply:ChatPrint("You Have Purchased " .. name .. " For " .. price .. " Tokens")
            pCreditStore:AddPermamentWeapon(ply, class)
        else
            ply:ChatPrint("You Do Not Have Enough Tokens To Purchase " .. item)
        end
    end
    if type == "entities" then
        if tokens >= price then
            pCreditStore:TakePlayerTokens(ply, price)
            ply:ChatPrint("You Have Purchased " .. name .. " For " .. price .. " Tokens")
            local ent = ents.Create(class)
            ent:SetPos(ply:GetPos())
            ent:Spawn()
        else
            ply:ChatPrint("You Do Not Have Enough Tokens To Purchase " .. item)
        end
    end
end)
util.AddNetworkString("pCreditSys_ConvertMoney")
util.AddNetworkString("pCreditStore:OpenStore")
net.Receive("pCreditSys_ConvertMoney", function(_, ply)
    local amount = net.ReadInt(32)
    local tokens = pCreditStore:GetPlayerTokens(ply)
    local money = ply:getDarkRPVar("money")
    if amount <= money then
        ply:addMoney(-amount)
        pCreditStore:GivePlayerTokens(ply, math.Round(money / 1000000))
        ply:ChatPrint("You Have Converted " .. math.Round(money / 1000000) .. " Tokens")
    else
        ply:ChatPrint("You Do Not Have Enough Money To Convert")
    end
end)


concommand.Add("pcredits_addpcredits", function(ply, args)
    pCreditStore:GivePlayerTokens(player.GetBySteamID(args[1]), tonumber(args[2]))
end)
concommand.Add("pcredits_takepcredits", function(ply, args)
    pCreditStore:TakePlayerTokens(player.GetBySteamID(args[1]), tonumber(args[2]))
end)

hook.Add("PlayerSay", "pCreditStore:CssssssshatCommands", function(ply, text)
    if text == "/store" then
       ply:ConCommand("screditstore")
    end
end)
concommand.Add("pcredits_refreshpermweps", function(ply, args)
    pCreditStore:GivePermamentWeapon(ply)
end)
hook.Add("PlayerInitialSpawn", "pCreditStore:LoadPlayerData", function(ply)
    timer.Simple(2, function()
        pCreditStore:LoadUserData(ply)
    end)
    pCreditStore:GetPermWeapons(ply)
    timer.Simple(5, function()
     ply:ConCommand("pcredits_refreshpermweps")
    end)
end)

hook.Add("PlayerDeath", "pCreditStore:GivePlayerTokens", function(ply)
    timer.Simple(6, function()
        ply:ConCommand("pcredits_refreshpermweps")
    end)
end)
