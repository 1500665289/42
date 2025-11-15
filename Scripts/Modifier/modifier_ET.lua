--探测神识Modifier
local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("modifier_EmpoisonedThing");

--进入modifier
function tbModifier:Enter(modifier, npc)
	self.Time = 0;
	print("modifier_EmpoisonedThing Enter");

end

--modifier step
function tbModifier:Step(modifier, npc, dt)
	local fps = 1/dt;
	self.Time = self.Time + dt;
	if (self.Time>=1) then
		--print("Time Passed!");
		GameMain:GetMod('AmazingThiefSimulator'):BeenPoisionedFX(npc);
		self.Time = 0;
	end
end

--层数更新
function tbModifier:UpdateStack(modifier, npc, add)
	
end

--离开modifier
function tbModifier:Leave(modifier, npc)

end

--获取存档数据
function tbModifier:OnGetSaveData()
	--return self.data;
end

--载入存档数据
function tbModifier:OnLoadData(modifier, npc, tbData)
	--self.data = tbData;
end

