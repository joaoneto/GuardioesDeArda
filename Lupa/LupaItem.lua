local SPACING = 8;
local LINE_HEIGHT = 18;
local ICON_SIZE = 48;
local ROW_HEIGHT = 76;

LupaItem = class(Turbine.UI.Control);

function LupaItem:Constructor(data)
	Turbine.UI.Control.Constructor(self);

	self.OnSelect = nil;
	self.selected = false;
	self.hoverHightlight = true;

	self:SetSize(500, ROW_HEIGHT);
	self:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self:SetBackColorBlendMode(Turbine.UI.BlendMode.Color);

	data = data or {};
	self.data = {};
	self.data.channel = data.channel;
	self.data.owner = tostring(data.owner);
	self.data.count = data.count;
	self.data.instance = data.instance;
	self.data.instanceName = (Instances[data.instance] and Instances[data.instance].name or data.instance);
	self.data.tiers = data.tiers;
	self.data.roles = data.roles;
	self.data.level = data.level;
	self.data.lffMessage = data.lffMessage;

	self.icon = Turbine.UI.Control();
	self.icon:SetMouseVisible(false);
    self.icon:SetParent(self);
    self.icon:SetSize(ICON_SIZE, ICON_SIZE);
    self.icon:SetPosition(SPACING, SPACING);
	self.icon:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);

	self.instanceLabel = Turbine.UI.Label();
	self.instanceLabel:SetMouseVisible(false);
	self.instanceLabel:SetParent(self);
	self.instanceLabel:SetPosition(0, ICON_SIZE + SPACING);
	self.instanceLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	self.instanceLabel:SetForeColor(Turbine.UI.Color.Khaki);
	self.instanceLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);

	self.instanceNameLabel = Turbine.UI.Label();
	self.instanceNameLabel:SetMouseVisible(false);
	self.instanceNameLabel:SetParent(self);
	self.instanceNameLabel:SetPosition(ICON_SIZE + (SPACING * 3), SPACING);
	self.instanceNameLabel:SetFont(Turbine.UI.Lotro.Font.TrajanProBold16);
	self.instanceNameLabel:SetForeColor(Turbine.UI.Color.Goldenrod);
	self.instanceNameLabel:SetSize(340, LINE_HEIGHT);

	self.txtLabel = Turbine.UI.Label();
	self.txtLabel:SetMouseVisible(false);
	self.txtLabel:SetParent(self);
	self.txtLabel:SetSize(320, LINE_HEIGHT * 3);
	self.txtLabel:SetPosition(ICON_SIZE + (SPACING * 3), LINE_HEIGHT + SPACING + (SPACING / 2));

	self.MouseEnter = function()
		if (self.hoverHightlight) then
			self:SetBackColor(Turbine.UI.Color(0.4, 1, 1, 1));
			self:SetBackground("GuardioesDeArda/Lupa/Resources/item_bg.tga");
		end
	end

	self.MouseLeave = function()
		self:SetBackColor(Turbine.UI.Color(0.10, 0, 0, 0));
		if (not self.selected) then
			self:SetBackground(nil);
		end
	end

	self:Layout();
end

function LupaItem:IsSelected()
	return self.selected;
end

function LupaItem:Select()
	self.selected = true;
	self:Layout();
end

function LupaItem:Unselect()
	self.selected = false;
	self:Layout();
end

function LupaItem:Layout()
	self:SetBackColor(Turbine.UI.Color(0.10, 0, 0, 0));

	if (self.auxControl ~= nil) then
		self.auxControl:SetParent(nil);
		self.auxControl = nil;
	end

	self.auxControl = Turbine.UI.Control();
	self.auxControl:SetParent(self);
	self.auxControl:SetSize(500, ROW_HEIGHT);
	self.auxControl:SetPosition(ICON_SIZE + (SPACING * 3), 0);

	if (self.instanceLabel) then
		self.instanceLabel:SetSize(ICON_SIZE + (SPACING * 2), LINE_HEIGHT);
	end

	if (self.selected) then
		self:SetBackground("GuardioesDeArda/Lupa/Resources/item_bg.tga");
	else
		self:SetBackground(nil);
	end

	if (Instances[self.data.instance] and Instances[self.data.instance].thumbnail) then
		self.icon:SetBackground(Instances[self.data.instance].thumbnail);
	else
		self.icon:SetBackground("GuardioesDeArda/Lupa/Resources/default_thumb.tga");
	end

	if (InstanceEnum[self.data.instance]) then
		self.instanceLabel:SetText(self.data.instance);
	else
		self.instanceLabel:SetText("");
	end

	if (self.data.owner and InstanceEnum[self.data.instance]) then
		self.instanceNameLabel:SetText(self.data.owner .. " - " .. Instances[self.data.instance].name);
	else
		self.instanceNameLabel:SetText(self.data.owner .. " - " .. Instances.default.name);
	end

	if (self.data.lffMessage ~= nil) then
		self.txtLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		self.txtLabel:SetFontStyle(Turbine.UI.FontStyle.Outline);
		self.txtLabel:SetText(self.data.lffMessage);
	else
		self.txtLabel:SetText("");
		-- count tiers roles level
		for i, k in pairs({ "count", "tiers", "level", "roles" }) do
			if (k == "roles" and self.data.roles) then
				local left = ((i - 1) * 76);
				local top = LINE_HEIGHT + SPACING;

				for j, r in pairs(self.data.roles) do
					self["role_icon_" .. k] = Turbine.UI.Control();
					self["role_icon_" .. k]:SetMouseVisible(false);
					self["role_icon_" .. k]:SetParent(self.auxControl);
					self["role_icon_" .. k]:SetSize(16, 16);
					self["role_icon_" .. k]:SetPosition(left, top);
					self["role_icon_" .. k]:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
					self["role_icon_" .. k]:SetBackground(ClassRoleIcons[r] or ClassRoleIcons.any);

					self["role_value_" .. k] = Turbine.UI.Label();
					self["role_value_" .. k]:SetMouseVisible(false);
					self["role_value_" .. k]:SetParent(self.auxControl);
					self["role_value_" .. k]:SetSize(46, LINE_HEIGHT);
					self["role_value_" .. k]:SetPosition(left + 16, top);
					self["role_value_" .. k]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
					self["role_value_" .. k]:SetFontStyle(Turbine.UI.FontStyle.Outline);
					self["role_value_" .. k]:SetText(r);

					if (j > 1 and j % 3 == 0) then
						left = ((i - 1) * 76);
						top = top + LINE_HEIGHT;
					else
						left = left + (16 + 46);
					end
				end
			else
				self["column_label_" .. k] = Turbine.UI.Label();
				self["column_label_" .. k]:SetMouseVisible(false);
				self["column_label_" .. k]:SetParent(self.auxControl);
				self["column_label_" .. k]:SetSize(76, LINE_HEIGHT);
				self["column_label_" .. k]:SetPosition(((i - 1) * 76), LINE_HEIGHT + SPACING);
				self["column_label_" .. k]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
				self["column_label_" .. k]:SetFontStyle(Turbine.UI.FontStyle.Outline);
				self["column_label_" .. k]:SetForeColor(Turbine.UI.Color.Khaki);
				self["column_label_" .. k]:SetText(k);

				self["column_value_" .. k] = Turbine.UI.Label();
				self["column_value_" .. k]:SetMouseVisible(false);
				self["column_value_" .. k]:SetParent(self.auxControl);
				self["column_value_" .. k]:SetSize(76, LINE_HEIGHT);
				self["column_value_" .. k]:SetPosition(((i - 1) * 76), (LINE_HEIGHT * 2) + SPACING);
				self["column_value_" .. k]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
				self["column_value_" .. k]:SetFontStyle(Turbine.UI.FontStyle.Outline);
				self["column_value_" .. k]:SetText(self.data[k] or "n/a");
			end
		end
	end
end

function LupaItem:SizeChanged()
	self:Layout();
end

function LupaItem:SetHoverHighlight(hoverHightlight)
	self.hoverHightlight = hoverHightlight;
	self:Layout();
end

