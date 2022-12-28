import "Turbine";
import "Turbine.UI";
import "Turbine.UI.Lotro";

import "GuardioesDeArda.Lupa.LupaItem";
import "GuardioesDeArda.Lupa.ButtonShortcut";
import "GuardioesDeArda.Lupa.Tab";

local TWENTY_MINUTES_IN_SECONDS = 1200;
local LINE_HEIGHT = 18;
local player = Turbine.Gameplay.LocalPlayer.GetInstance();

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

	self.createLffText = "";
	self.roles = {};
	self.tabs:Add("Create LFF");
	self.createPreview = LupaItem({});
	self.createPreview:SetParent(self.tabs:Get(2));
	self.createPreview:SetPosition(10, 10);
	self.createPreview:SetHoverHighlight(false);

	function UpdateCreateLffText()
		local serializedRoles = table.concat(self.roles, "/");

		self.createLffText = (self.countInput:GetText() ~= "" and (" " .. self.countInput:GetText()) or "")
			.. (self.instanceNameInput:GetText() and (" " .. self.instanceNameInput:GetText()) or "")
			.. (self.tiersInput:GetText() ~= "" and (" " .. self.tiersInput:GetText()) or "")
			.. (serializedRoles ~= "" and (" " .. table.concat(self.roles, "/")) or "")
			.. (self.levelInput:GetText() ~= "" and (" lvl" .. self.levelInput:GetText()) or "");

		local parsed = ParseMessage("LFF " .. player:GetName() .. self.createLffText);
		if (parsed.isPatternBased) then
			self.createPreview.data = parsed;
		else
			self.createPreview.data = {};
			self.createPreview.data.owner = player:GetName();
			self.createPreview.data.lffMessage = self.createLffText;
		end

		self.createPreview:Layout();
		self:Update();
	end

	self.instanceNameLabel = Turbine.UI.Label();
	self.instanceNameLabel:SetParent(self.tabs:Get(2));
	self.instanceNameLabel:SetSize(76, 20);
	self.instanceNameLabel:SetPosition(10, 120);
	self.instanceNameLabel:SetText("Instance:");
	self.instanceNameLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	self.instanceNameLabel:SetForeColor(Turbine.UI.Color.DarkKhaki);
	self.instanceNameLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);

	self.instanceNameInput = Turbine.UI.Lotro.TextBox();
	self.instanceNameInput:SetParent(self.tabs:Get(2));
	self.instanceNameInput:SetSize(120, 20);
	self.instanceNameInput:SetPosition(90, 120);
	self.instanceNameInput:SetFont(Turbine.UI.Lotro.Font.Verdana14);
	self.instanceNameInput.TextChanged = UpdateCreateLffText;

	self.countLabel = Turbine.UI.Label();
	self.countLabel:SetParent(self.tabs:Get(2));
	self.countLabel:SetSize(76, 20);
	self.countLabel:SetPosition(10, 120 + 30);
	self.countLabel:SetText("Count:");
	self.countLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	self.countLabel:SetForeColor(Turbine.UI.Color.DarkKhaki);
	self.countLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);

	self.countInput = Turbine.UI.Lotro.TextBox();
	self.countInput:SetParent(self.tabs:Get(2));
	self.countInput:SetSize(120, 20);
	self.countInput:SetPosition(90, 120 + 30);
	self.countInput:SetFont(Turbine.UI.Lotro.Font.Verdana14);
	self.countInput.TextChanged = UpdateCreateLffText;

	self.tiersLabel = Turbine.UI.Label();
	self.tiersLabel:SetParent(self.tabs:Get(2));
	self.tiersLabel:SetSize(76, 20);
	self.tiersLabel:SetPosition(10, 120 + 60);
	self.tiersLabel:SetText("Tiers:");
	self.tiersLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	self.tiersLabel:SetForeColor(Turbine.UI.Color.DarkKhaki);
	self.tiersLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);

	self.tiersInput = Turbine.UI.Lotro.TextBox();
	self.tiersInput:SetParent(self.tabs:Get(2));
	self.tiersInput:SetSize(120, 20);
	self.tiersInput:SetPosition(90, 120 + 60);
	self.tiersInput:SetFont(Turbine.UI.Lotro.Font.Verdana14);
	self.tiersInput.TextChanged = UpdateCreateLffText;

	self.levelLabel = Turbine.UI.Label();
	self.levelLabel:SetParent(self.tabs:Get(2));
	self.levelLabel:SetSize(76, 20);
	self.levelLabel:SetPosition(10, 120 + 90);
	self.levelLabel:SetText("Level:");
	self.levelLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	self.levelLabel:SetForeColor(Turbine.UI.Color.DarkKhaki);
	self.levelLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);

	self.levelInput = Turbine.UI.Lotro.TextBox();
	self.levelInput:SetParent(self.tabs:Get(2));
	self.levelInput:SetSize(120, 20);
	self.levelInput:SetPosition(90, 120 + 90);
	self.levelInput:SetFont(Turbine.UI.Lotro.Font.Verdana14);
	self.levelInput.TextChanged = UpdateCreateLffText;

	local rolesCheckLeft = 230;
	local rolesCheckTop = 92;
	for i, k in pairs({ "any", "heal", "tank", "dps", "hunter", "burg", "lm" }) do
		local roleIcon = Turbine.UI.Control();
		local roleCheck = Turbine.UI.Lotro.CheckBox();

		rolesCheckLeft = rolesCheckLeft + 76 + 18;
		if ((i - 1) % 3 == 0) then
			rolesCheckLeft = 230;
			rolesCheckTop = rolesCheckTop + 28;
		end

		roleIcon:SetParent(self.tabs:Get(2));
		roleIcon:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
		roleIcon:SetBackground(ClassRoleIcons[k] or ClassRoleIcons.any);
		roleIcon:SetSize(16, 16);
		roleIcon:SetPosition(rolesCheckLeft, rolesCheckTop);
		self["role_icon_" .. k] = roleIcon;

		roleCheck:SetParent(self.tabs:Get(2));
		roleCheck:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		roleCheck:SetForeColor(Turbine.UI.Color.Khaki);
		roleCheck:SetText(" " .. k);
		roleCheck:SetSize(76, 18);
		roleCheck:SetPosition(rolesCheckLeft + 18, rolesCheckTop);
		roleCheck.CheckedChanged = function ()
			-- self.roles
			local indexFound = nil;
			for j, v in pairs(self.roles) do
				if (v == k) then
					indexFound = j;
				end
			end
			if (roleCheck:IsChecked()) then
				if (indexFound == nil) then
					table.insert(self.roles, k);
				end
			else
				if (indexFound) then
					table.remove(self.roles, indexFound);
				end
			end

			UpdateCreateLffText();
		end
		self["role_check_" .. k] = roleCheck;
	end

	self.chatCreateSend = ButtonShortcut();
	self.chatCreateSend:SetParent(self.tabs:Get(2));
	self.chatCreateSend:SetText("Send LFF");
	self.chatCreateSend:SetSize(90, LINE_HEIGHT + 2);
	self.chatCreateSend:SetPosition(420, 349);
	self.chatCreateSend:Disable();

	self.chatTextCopyLabel = Turbine.UI.Label();
	self.chatTextCopyLabel:SetParent(self.tabs:Get(2));
	self.chatTextCopyLabel:SetSize(120, 20);
	self.chatTextCopyLabel:SetPosition(20, 120 + 120 + 10);
	self.chatTextCopyLabel:SetText("Copy LFF text:");
	self.chatTextCopyLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	self.chatTextCopyLabel:SetForeColor(Turbine.UI.Color.DarkKhaki);
	self.chatTextCopyLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);

	self.chatTextCopy = Turbine.UI.Lotro.TextBox();
	self.chatTextCopy:SetParent(self.tabs:Get(2));
	self.chatTextCopy:SetSize(380, 100);
	self.chatTextCopy:SetPosition(20, 120 + 120 + 30);
	self.chatTextCopy:SetFont(Turbine.UI.Lotro.Font.Verdana14);
	self.chatTextCopy:SetReadOnly(true);
	
	UpdateCreateLffText();

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

	if (self.selectedLff) then
		self.chatSend:SetData("/tell " .. self.selectedLff.owner .. " x");
		self.chatSend:Enable();
	else
		self.chatSend:Disable();
		self.chatSend:SetData(nil);
	end

	if (self.createLffText:match("%a+")) then
		self.chatCreateSend:SetData("/LFF " .. self.createLffText);
		self.chatCreateSend:Enable();
	else
		self.chatCreateSend:Disable();
		self.chatCreateSend:SetData(nil);
	end

	self.chatTextCopy:SetText(self.createLffText);
end

function LupaWindow:SizeChanged()
	self:Layout();
end
