local SPACING = 15;
local LINE_HEIGHT = 18;
local ICON_SIZE = 48;
local ROW_HEIGHT = 96;

LupaItem = class(Turbine.UI.Control);

function LupaItem:Constructor(data)
	Turbine.UI.Control.Constructor(self);

	self.OnSelect = nil;
	self.selected = false;

	self:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);

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

	-- self.nameLabel = Turbine.UI.Label();
	-- self.nameLabel:SetParent(self);
	-- self.nameLabel:SetPosition(ICON_SIZE + (SPACING * 2), SPACING);
	-- self.nameLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro16);
	-- self.nameLabel:SetZOrder(4);
	-- self.nameLabel:SetForeColor(Turbine.UI.Color.Khaki);
	-- self.nameLabel:SetText(self.data.instanceName);

	self.ownerNameLabel = Turbine.UI.Label();
	self.ownerNameLabel:SetMouseVisible(false);
	self.ownerNameLabel:SetParent(self);
	self.ownerNameLabel:SetPosition(ICON_SIZE + (SPACING * 2), SPACING);
	self.ownerNameLabel:SetFont(Turbine.UI.Lotro.Font.TrajanProBold16);
	self.ownerNameLabel:SetForeColor(Turbine.UI.Color.Goldenrod);
	self.ownerNameLabel:SetText(self.data.owner);
	self.ownerNameLabel:SetSize(100, LINE_HEIGHT);

	self.nameLabel3 = Turbine.UI.Label();
	self.nameLabel3:SetMouseVisible(false);
	self.nameLabel3:SetParent(self);
	self.nameLabel3:SetPosition(ICON_SIZE + (SPACING * 2), LINE_HEIGHT + SPACING + (SPACING / 2));
	self.nameLabel3:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	self.nameLabel3:SetFontStyle(Turbine.UI.FontStyle.Outline);
	if (self.data.lffMessage ~= nil) then
		self.nameLabel3:SetText(self.data.lffMessage);
	else
		local txt = ""; 
		for _, data in pairs({ [0] = self.data.count, [1] = self.data.roles, [2] = self.data.level, [3] = self.data.tiers }) do
			if (data) then
				txt = txt .. data .. " - ";
			end
		end
		self.nameLabel3:AppendText(txt:gsub("- *$", ""));
	end

	self.MouseEnter = function()
		self:SetBackColor(Turbine.UI.Color(0.26, 1, 1, 1));
		self:SetBackColorBlendMode(Turbine.UI.BlendMode.Color);
		self:SetBackground("GuardioesDeArda/Lupa/Resources/item_bg.tga");
	end

	self.MouseLeave = function()
		self:SetBackColorBlendMode(Turbine.UI.BlendMode.Undefined);
		if (not self.selected) then
			self:SetBackground(nil);
		end
	end

	self:Layout();
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
	local width = self:GetWidth();

	self:SetSize(500, ROW_HEIGHT);
	self.nameLabel3:SetSize(width - (SPACING * 6), LINE_HEIGHT * 3);

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
