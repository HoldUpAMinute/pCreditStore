PIXEL.RegisterFont("font22", "Roboto Medium", 22)
local PANEL = {}
AccessorFunc(PANEL, "Title", "Title", FORCE_STRING)

function PANEL:Init()
    self.headerH, self.spacing = PIXEL.Scale(30), PIXEL.Scale(6)
    self:DockPadding(0, self.headerH, 0, 0)
    self.Navbar = self:Add("PIXEL.Navbar")
    self.Navbar:Dock(TOP) -- self:AddItem(id, name, imgurID, doClick, order)
    self.Navbar:SetTall(PIXEL.Scale(40))
    self.Navbar:SetWide(PIXEL.Scale(ScrW() * .075))

//    self.Navbar:AddItem("Home", "Home", "7vnMDZ4", function()
//        self:ChangeTab("pAdminSuite_Home")
//    end, "2")

    self.Navbar:AddItem("homes", "Weapons", function() self:ChangeTab("pCreditSys_Items") end)
    self.Navbar:AddItem("home", "Entites", function() self:ChangeTab("pCreditSys_Entities") end)
    self.Navbar:AddItem("ssssz", "Convert", function() self:ChangeTab("pCreditSys_ConvertSystem") end)

    // self.Navbar:AddItem("Home", "Warnings", "DqQDXY0", function() self:ChangeTab("pAdminSuite_WarnLogs") end, "4")
    --    self.Navbar:AddItem("Config", "Config", function() self:ChangeTab("White_Config") end)
    self.CloseButton = vgui.Create("PIXEL.ImgurButton", self)
    self.CloseButton:SetImgurID("z1uAU0b")
    self.CloseButton:SetNormalColor(PIXEL.Colors.PrimaryText)
    self.CloseButton:SetHoverColor(PIXEL.Colors.Negative)
    self.CloseButton:SetClickColor(PIXEL.Colors.Negative)
    self.CloseButton:SetDisabledColor(PIXEL.Colors.DisabledText)

    self.CloseButton.DoClick = function(s)
        self:Remove()
    end
end
function PANEL:PerformLayout(w, h)
    if IsValid(self.CloseButton) then
        local btnSize = self.headerH * .45
        self.CloseButton:SetSize(btnSize, btnSize)
        self.CloseButton:SetPos(w - btnSize - self.spacing, (self.headerH - btnSize) / 2)
    end
end

function PANEL:Paint(w, h)
    PIXEL.DrawRoundedBox(self.spacing, 0, 0, w, h, Color(20, 20, 22))
    PIXEL.DrawSimpleText("Simply Roleplay!", "font22", 0 + self.spacing, self.headerH / 2, color_white, nil, TEXT_ALIGN_CENTER)
end

function PANEL:ChangeTab(pnl)
    if IsValid(self.ContentPanel) then
        self.ContentPanel:Remove()
    end

    self.ContentPanel = self:Add(pnl)
    self.ContentPanel:Dock(FILL)
end
vgui.Register("pCreditSys_Frame", PANEL, "EditablePanel")

function openstore()
    local pCreditStore = vgui.Create("pCreditSys_Frame")
    pCreditStore:SetTitle("Simply Roleplay!")
    pCreditStore:SetSize(375, 600)
    pCreditStore:Center()
    pCreditStore:MakePopup()
    local panel = pCreditStore:Add("pCreditSys_Items")
    panel:Dock(FILL)
end

net.Receive("pCreditSys_OpenStore", function()
    openstore()
end)

concommand.Add("screditstore", function()
    local pCreditStore = vgui.Create("pCreditSys_Frame")
    pCreditStore:SetTitle("Simply Roleplay!")
    pCreditStore:SetSize(375, 600)
    pCreditStore:Center()
    pCreditStore:MakePopup()
    local panel = pCreditStore:Add("pCreditSys_Items")
    panel:Dock(FILL)
end)