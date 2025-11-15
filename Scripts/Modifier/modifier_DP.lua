--探测神识Modifier
local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("modifier_DetectPerception");

--进入modifier
function tbModifier:Enter(modifier, npc)
	self.Time = 0;
	print("modifier_DetectPerception Enter");

end

--modifier step
function tbModifier:Step(modifier, npc, dt)
	local fps = 1/dt;
	local maxLing = npc:GetProperty("NpcLingMaxValue");
	
	if (npc.LingV >1000) then
		npc:ReduceLingDamage((maxLing*0.005/fps), g_emElementKind.None, false, "");
		self.Time = self.Time + dt;
		--print(self.Time);
		if (self.Time>=1) then
			--print("Time Passed!");
			GameMain:GetMod('AmazingThiefSimulator'):DetectionFX(npc);
			self.Time = 0;
		end
	else
	
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

