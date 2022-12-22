ButtonShortcut = class(Turbine.UI.Control);

function ButtonShortcut:Constructor()
    Turbine.UI.Control.Constructor(self);

    self.quickslot = Turbine.UI.Lotro.Quickslot();
    self.quickslot:SetParent(self);
    self.quickslot:SetAllowDrop(false);
    self.quickslot:SetZOrder(1);

    self.shortcut = Turbine.UI.Lotro.Shortcut(Turbine.UI.Lotro.ShortcutType.Alias, "");
    -- self.shortcut:SetData("/tell Curl x");
    -- self.quickslot:SetShortcut(self.shortcut);

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

    self.quickslot.MouseEnter = function()
        self.label:SetForeColor(Turbine.UI.Color.White);
        self.label:SetBackground("GuardioesDeArda/Lupa/Resources/button_hover.tga");
    end

    self.quickslot.MouseLeave = function()
        self.label:SetForeColor(Turbine.UI.Color.Yellow);
        self.label:SetBackground("GuardioesDeArda/Lupa/Resources/button.tga");
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
