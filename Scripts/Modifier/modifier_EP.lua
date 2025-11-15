--探测神识Modifier
local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("modifier_EnhancePerception");

--进入modifier
function tbModifier:Enter(modifier, npc)
	self.Time = 0;
	self.TimeFX = 0;
	self.Vr = npc:GetProperty("VisionRadius");
	self.VrMax = 50;
	print("modifier_EnhancePerception Enter");
	--print(npc);
end

--modifier step
function tbModifier:Step(modifier, npc, dt)
	--local fps = 1/dt;
	local vr = npc:GetProperty("VisionRadius");
	local vrAdd = 2.5;
	
	self.Time = self.Time + dt;
	if (self.Time>=1.1) then
		if (vr<self.VrMax) then
			npc.PropertyMgr:ModifierProperty("VisionRadius",vrAdd, 0, 0, 0);
		end	
		self.Time = 0;
	end
	
	if (self.TimeFX==0) then
		GameMain:GetMod("AmazingThiefSimulator"):EnhancePerceptionFX(npc,vr+vrAdd);
	end

	self.TimeFX = self.TimeFX + dt;
		if (self.TimeFX >5) and (vr<self.VrMax) then
			GameMain:GetMod("AmazingThiefSimulator"):EnhancePerceptionFX(npc,vr+vrAdd*5);
			self.TimeFX = 0;
		end
	
	--[[
	local curDuration = modifier:GetCurDuration();
	if (curDuration.x>0.9) then
		--print("Time is Over");
		--npc.PropertyMgr:ModifierProperty("VisionRadius",0, 0, self.Vr, 0);
	end
	--]]


	

end

--层数更新
function tbModifier:UpdateStack(modifier, npc, add)
	
end

--离开modifier
function tbModifier:Leave(modifier, npc)
	print("modifier_EnhancePerception Leave");
	local vr = npc:GetProperty("VisionRadius");
	--print(self.Vr-vr);
	npc.PropertyMgr:ModifierProperty("VisionRadius",0, 0, (self.Vr-vr), 0);
end

--获取存档数据
function tbModifier:OnGetSaveData()
	--return self.data;
end

--载入存档数据
function tbModifier:OnLoadData(modifier, npc, tbData)
	--self.data = tbData;
end

