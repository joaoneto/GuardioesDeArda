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
    labelControl:SetPosition(tabsCount * tabLabelWidth, 0);
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
    contentControl:SetZOrder(1);
    contentControl:SetSize(self:GetWidth(), self:GetHeight() - tabLabelHeight);
    contentControl:SetPosition(0, tabLabelHeight);

    local leftBorderContent = Turbine.UI.Control();
    leftBorderContent:SetParent(self);
    leftBorderContent:SetZOrder(-1);
    leftBorderContent:SetMouseVisible(false);
    leftBorderContent:SetPosition(1, tabLabelHeight)
    leftBorderContent:SetSize(10, contentControl:GetHeight() - 11);
    leftBorderContent:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    leftBorderContent:SetBackColorBlendMode(Turbine.UI.BlendMode.Multiply);
    leftBorderContent:SetBackColor(Turbine.UI.Color(0.3, 0, 0, 0));
    leftBorderContent:SetBackground(0x4110cd4b);

    local rightBorderContent = Turbine.UI.Control();
    rightBorderContent:SetParent(self);
    rightBorderContent:SetZOrder(-1);
    rightBorderContent:SetMouseVisible(false);
    rightBorderContent:SetPosition(contentControl:GetWidth() - 10, tabLabelHeight)
    rightBorderContent:SetSize(10, contentControl:GetHeight() - 11);
    rightBorderContent:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    rightBorderContent:SetBackColorBlendMode(Turbine.UI.BlendMode.Multiply);
    rightBorderContent:SetBackColor(Turbine.UI.Color(0.3, 0, 0, 0));
    rightBorderContent:SetBackground(0x4110cd4c);

    local topBorderContent = Turbine.UI.Control();
    topBorderContent:SetParent(self);
    topBorderContent:SetZOrder(-1);
    topBorderContent:SetMouseVisible(false);
    topBorderContent:SetPosition(3, tabLabelHeight)
    topBorderContent:SetSize(contentControl:GetWidth() - 5, 8);
    topBorderContent:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    topBorderContent:SetBackColorBlendMode(Turbine.UI.BlendMode.Multiply);
    topBorderContent:SetBackColor(Turbine.UI.Color(0.3, 0, 0, 0));
    topBorderContent:SetBackground(0x4110cd4a);

    local buttonBorderContent = Turbine.UI.Control();
    buttonBorderContent:SetParent(self);
    buttonBorderContent:SetZOrder(-1);
    buttonBorderContent:SetMouseVisible(false);
    buttonBorderContent:SetPosition(3, contentControl:GetHeight())
    buttonBorderContent:SetSize(contentControl:GetWidth() - 5, 10);
    buttonBorderContent:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    buttonBorderContent:SetBackColorBlendMode(Turbine.UI.BlendMode.Multiply);
    buttonBorderContent:SetBackColor(Turbine.UI.Color(0.3, 0, 0, 0));
    buttonBorderContent:SetBackground(0x4110cd4d);

    table.insert(self.tabs, { label = labelControl, content = contentControl });
    self:Layout();

    return self:GetTab(tabsCount + 1);
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
