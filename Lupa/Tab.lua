Tab = class(Turbine.UI.Control);

local tabLabelWidth = 204;
local tabLabelHeight = 20;

function Tab:Constructor()
    Turbine.UI.Control.Constructor(self);

    self.tabs = {};
    self.selectedIndex = 1;
end

function Tab:Layout()
    for i, tab in pairs(self.tabs) do
        if (i == self.selectedIndex) then
            tab.content:SetVisible(true);
            tab.label:SetBackground(0x410001d9);
            tab.label:SetForeColor(Turbine.UI.Color.White);
        else
            tab.content:SetVisible(false);
            tab.label:SetBackground(0x410001da);
            tab.label:SetForeColor(Turbine.UI.Color.Goldenrod);
        end
    end
end

function Tab:Add(label)
    local tabsCount = self:GetCount();

    local labelControl = Turbine.UI.Label();
    labelControl:SetParent(self);
    labelControl:SetSize(tabLabelWidth, tabLabelHeight);
    labelControl:SetPosition(tabsCount * tabLabelWidth + 10, 0);
    labelControl:SetText(label);
    labelControl:SetTextAlignment(Turbine.UI.ContentAlignment.BottomCenter);
    labelControl:SetFontStyle(Turbine.UI.FontStyle.Outline);
    labelControl:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
    labelControl:SetForeColor(Turbine.UI.Color.Goldenrod);
    labelControl:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    labelControl:SetBackColorBlendMode(Turbine.UI.BlendMode.Color);
    labelControl:SetBackground(0x410001da);
    labelControl.MouseClick = function ()
        self:Select(tabsCount + 1);
    end

    local contentControl = Turbine.UI.Control();
    contentControl:SetParent(self);
    contentControl:SetSize(self:GetWidth(), self:GetHeight() - tabLabelHeight);
    contentControl:SetPosition(0, tabLabelHeight);

    table.insert(self.tabs, { label = labelControl, content = contentControl });
    self:Layout();

    return self:GetTab();
end

function Tab:Select(index)
    self.selectedIndex = index;
    self:Layout();
end

function Tab:GetTab(index)
    return self.tabs[index];
end

function Tab:GetCount()
    return #self.tabs;
end

function Tab:Get(index)
    return self.tabs[index] and self.tabs[index].content;
end
