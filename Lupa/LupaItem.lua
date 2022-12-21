local SPACING = 15;
local LINE_HEIGHT = 18;
local ICON_SIZE = 48;
local ROW_HEIGHT = 96;
local ROW_WIDTH = 640 - (SPACING * 2);

LupaItem = class(Turbine.UI.Control);

function LupaItem:Constructor(data)
	Turbine.UI.Control.Constructor(self);

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
		self.instanceLabel:SetParent(self);
		self.instanceLabel:SetPosition(0, ICON_SIZE + SPACING);
		self.instanceLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		self.instanceLabel:SetZOrder(4);
		self.instanceLabel:SetForeColor(Turbine.UI.Color.Khaki);
		self.instanceLabel:SetText(data.instance);
		self.instanceLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	end

	self.nameLabel = Turbine.UI.Label();
	self.nameLabel:SetParent(self);
	self.nameLabel:SetPosition(ICON_SIZE + (SPACING * 2), SPACING);
	self.nameLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro16);
	self.nameLabel:SetZOrder(4);
	self.nameLabel:SetForeColor(Turbine.UI.Color.Khaki);
	self.nameLabel:SetText(self.data.instanceName);

	self.ownerNameLabel = Turbine.UI.Label();
	self.ownerNameLabel:SetParent(self);
	self.ownerNameLabel:SetPosition(ICON_SIZE + (SPACING * 2), 6 + SPACING + LINE_HEIGHT);
	self.ownerNameLabel:SetFont(Turbine.UI.Lotro.Font.TrajanProBold16);
	self.ownerNameLabel:SetZOrder(4);
	self.ownerNameLabel:SetForeColor(Turbine.UI.Color.Goldenrod);
	self.ownerNameLabel:SetText(self.data.owner);

	self.nameLabel3 = Turbine.UI.Label();
	self.nameLabel3:SetParent(self);
	self.nameLabel3:SetPosition(ICON_SIZE + (SPACING * 2), 4 + SPACING + (LINE_HEIGHT * 2));
	self.nameLabel3:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	self.nameLabel3:SetZOrder(4);
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
		self:SetBackground("GuardioesDeArda/Lupa/Resources/item_bg.tga");
	end

	self.MouseLeave = function()
		self:SetBackground(nil);
	end

	self:Layout();
end

function LupaItem:Layout()
	local width = self:GetWidth();

	self:SetSize(500, ROW_HEIGHT);
	self:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);

	if (self.instanceLabel) then
		self.instanceLabel:SetSize(ICON_SIZE + (SPACING * 2), LINE_HEIGHT);
	end

	self.nameLabel:SetSize(width - self.nameLabel:GetLeft() - 220, LINE_HEIGHT);
	self.ownerNameLabel:SetSize(100, LINE_HEIGHT);
	self.nameLabel3:SetSize(width - self.nameLabel:GetLeft() - 220, LINE_HEIGHT * 2);
end

function LupaItem:SizeChanged()
	self:Layout();
end
