PIXEL.RegisterFont("font22", "Roboto Medium", 22)
local PANEL = {}
AccessorFunc(PANEL, "Title", "Title", FORCE_STRING)

function PANEL:Init()
    self.headerH, self.spacing = PIXEL.Scale(30), PIXEL.Scale(6)
    self:DockPadding(0, self.headerH, 0, 0)
    self.ScrollPanel = self:Add("PIXEL.ScrollPanel")
    self.ScrollPanel:Dock(FILL)

    local convertmoney = self.ScrollPanel:Add("PIXEL.TextEntry")
    convertmoney:SetPlaceholderText("Enter amount of money to convert")
    convertmoney:Dock(TOP)
    convertmoney:DockMargin(0, 0, 0, 10)
    convertmoney:SetNumeric(true)
    convertmoney:SetUpdateOnType(true)
    convertmoney:SetTall(PIXEL.Scale(30))
    convertmoney.OnEnter = function(self, value)
        self.headerH, self.spacing = PIXEL.Scale(30), PIXEL.Scale(6)
        local variable = self:GetValue()
        print(variable)
        local frame = vgui.Create("pCreditSys_IFrame")
        frame:SetSize(PIXEL.Scale(300), PIXEL.Scale(150))
        frame:Center()
        frame:SetTitle("Convert Money")
        frame:MakePopup()
        frame.Paint = function(self2, w, h)
        PIXEL.DrawSimpleText("Would you like to convert" .. DarkRP.formatMoney(tonumber(variable)) .. " Into Tokens?", "font22", 0 + self.spacing, self.headerH / 2, color_white, nil, TEXT_ALIGN_CENTER)
        end
        local yes = vgui.Create("PIXEL.TextButton", frame)
        yes:SetSize(100, 50)
        yes:SetPos(ScrW() * 0, ScrH() * 0.05)
        yes:DockMargin(0, 0, 0, 0)
        yes:SetText("Yes")
        yes.DoClick = function()
            net.Start("pCreditSys_ConvertMoney")
            net.WriteInt(variable, 32)
            net.SendToServer()
            frame:Remove()
        end
        local no = frame:Add("PIXEL.TextButton", frame)
        no:SetSize(100, 50)
        no:SetPos(ScrW() * 0.1, ScrH() * 0.05)
        no:DockMargin(0, 0, 0, 0)
        no:SetText("No")
        no.DoClick = function()
            frame:Remove()
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


function PANEL:Paint(w, h)
    PIXEL.DrawRoundedBox(self.spacing, 0, 0, w, h, Color(20, 20, 22))
end

vgui.Register("pCreditSys_ConvertSystem", PANEL, "EditablePanel")