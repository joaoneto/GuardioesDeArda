ButtonShortcut = class(Turbine.UI.Control);

function ButtonShortcut:Constructor()
    Turbine.UI.Control.Constructor(self);

    self.enabled = true;

    self.quickslot = Turbine.UI.Lotro.Quickslot();
    self.quickslot:SetParent(self);
    self.quickslot:SetAllowDrop(false);
    self.quickslot:SetZOrder(1);

    self.shortcut = Turbine.UI.Lotro.Shortcut(Turbine.UI.Lotro.ShortcutType.Alias, "");

    self.label = Turbine.UI.Label();
    self.label:SetParent(self);
    self.label:SetForeColor(Turbine.UI.Color.Yellow);
    self.label:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
    self.label:SetFontStyle(Turbine.UI.FontStyle.Outline);
    self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    self.label:SetMouseVisible(false);
    self.label:SetZOrder(2);
    self.label:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    self.label:SetBackground("GuardioesDeArda/Lupa/Resources/button.tga");
    self.label:SetBackColorBlendMode(Turbine.UI.BlendMode.Color);

    self.quickslot.MouseEnter = function()
        if (self.enabled) then
            self.label:SetForeColor(Turbine.UI.Color.White);
            self.label:SetBackColor(Turbine.UI.Color(0.32, 1, 1, 1));
        else
            self.label:SetForeColor(Turbine.UI.Color.Gray);
            self.label:SetBackColor(Turbine.UI.Color.Gray);
        end
    end

    self.quickslot.MouseLeave = function()
        if (self.enabled) then
            self.label:SetForeColor(Turbine.UI.Color.Yellow);
            self.label:SetBackColor(Turbine.UI.Color.Transparent);
        else
            self.label:SetForeColor(Turbine.UI.Color.Gray);
            self.label:SetBackColor(Turbine.UI.Color.Gray);
        end
    end
end

function ButtonShortcut:SetText(text)
    self.label:SetText(text);
end

function ButtonShortcut:SetPosition(left, top)
    self:SetLeft(left);
    self:SetTop(top);
    self.quickslot:SetPosition(-52, 0);
    self.label:SetPosition(0, 0);
end

function ButtonShortcut:SetSize(width, height)
    self:SetWidth(width);
    self:SetHeight(height);
    self.quickslot:SetSize(width + 52, height);
    self.label:SetSize(width, height);
end

function ButtonShortcut:SetData(data)
    self.shortcut:SetData(data);
    self.quickslot:SetShortcut(self.shortcut);
end

function ButtonShortcut:Enable()
    self.enabled = true;
    self.quickslot:SetMouseVisible(true);
    self.label:SetForeColor(Turbine.UI.Color.Yellow);
    self.label:SetBackColor(Turbine.UI.Color.Transparent);
end

function ButtonShortcut:Disable()
    self.enabled = false;
    self.quickslot:SetMouseVisible(false);
    self.label:SetForeColor(Turbine.UI.Color.Gray);
    self.label:SetBackColor(Turbine.UI.Color.Gray);
end
