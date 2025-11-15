local AmazingThiefSimulator = GameMain:NewMod("AmazingThiefSimulator");

function AmazingThiefSimulator:EmposionThing()
	--print("Em Check Point");
	local item = self:CheckEquipItem();
	--print(item);


	--local myNpc = world:GetSelectThing();
	local v,myNpc = self:IsPlayerNpc();
	
	if (v) then
		if (item~=nil) then
			world:EnterUILuaMode('Lua_Selection',myNpc,'Lua_Selection');
		else
			--print("没有可用使用的物品");
			world:ShowMsgBox("没有装备任何可用使用的物品","无法执行");
		end
	end
	


end

function AmazingThiefSimulator:DoEmposionThing(target)
	local originItem = self:CheckEquipItem();
	local modifierMgr = CS.XiaWorld.ModifierMgr.Instance;
	local modifierDef = modifierMgr:GetDef("EmpoisonedThing");
	--print(modifierDef.Desc);
	modifierDef.Duration = 30;
	modifierDef.EndModifier = "Dan_LostSoul";

	local v,myNpc = self:IsPlayerNpc();

	if target ~= nil then
		local dist = Vector2.Distance(Vector2(myNpc.Pos.x,myNpc.Pos.y), Vector2(target.Pos.x,target.Pos.y));
		print("Distance:"..dist);
		if dist > 5 then
			world:ShowMsgBox("距离太远了，无法下药。","距离过远");
		else
			--Item Condition
			if (target.ThingType == g_emThingType.Item) then
				
				local v,targetLable,targetModifierName = self:CheckThingModifier(target);
				--local targetModifierName = m;
				
				local v,originLable,originModifierName = self:CheckThingModifier(originItem);
				--local originModifierName = m;
				
				local modifierNameNew = "EmpoisonedThing";
				local check = false;
				
				print("对象物品: "..target:GetName());
				print(targetModifierName);
				print(targetLable)
				
				print("使用物品: "..originItem:GetName());
				print(originModifierName);
				print(originLable)

				--[[
				if (targetModifierName == modifierNameNew) then
					world:ShowMsgBox("同类物品已经被下过药了","无法再次下药");
				else
					if (targetLable == "Food") then
						target.def.Item.Food.Modifier = modifierNameNew;
						modifierDef.EndModifier = originModifierName;
						check = true;
					elseif (targetLable == "Elixir") then
						target.def.Item.Elixir.Modifier = modifierNameNew;
						modifierDef.EndModifier = originModifierName;
						check = true;
					end
				end
				--]]
				
				if (targetLable == "Food") then
					target.def.Item.Food.Modifier = modifierNameNew;
					modifierDef.EndModifier = originModifierName;
					check = true;
				elseif (targetLable == "Elixir") then
					target.def.Item.Elixir.Modifier = modifierNameNew;
					modifierDef.EndModifier = originModifierName;
					check = true;
				end
				
				if (check) then
					local thingName = target:GetName();
					thingName = ("被下药的"..thingName);
					target:SetName(thingName);				
					local thingDesc = target:GetDesc();
					thingDesc = (thingDesc .. "\n被下药了,药物为："..originItem:GetName());
					target:SetDesc(thingDesc);
					originItem:Destroy(false);
					local effectPool = CS.XiaWorld.EffectPool.Instance;
					effectPool:BindEffect(73,myNpc,"Dummy001", 5,false);
					world:FlyLineEffect(myNpc.Key, target.Key, 2, nil, "#00aa00", nil, nil, "Effect/System/FlyLine");
					effectPool:GetEffect("Effect/A/Prefabs/Projectiles/Life/LifeProjectileSmall", target.Pos, 0, false);
					
					print(target.Key);
					self:DoEmposionThingFX(target.Key,1);
					
					print("Empoison");
				end
			end
			--NPC Condition
			if (target.ThingType == g_emThingType.Npc) then
				local v,originLable,originModifierName = self:CheckThingModifier(originItem);
				modifierDef.EndModifier = originModifierName;
				originItem:Destroy(false);

				print("被下药对象为： "..target:GetName().."药物为："..originItem:GetName());				
				--print(target.PropertyMgr.Practice.GoldLevel);
				--print(target.PropertyMgr.Physique);
				
				local effectPool = CS.XiaWorld.EffectPool.Instance;
				effectPool:BindEffect(73,myNpc,"Dummy001", 5,false);
				world:FlyLineEffect(myNpc.Key, target.Key, 2, nil, "#00aa00", nil, nil, "Effect/System/FlyLine");
				effectPool:GetEffect("Effect/A/Prefabs/Projectiles/Life/LifeProjectileSmall", target.Pos, 0, false);
				
				print(target.Key);
				self:DoEmposionThingFX(target.Key,1);
				
				target:AddModifier("EmpoisonedThing",1,false,1,0);
				
			end
		end

	end


end

function AmazingThiefSimulator:DoEmposionThingFX(key,r)

	local pos = GridMgr:Grid2Pos(key);
	local radius = r;
	local aroundGrids = GridMgr:GetAroundGrid(pos.x,pos.y,radius);
	local path = "Effect/A/Prefabs/Projectiles/Life/LifeImpactTiny";
	local effectPool = CS.XiaWorld.EffectPool.Instance;
	local thingsOnMap = Map.Things;

	for k,key in pairs(aroundGrids) do
		--print(k,v);
		local gridPos = GridMgr:Grid2Pos(key)
		local fx = effectPool:GetEffect(path, gridPos, 1, false);
		fx = nil;
	end
	effectPool = nil;

end


function AmazingThiefSimulator:CheckEquipItem()

	--获得装备的道具
	local items;
	local myNpc;
	local curSelectThing = CS.XiaWorld.UILogicMode_Select.Instance.CurSelectThing;
	if curSelectThing ~= nil then
		if curSelectThing.ThingType == g_emThingType.Npc and curSelectThing.IsPlayerThing then
			myNpc = curSelectThing;
			--local itemThingList = myNpc.Equip:GetEquipAll();
			local item1 = myNpc.Equip:GetEquip(CS.XiaWorld.g_emEquipType.Tool1);
			local item2 = myNpc.Equip:GetEquip(CS.XiaWorld.g_emEquipType.Tool2);
			local item3 = myNpc.Equip:GetEquip(CS.XiaWorld.g_emEquipType.Tool3);
			local item4 = myNpc.Equip:GetEquip(CS.XiaWorld.g_emEquipType.Tool4);
			local item5 = myNpc.Equip:GetEquip(CS.XiaWorld.g_emEquipType.Tool5);
			local item6 = myNpc.Equip:GetEquip(CS.XiaWorld.g_emEquipType.Tool6);
			--print(item1);
			items = {item1,item2,item3,item4,item5,item6};
		end
	end

	local item;
		for k,thing in pairs(items) do
			print(k,thing);
			local v,l,m = self:CheckThingModifier(thing);
			if (v) then
				item = thing;
				break;
			else
				item = nil;
			end
		end
	return item;
end

function AmazingThiefSimulator:CheckThingModifier(thing)
	local lableName;
	local modifierName;
	-- Start取得物品Modifier
	if thing ~= nil then
		local itemLable = thing.def.Item.Lable
		--print(itemLable);
		if (itemLable == CS.XiaWorld.g_emItemLable.Food or itemLable == CS.XiaWorld.g_emItemLable.Meat) then
			if (thing.def.Item.Food) then
				modifierName = thing.def.Item.Food.Modifier;
				lableName = "Food";
				return true,lableName,modifierName;
			end
		elseif (itemLable == CS.XiaWorld.g_emItemLable.Drug or itemLable == CS.XiaWorld.g_emItemLable.Dan) then
			if (thing.def.Item.Elixir) and (thing.def.Item.Elixir.Modifier) then
				lableName = "Elixir";
				modifierName = thing.def.Item.Elixir.Modifier;
				return true,lableName,modifierName;				
			end
		else
			return false,lableName,modifierName;
		end
	end
	-- End取得物品Modifier
end


function AmazingThiefSimulator:EnhancePerception()
	local v,myNpc = self:IsPlayerNpc();
	local waitTime = 30;
	local toil1 = CS.XiaWorld.ToilDo("",waitTime,"神识外放中","dazuo");
	local jobMgr = CS.XiaWorld.JobMgr.Instance;
	local myJob = jobMgr:CreateJob("JobGoToWalkable",nil,nil);
	local myJobNpcEngine = myNpc.JobEngine;
	myJobNpcEngine:BeginJob(myJob);
	--myJob:AddToil(toil1);
	--print("toil1");


	
	if (v == true) then
		--Call FX
		--self:EnhancePerceptionFX(myNpc,45);

	
	--[[
		local colors = {"ff0000","#ffff00","00ff00","00ffff","0000ff","ff00ff","ffffff"};
		--self:EnhancePerceptionEffect(myNpc);
		for i=0, world:RandomInt(20,30),1 do
			local pos = GridMgr:Grid2Pos(myNpc.Key+i*500);
			world:FlyLineEffect(myNpc.Key, myNpc.Key+i*500, 4*world:RandomFloat(0.5,1.5), nil, colors[world:RandomInt(1,7)], nil, nil, "Effect/System/FlyLineBig");
			local effectPool = CS.XiaWorld.EffectPool.Instance;
			local effect= effectPool:GetEffect("Effect/gsq/Prefab/ZhenFa03", pos, 5, false);
			
			local pos = GridMgr:Grid2Pos(myNpc.Key-i*500);
			world:FlyLineEffect(myNpc.Key, myNpc.Key-i*500, 4*world:RandomFloat(0.5,1.5), nil, colors[world:RandomInt(1,7)], nil, nil, "Effect/System/FlyLineBig");
			local effectPool = CS.XiaWorld.EffectPool.Instance;
			local effect= effectPool:GetEffect("Effect/gsq/Prefab/ZhenFa03", pos, 5, false);
		end
	--]]
		local effectPool = CS.XiaWorld.EffectPool.Instance;
		effectPool:BindEffect(90015,myNpc,"Dummy001", waitTime,false);
		effectPool:BindEffect(100000,myNpc,"Dummy001", waitTime,false);
		
		--local originVR = myNpc.PropertyMgr:GetProperty("VisionRadius",0, 0);
		myNpc:AddModifier("EnhancePerception",1,false,1,waitTime);
		--myNpc.PropertyMgr:ModifierProperty("VisionRadius",originVR, 0, 0, 0);
		
		
		myNpc.view:DoPlayAnimation("dazuo",0);
		
		
		local thingItems = ThingMgr:GetThingList(g_emThingType.Item);
		for k,target in pairs(thingItems) do
			local thingName = target:GetName();
			print(thingName)
			print(target.Rate);
			if (target.Rate >=10) then
				local effectPool = CS.XiaWorld.EffectPool.Instance;
				effectPool:GetEffect("Effect/gsq/Prefab/JinDanQi", target.Pos, 60, false);
			end
		end
				
		--Debug
		print("Enhacement");
	else
		CS.Wnd_Message.Show("非玩家NPC，不能执行此命令",1);
	end

end

function AmazingThiefSimulator:EnhancePerceptionFX(npc,r)
	local myNpc = npc;
	local myNpcPos = GridMgr:Grid2Pos(myNpc.Key)
	--r = 25;
	local radius = CS.UnityEngine.Mathf.CeilToInt(r);
	local aroundGrids = GridMgr:GetAroundGrid(myNpcPos.x,myNpcPos.y,radius);
	local path = "Effect/A/Prefabs/Projectiles/Life/LifeImpactTiny";
	local effectPool = CS.XiaWorld.EffectPool.Instance;
	local colors = {"ff0000","#ffff00","00ff00","00ffff","0000ff","ff00ff","ffffff"};
	--local thingsOnMap = Map.Things;


	for i=0, world:RandomInt(20,30),1 do
		local gridKeyRnd = aroundGrids[world:RandomInt(1,aroundGrids.Count)];
		local pos = GridMgr:Grid2Pos(gridKeyRnd);
		world:FlyLineEffect(myNpc.Key, gridKeyRnd, 3*world:RandomFloat(0.5,1.25), nil, colors[world:RandomInt(1,7)], nil, nil, "Effect/System/LongXishuiLine");
		local effectPool = CS.XiaWorld.EffectPool.Instance;
		local effect= effectPool:GetEffect("Effect/gsq/Prefab/ZhenFa03", pos, 3, false);
		
		local gridKeyRnd = aroundGrids[world:RandomInt(1,aroundGrids.Count)];
		local pos = GridMgr:Grid2Pos(gridKeyRnd);
		world:FlyLineEffect(myNpc.Key, gridKeyRnd, 3*world:RandomFloat(0.5,1.25), nil, colors[world:RandomInt(1,7)], nil, nil, "Effect/System/LongXishuiLine");
		local effectPool = CS.XiaWorld.EffectPool.Instance;
		local effect= effectPool:GetEffect("Effect/gsq/Prefab/ZhenFa03", pos, 3, false);
		
	end

end


function AmazingThiefSimulator:DetectPerception()
	local v,myNpc = self:IsPlayerNpc();

	if (v == true) then
		myNpc:AddModifier("DetectPerception", 1, false, 1, 60);
		--print("Send to FX Function");
		--print(myNpc);
		--First Time;
		self:DetectionFX(myNpc);
	else
		CS.Wnd_Message.Show("非玩家NPC，不能执行此命令",1);
	end

	print("Detection");
end

function AmazingThiefSimulator:DoSteal(arg)
	if (arg == "UI") then
		print("Open UI");
		
	end
	local v,myNpc = self:IsPlayerNpc();
	myNpc:AddModifier("DoSteal",1,false,1,600);
	world:EnterUILuaMode('EnterUILuaMode',myNpc,'emposion');
	--[[
	if (v == true) then
		myNpc:AddSpecialFlag(g_emNpcSpecailFlag.FLAG_CANTSCAN,1);
		myNpc:AddSpecialFlag(g_emNpcSpecailFlag.FLAG_FIGHTHIDE,1);
		
		print("不能脱掉装备：");
		print(myNpc:HasSpecialFlag(g_emNpcSpecailFlag.FLAG_CANNOT_UNEQUPT));;
	end
	--]]
end

function AmazingThiefSimulator:IsPlayerNpc()
	local IsPlayerNpc = false;
	local curSelectThing = CS.XiaWorld.UILogicMode_Select.Instance.CurSelectThing;
		if curSelectThing ~= nil then
			if curSelectThing.ThingType == g_emThingType.Npc and curSelectThing.IsPlayerThing then
				IsPlayerNpc = true;
			end
		end
	return IsPlayerNpc,curSelectThing;
end

function AmazingThiefSimulator:DetectionFX(npc)
	--print(npc);
	local emojis = {"(⊙ˍ⊙)","⊙▽⊙","(￣m￣）","≡ω≡","⊙o⊙","(。_。)","￣へ￣","(o.ω.o)"};
	local myNpc = npc;
	local npcs = Map.Things:GetActiveNpcs();
	local difCampNpcs = {};
	for i = 0, npcs.Count-1 do
		local npc = npcs[i];
		if (npc.IsPlayerThing) then
			--myNpc = npc;
		else
			difCampNpcs[i] = npc;
		end
	end
	--print(myNpc);
	--local pos = GridMgr:Grid2Pos(myNpc.Key);
	local effectPool = CS.XiaWorld.EffectPool.Instance;
	--effectPool:GetEffect("Effect/B/Prefabs/Glowing orbs(10)/Glowing Alarmbell", pos, 1.5, false);
	effectPool:BindEffect("Effect/B/Prefabs/Glowing orbs(10)/Glowing Alarmbell",myNpc,"Dummy001",1.5,false);
	effectPool = nil;
	
	for k,npc in pairs(difCampNpcs) do
		--print(k,npc);
		num = Vector2.Distance(Vector2(npc.Pos.x,npc.Pos.y),Vector2(myNpc.Pos.x,myNpc.Pos.y));
		--print(npc:GetName().."  距离 "..num);
		local npcVR = npc:GetProperty("VisionRadius");
		if num <= npcVR then
			--print("距离: "..num.." "..npc:GetName().."感知范围: "..npcVR);
			--print(npc.Pos);
			local emoji = emojis[(world:RandomInt(1,#emojis))];
			CS.Wnd_DialogboxWindow.Get(emoji, npc, 5, 0, 1);
			local effectPool = CS.XiaWorld.EffectPool.Instance;
			effectPool:BindEffect(90033,npc,"Dummy001", 3,false);
			effectPool:BindEffect("Effect/gsq/Prefab/ZhenFa03",npc,"Dummy001",3,false);
			
			local path = "Effect/System/FlyLine";
			--local begint = CS.ResourceLoader.Inst:Load(path);
			--local pos = GridMgr:Grid2Pos(npc.Key);
			--begint.transform.position = pos;
			--local endt = begint;
			--local pos = GridMgr:Grid2Pos(myNpc.Key);
			--endt.transform.position = pos;
			--world:FlyLineEffect(npc.Key, myNpc.Key, 2, nil, "#ff0000", begint.transform, endt.transform, path);
			world:FlyLineEffect(npc.Key, myNpc.Key, 0.2, nil, "#ff0000", nil, nil, path);
			
			effectPool = nil;
			begint = nil;
			endt = nil;

		end
	end

end

function AmazingThiefSimulator:BeenPoisionedFX(npc)
	--print(npc);
	local effectPool = CS.XiaWorld.EffectPool.Instance;
	effectPool:BindEffect(73,npc,"Dummy001",1.5,false);
end

function AmazingThiefSimulator:EmpoisonSuccessRate(myNpc,target)
	--施法玩家NPC因子
	local myNpcSv = myNpc:GetProperty("NpcFight_SneakValue"); --潜行值
	local myNpcLv;
	if (myNpc.PropertyMgr.Practice.CurStage ~=nil) then
		myNpcLv = myNpc.PropertyMgr.Practice.CurStage.Level; --等级(练气、结丹、金丹...)
	else
		myNpcLv = 0;
	end

	local myNpcLuck = myNpc.PropertyMgr.Luck; --运气成分
	local myNpcLuckFactors = {0.5,0.7,0.8,0.9,1,1.1,1.2,1.3,1.4,1.5};
	local myNpcLuckFactor = myNpcLuckFactors[CS.UnityEngine.Mathf.CeilToInt(myNpcLuck)];

	local targetLv;
	if (target.PropertyMgr.Practice.CurStage ~=nil) then
		targetLv = target.PropertyMgr.Practice.CurStage.Level;
	else
		targetLv = 0;
	end
	local levelFactors = {0,0.5,1,1.5,2.0};
	local levelFactor;
	--若玩家NPC等级低于对象NPC等级超过2级，必定失败。高于对象NPC等级，增加成功概率
	--print(myNpcLv-targetLv);
	if (myNpcLv-targetLv)>0 then
		local maxNum = (myNpcLv-targetLv)+2;
		if maxNum >5 then
			maxNum =5;
		end
		levelFactor = levelFactors[maxNum];
	elseif (myNpcLv-targetLv)==0 then
		levelFactor = levelFactors[3];
	elseif (myNpcLv-targetLv)<0 then
		local minNum = (myNpcLv-targetLv)+2;
		if minNum <0 then
			minNum = 1;
		end
		levelFactor = levelFactors[minNum];
	end

	local targetPhys = target.PropertyMgr.Physique; --对象根骨、根骨越高、越难成功
	local physiqueFactors = {1.5,1.4,1.3,1.1,1,0.9,0.8,0.7,0.6,0.5};
	local physiqueFactor = physiqueFactors[CS.UnityEngine.Mathf.CeilToInt(targetPhys)];

	--print(levelFactor,physiqueFactor,myNpcLuckFactor,myNpcSv);
	local successRateStrs = {"微乎其微","可能成功","大概率成功"};
	local successRateStr;
	local successRate = (levelFactor) * (physiqueFactor+myNpcLuckFactor) * myNpcSv;
	if (successRate>=70) then
		successRateStr = successRateStrs[3];
	elseif (successRate<70 and successRate>=40) then
		successRateStr = successRateStrs[2];
	else
		successRateStr = successRateStrs[1];
	end
	--print("成功因子： "..successRate);
	return successRate,successRateStr;
end

function AmazingThiefSimulator:OnSave()

end

function AmazingThiefSimulator:OnLoad(tbLoad)

end





