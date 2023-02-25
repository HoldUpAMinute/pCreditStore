PIXEL.RegisterFont("font22", "Roboto Medium", 22)
local PANEL = {}
AccessorFunc(PANEL, "Title", "Title", FORCE_STRING)

function PANEL:Init()
    self.headerH, self.spacing = PIXEL.Scale(30), PIXEL.Scale(6)
    self:DockPadding(0, self.headerH, 0, 0)
    self.ScrollPanel = self:Add("PIXEL.ScrollPanel")
    self.ScrollPanel:Dock(FILL)

    for k, v in pairs(pCreditStore.config.Items) do
        if v.type == "entities" then
            self:AddEnt(k, v)
        end
    end
end

function PANEL:PerformLayout(w, h)
    if IsValid(self.CloseButton) then
        local btnSize = self.headerH * .45
        self.CloseButton:SetSize(btnSize, btnSize)
        self.CloseButton:SetPos(w - btnSize - self.spacing, (self.headerH - btnSize) / 2)
    end
end

function PANEL:AddEnt(k, v)
    players = self.ScrollPanel:Add("pCreditSys_IFrame")
    players:DockMargin(0.5, 0.5, 0.5, 0.5)
    players:Dock(TOP)
    players:SetTall(ScrH() * 0.09)

    players.Paint = function(self2, w, h)
        PIXEL.DrawRoundedBox(20, 5, 5, w * .975, h * 1, Color(28, 28, 28))
        PIXEL.DrawSimpleText(v.name or "nil", "font22", w * 0.65, h * 0.3, Color(255, 255, 255), nil, TEXT_ALIGN_CENTER)
    end

    local button = vgui.Create("PIXEL.TextButton", players)
    button:SetText("Purchase")
    button:SetPos(ScrW() * 0.125, ScrH() * 0.05)
    button:SetFont("font22")

    button.DoClick = function()
        net.Start("pCreditStore:PurchaseItem")
        print(k)
        net.WriteInt( k, 32 )
        net.SendToServer()
    end

    local imgur = vgui.Create("PIXEL.ImgurButton", players)
    imgur:SetPos(ScrW() * 0, ScrH() * 0.00010)
    imgur:SetSize(ScrW() * 0.125, ScrH() * 0.1)
    imgur:SetImgurID(v.imgur)
end

function PANEL:Paint(w, h)
    PIXEL.DrawRoundedBox(self.spacing, 0, 0, w, h, Color(20, 20, 22))
end

vgui.Register("pCreditSys_Entities", PANEL, "EditablePanel")