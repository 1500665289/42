local tbYY = GameMain:GetMod("_LogicMode"):CreateMode("Lua_Selection")

function tbYY:OnModeEnter(p)
	--print(p[0]);
	--print(p[1]);
	--print(p[2]);
	self.myNpc = p[1];
	self:SetKeyCondition("Npc|Item");
	self:OpenThingCheck();
	self:ShowLine(self.myNpc);
	self:SetHeadMsg("请选择要下药的物品或人物对象");
end

function tbYY:CheckThing(k)
	--print(k);
	local map = self:GetMap();
	
	local npc = map.Things:GetThingAtGrid(k, g_emThingType.Npc)
	if (npc ~= nil) then
		local successRate,successRateStr = GameMain:GetMod("AmazingThiefSimulator"):EmpoisonSuccessRate(self.myNpc,npc);
		self:SetCheckMsg("可下药，当前目标:" .. npc:GetName().." \r成功率: "..successRateStr);
		--self:SetCheckMsg("可下药，当前目标:" .. npc:GetName().." \r成功率: "..successRate);
		return true
	end

	local item = map.Things:GetThingAtGrid(k, g_emThingType.Item);
	if (item ~= nil) then
		self:SetCheckMsg("可下药，当前目标:" .. item:GetName().." \r成功率: 必定成功");
		return true
	end


	if (npc ~= nil or item ~= nil) then
		self:SetCheckMsg("无法执行");
	end


	return false
end

function tbYY:OnModeLeave()
	self.myNpc = nil;
end

function tbYY:Apply(key)
	local map = self:GetMap();

	local npc = map.Things:GetThingAtGrid(key, g_emThingType.Npc)
	if (npc ~= nil) then
		GameMain:GetMod("AmazingThiefSimulator"):DoEmposionThing(npc);
		return;
	end

	local target = map.Things:GetThingAtGrid(key, g_emThingType.Item);
	if (target ~= nil) then
		--print(target);
		GameMain:GetMod("AmazingThiefSimulator"):DoEmposionThing(target);
		return;
	end
	
	--print(key);
end
