import "Turbine";
import "Turbine.UI";
import "Turbine.UI.Lotro";

import "GuardioesDeArda.Lupa.LupaItem";
import "GuardioesDeArda.Lupa.ButtonShortcut";
import "GuardioesDeArda.Lupa.Tab";

local TWENTY_MINUTES_IN_SECONDS = 1200;
local LINE_HEIGHT = 18;

LupaWindow = class(Turbine.UI.Lotro.Window);

function LupaWindow:Constructor()
	Turbine.UI.Lotro.Window.Constructor(self);

	self:SetText("Lupa");
	self:SetSize(LupaSettings.window.width, LupaSettings.window.height);
	self:SetPosition(LupaSettings.window.left, LupaSettings.window.top);

	self.selectedLff = nil;

	self.tabs = Tab();
	self.tabs:SetParent(self);
	self.tabs:SetPosition(10, 38);
	self.tabs:SetSize(self:GetWidth() - 20, self:GetHeight() - 60);

	self.tabs:Add("LFF List");
	self.tabs:Add("Create LFF");

	self.showOnlyInPatternBox = Turbine.UI.Lotro.CheckBox();
	self.showOnlyInPatternBox:SetParent(self.tabs:Get(1));
	self.showOnlyInPatternBox:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	self.showOnlyInPatternBox:SetForeColor(Turbine.UI.Color.Khaki);
	self.showOnlyInPatternBox:SetText(" Pattern only");
	self.showOnlyInPatternBox:SetChecked(true);
	self.showOnlyInPatternBox.checked = true;
	self.showOnlyInPatternBox.CheckedChanged = function()
		self:Update();
	end

	self.chatSend = ButtonShortcut();
	self.chatSend:SetParent(self.tabs:Get(1));
	self.chatSend:SetText("Send tell");
	self.chatSend:SetData("/tell Curl x");
	self.chatSend:SetSize(90, LINE_HEIGHT + 2);
	self.chatSend:SetPosition(420, 16);
	self.chatSend:Disable();

	self.verticalScrollbar = Turbine.UI.Lotro.ScrollBar();
	self.verticalScrollbar:SetOrientation(Turbine.UI.Orientation.Vertical);
	self.verticalScrollbar:SetParent(self.tabs:Get(1));
	self.verticalScrollbar:SetZOrder(1);

	self.lupaList = Turbine.UI.ListBox();
	self.lupaList:SetParent(self.tabs:Get(1));
	self.lupaList:SetPosition(10, 52);
	self.lupaList:SetVerticalScrollBar(self.verticalScrollbar);

	self.lupaList.SelectedIndexChanged = function()
		local selectedItem = self.lupaList:GetSelectedItem();
		for i = 1, self.lupaList:GetItemCount() do
			local item = self.lupaList:GetItem(i);
			if (item and selectedItem) then
				if (selectedItem.data.owner == item.data.owner) then
					self.selectedLff = item.data;
					item:Select();
				else
					item:Unselect();
				end
			end
		end
		self:Layout();
	end

	self:Update();
end

function LupaWindow:Update()
	self.tabs:SetSize(self:GetSize());

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
				if (self.selectedLff and self.selectedLff.owner == item.data.owner) then
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

	self.verticalScrollbar:SetPosition(width - 32, 52);
	self.verticalScrollbar:SetSize(10, listHeight);

	self.showOnlyInPatternBox:SetPosition(15, 16);
	self.showOnlyInPatternBox:SetSize(240, 24);
end

function LupaWindow:SizeChanged()
	self:Layout();
end
