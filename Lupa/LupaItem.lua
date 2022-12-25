local SPACING = 8;
local LINE_HEIGHT = 18;
local ICON_SIZE = 48;
local ROW_HEIGHT = 76;

LupaItem = class(Turbine.UI.Control);

function LupaItem:Constructor(data)
	Turbine.UI.Control.Constructor(self);

	self.OnSelect = nil;
	self.selected = false;

	self:SetSize(500, ROW_HEIGHT);
	self:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self:SetBackColorBlendMode(Turbine.UI.BlendMode.Color);

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
	self.icon:SetBackground(
		(Instances[data.instance] and Instances[data.instance].thumbnail)
		or "GuardioesDeArda/Lupa/Resources/default_thumb.tga"
	);

	if (data.instance ~= InstanceEnum.default) then
		self.instanceLabel = Turbine.UI.Label();
		self.instanceLabel:SetMouseVisible(false);
		self.instanceLabel:SetParent(self);
		self.instanceLabel:SetPosition(0, ICON_SIZE + SPACING);
		self.instanceLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		self.instanceLabel:SetForeColor(Turbine.UI.Color.Khaki);
		self.instanceLabel:SetText(data.instance);
		self.instanceLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	end

	self.instanceNameLabel = Turbine.UI.Label();
	self.instanceNameLabel:SetMouseVisible(false);
	self.instanceNameLabel:SetParent(self);
	self.instanceNameLabel:SetPosition(ICON_SIZE + (SPACING * 3), SPACING);
	self.instanceNameLabel:SetFont(Turbine.UI.Lotro.Font.TrajanProBold16);
	self.instanceNameLabel:SetForeColor(Turbine.UI.Color.Goldenrod);
	self.instanceNameLabel:SetText(Instances[self.data.instance].name);
	self.instanceNameLabel:SetSize(340, LINE_HEIGHT);

	if (self.data.lffMessage ~= nil) then
		self.txtLabel = Turbine.UI.Label();
		self.txtLabel:SetMouseVisible(false);
		self.txtLabel:SetParent(self);
		self.txtLabel:SetSize(320, LINE_HEIGHT * 3);
		self.txtLabel:SetPosition(ICON_SIZE + (SPACING * 3), LINE_HEIGHT + SPACING + (SPACING / 2));
		self.txtLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		self.txtLabel:SetFontStyle(Turbine.UI.FontStyle.Outline);
		self.txtLabel:SetText(self.data.lffMessage);
	else
		-- count tiers roles level
		for i, k in pairs({ "count", "tiers", "level", "roles" }) do
			if (k == "roles") then
				local left = ICON_SIZE + (SPACING * 3) + ((i - 1) * 76);
				local top = LINE_HEIGHT + SPACING;

				for j, r in pairs(self.data.roles) do
					self[k .. "role"] = Turbine.UI.Control();
					self[k .. "role"]:SetMouseVisible(false);
					self[k .. "role"]:SetParent(self);
					self[k .. "role"]:SetSize(16, 16);
					self[k .. "role"]:SetPosition(left, top);
					self[k .. "role"]:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
					self[k .. "role"]:SetBackground(ClassRoleIcons[r] or ClassRoleIcons.any);

					self[k .. "value"] = Turbine.UI.Label();
					self[k .. "value"]:SetMouseVisible(false);
					self[k .. "value"]:SetParent(self);
					self[k .. "value"]:SetSize(46, LINE_HEIGHT);
					self[k .. "value"]:SetPosition(left + 16, top);
					self[k .. "value"]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
					self[k .. "value"]:SetFontStyle(Turbine.UI.FontStyle.Outline);
					self[k .. "value"]:SetText(r);

					if (j > 1 and j % 3 == 0) then
						left = ICON_SIZE + (SPACING * 3) + ((i - 1) * 76);
						top = top + LINE_HEIGHT;
					else
						left = left + (16 + 46);
					end
				end
			else
				self[k .. "label"] = Turbine.UI.Label();
				self[k .. "label"]:SetMouseVisible(false);
				self[k .. "label"]:SetParent(self);
				self[k .. "label"]:SetSize(76, LINE_HEIGHT);
				self[k .. "label"]:SetPosition(ICON_SIZE + (SPACING * 3) + ((i - 1) * 76), LINE_HEIGHT + SPACING);
				self[k .. "label"]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
				self[k .. "label"]:SetFontStyle(Turbine.UI.FontStyle.Outline);
				self[k .. "label"]:SetForeColor(Turbine.UI.Color.Khaki);
				self[k .. "label"]:SetText(k);

				self[k .. "value"] = Turbine.UI.Label();
				self[k .. "value"]:SetMouseVisible(false);
				self[k .. "value"]:SetParent(self);
				self[k .. "value"]:SetSize(76, LINE_HEIGHT);
				self[k .. "value"]:SetPosition(ICON_SIZE + (SPACING * 3) + ((i - 1) * 76), (LINE_HEIGHT * 2) + SPACING);
				self[k .. "value"]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
				self[k .. "value"]:SetFontStyle(Turbine.UI.FontStyle.Outline);
				self[k .. "value"]:SetText(self.data[k] or "n/a");
			end
		end
	end

	self.MouseEnter = function()
		self:SetBackColor(Turbine.UI.Color(0.4, 1, 1, 1));
		self:SetBackground("GuardioesDeArda/Lupa/Resources/item_bg.tga");
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

	if (self.instanceLabel) then
		self.instanceLabel:SetSize(ICON_SIZE + (SPACING * 2), LINE_HEIGHT);
	end

	if (self.selected) then
		self:SetBackground("GuardioesDeArda/Lupa/Resources/item_bg.tga");
	else
		self:SetBackground(nil);
	end
end

function LupaItem:SizeChanged()
	self:Layout();
end
