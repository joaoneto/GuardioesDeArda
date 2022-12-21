import "Turbine";
import "Turbine.UI";
import "Turbine.UI.Lotro";

import "GuardioesDeArda.Lupa.LupaItem";

local TWENTY_MINUTES_IN_SECONDS = 1200;
local LINE_HEIGHT = 18;

LupaWindow = class(Turbine.UI.Lotro.Window);

function LupaWindow:Constructor()
	Turbine.UI.Lotro.Window.Constructor(self);

	self:SetText("Lupa");
	self:SetSize(LupaSettings.window.width, LupaSettings.window.height);
	self:SetPosition(LupaSettings.window.left, LupaSettings.window.top);

	self.selectedLffOwner = nil;

	self.showOnlyInPatternBox = Turbine.UI.Lotro.CheckBox();
	self.showOnlyInPatternBox:SetParent(self);
	self.showOnlyInPatternBox:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	self.showOnlyInPatternBox:SetForeColor(Turbine.UI.Color.Khaki);
	self.showOnlyInPatternBox:SetText(" Show only pattern based LFF");
	self.showOnlyInPatternBox:SetChecked(true);
	self.showOnlyInPatternBox.checked = true;
	self.showOnlyInPatternBox.CheckedChanged = function(_sender, _args)
		self:Update();
	end

	self.chatSend = Turbine.UI.Lotro.Quickslot();
	self.chatSend:SetParent(self);
	self.chatSend:SetSize(140, LINE_HEIGHT);
	self.chatSend:SetPosition(386, 48);
	self.chatSend:SetAllowDrop(false);
	self.chatSend:SetZOrder(1);
	self.chatSend:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.chatSend:SetBackColor(Turbine.UI.Color(0.91, 0, 0, 0));

	self.chatSendShortcut = Turbine.UI.Lotro.Shortcut(Turbine.UI.Lotro.ShortcutType.Alias, "");
	self.chatSendShortcut:SetData("/tell Curl x");

	self.chatSend:SetShortcut(self.chatSendShortcut);

	self.chatSendButton = Turbine.UI.Label();
	self.chatSendButton:SetParent(self);
	self.chatSendButton:SetSize(89, LINE_HEIGHT + 2);
	self.chatSendButton:SetPosition(438, 48);
	self.chatSendButton:SetForeColor(Turbine.UI.Color.Yellow);
	self.chatSendButton:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	self.chatSendButton:SetFontStyle(Turbine.UI.FontStyle.Outline);
	self.chatSendButton:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.chatSendButton:SetMouseVisible(false);
	self.chatSendButton:SetZOrder(2);
	self.chatSendButton:SetText("Send Tell");
	self.chatSendButton:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.chatSendButton:SetBackground("GuardioesDeArda/Lupa/Resources/button.tga");

	self.chatSend.MouseEnter = function()
		self.chatSendButton:SetForeColor(Turbine.UI.Color.White);
		self.chatSendButton:SetBackground("GuardioesDeArda/Lupa/Resources/button_hover.tga");
	end

	self.chatSend.MouseLeave = function()
		self.chatSendButton:SetForeColor(Turbine.UI.Color.Yellow);
		self.chatSendButton:SetBackground("GuardioesDeArda/Lupa/Resources/button.tga");
	end

	self.overlayChatSend = Turbine.UI.Control();
	self.overlayChatSend:SetParent(self);
	self.overlayChatSend:SetSize(52, LINE_HEIGHT);
	self.overlayChatSend:SetPosition(386, 48);
	self.overlayChatSend:SetZOrder(3);
	self.overlayChatSend:SetBlendMode(Turbine.UI.BlendMode.Overlay);
	self.overlayChatSend:SetBackColor(Turbine.UI.Color(0.91, 0, 0, 0));

	self.verticalScrollbar = Turbine.UI.Lotro.ScrollBar();
	self.verticalScrollbar:SetOrientation(Turbine.UI.Orientation.Vertical);
	self.verticalScrollbar:SetParent(self);

	self.lupaList = Turbine.UI.ListBox();
	self.lupaList:SetParent(self);
	self.lupaList:SetPosition(15, 120);
	self.lupaList:SetVerticalScrollBar(self.verticalScrollbar);

	self.lupaList.SelectedIndexChanged = function(sender, args)
		local selectedItem = self.lupaList:GetSelectedItem();
		for i = 1, self.lupaList:GetItemCount() do
			local item = self.lupaList:GetItem(i);
			if (item and selectedItem) then
				if (selectedItem.data.owner == item.data.owner) then
					self.selectedLffOwner = item.data.owner;
					item:Select();
				else
					item:Unselect();
				end
			end
		end
	end

	self:Update();
end

function LupaWindow:Update()
	-- clean
	while self.lupaList:GetItemCount() > 0 do
		self.lupaList:RemoveItemAt(1);
	end

	-- transform hash table in table
	local list = {};
	for _, data in pairs(LffList) do
		-- check if LFF message is grater than 20 minutes
		if (Turbine.Engine.GetLocalTime() - data.time > TWENTY_MINUTES_IN_SECONDS) then
			-- if message timeout, them remove from LffList
			LffList[data.owner] = nil;
		else
			table.insert(list, data);
		end
	end

	-- sort table
	table.sort(list, function (a, b)
		return a.time > b.time;
	end);

	local showAll = not self.showOnlyInPatternBox:IsChecked();
	-- re-render
	for _, data in pairs(list) do
		local isDefault = data.instance == nil or data.instance == InstanceEnum.default;
		-- showAll or filter parsed LFF calls to show
		if (showAll or not isDefault) then
			local item = LupaItem(data);
			self.lupaList:AddItem(item);
			if (item) then
				if (self.selectedLffOwner == item.data.owner) then
					item:Select();
				else
					item:Unselect();
				end
			end
		end
	end

	self.lupaList:SelectedIndexChanged({});

	self:Layout();
end

function LupaWindow:Layout()
	local width, height = self:GetSize();

	local listWidth = width - 38;
	local listHeight = height - 152;

	self.lupaList:SetSize(listWidth, listHeight);

	self.verticalScrollbar:SetPosition(width - 22, 120);
	self.verticalScrollbar:SetSize(10, listHeight);

	self.showOnlyInPatternBox:SetPosition(15, 45);
	self.showOnlyInPatternBox:SetSize(240, 24);

	for i = 1, self.lupaList:GetItemCount() do
		local item = self.lupaList:GetItem(i);
		item:SetSize(listWidth, 20);
	end
end

function LupaWindow:SizeChanged()
	self:Layout();
end
