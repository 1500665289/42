local tbThing = GameMain:GetMod("ThingHelper"):GetThing("Lua_NPC");

function tbThing:OnInit()
--[[
	self._R = 5;
	self._T = 30000;
	
	if self.Index == nil then
		self.Index = 0;
	end
	if self.Time == nil then
		self.Time = 0;
	end
--]]

	if self.Time == nil then
		self.Time = 0;
	end
	
end

function tbThing:OnGetSaveData()
	--return {Index = self.Index, Time = self.Time};
end

function tbThing:OnLoadData(tbData)
--[[
	if tbData ~= nil then
		self.Index = tbData.Index;
		self.Time = tbData.Time;
	end
--]]
end

function tbThing:OnStep(dt)
	local it = self.it;
	local IsFightMap = world:GetFightMapPlace();
	local playerNpcs = Map.Things:GetPlayerActiveNpcs(g_emNpcRaceType.Wisdom);
	--IsFightMap = 1;
	if (it.IsPlayerThing) and (IsFightMap ~=nil) and (playerNpcs.Count<=3) then
		--print("Player Thing!");
		local btn = tbThing:GetBtn(it,"神识外放");
		if btn == false then
			it:AddBtnData("神识外放","res/Sprs/ui/icon_jichu","GameMain:GetMod('AmazingThiefSimulator'):EnhancePerception()","把自身神识提升至最大，会逐渐增加感知范围，并在一定时间内标记高阶物品。\n由于会极大耗费神识，使用时无法移动。\n增加的感知范围由人物本身神识和境界决定");
		end
		
		local btn = tbThing:GetBtn(it,"神识探测");
		if btn == false then
			it:AddBtnData("神识探测","res/Sprs/ui/icon_jichu","GameMain:GetMod('AmazingThiefSimulator'):DetectPerception()","利用自身神识，对周围存在其他的神识进行侦测。\n对神识负担较重，需要大量的灵力以维持开启。");
		end
		
		local btn = tbThing:GetBtn(it,"偷偷下药");
		if btn == false then
			it:AddBtnData("偷偷下药","res/Sprs/ui/icon_youcui01","GameMain:GetMod('AmazingThiefSimulator'):EmposionThing()","对指定物品或人物进行下药。\n消耗携带的物品");
		end
		--[[
		local btn = tbThing:GetBtn(it,"妙手空空");
		if btn == false then
			it:AddBtnData("妙手空空","res/Sprs/ui/icon_youcui01","GameMain:GetMod('AmazingThiefSimulator'):DoSteal('UI')","妙手空空之神术，人莫能窥其用，鬼莫得蹑其踪。\n在隐蔽状态下方可使用");
		end
		--]]
	end

	--[[
	if self.Index == -1 then
		return;
	end
	if self.Grids == nil then
		self.Grids = GridMgr:GetAroundGrid(it.Key, self._R, false);
	end
	local need = self._T / self.Grids.Count;
	self.Time = self.Time + dt;
	if self.Time >= need then
		self.Time = 0;
		self:ChangeTerrain(self.Grids[self.Index]);
		self.Index = self.Index + 1;
		if self.Index == self.Grids.Count then
			self.Index = -1;
		end
	end	
	self:AfterStep(dt);
	--]]
end

function tbThing:AfterStep(dt)
	
end
function tbThing:OnPutDown()
	
end

function tbThing:OnPickUp()

end

function tbThing:GetBtn(it,BtnName)
	if it.btns == nil then
		return false;
	end
	for i=0, it.btns.Count -1 do
		if it.btns[i].name == BtnName then
			return it.btns[i];
		end
	end
	return false
end


