
local MugDelay = 5 -- 5 minutes

local MugTable = {"Gangster"}

function BugMugKeyPress(ply,mv)

		local Attacker = ply
		local Victim = ply:GetEyeTrace().Entity
		
		
		
		
		if mv:KeyDown(IN_WALK) and mv:KeyDown(IN_RELOAD) then
		
			if not Attacker.BugMugNextTick then
				Attacker.BugMugNextTick = 1
			end
			
			if not Attacker.NextMugAttacker then
				Attacker.NextMugAttacker = 1
			end
			
			if not Victim.NextMugVictim then
				Victim.NextMugVictim = 1
			end
		
		
			if Attacker.BugMugNextTick <= CurTime() then
			
				Attacker.BugMugNextTick = CurTime() + 3
			
				if not table.HasValue(MugTable,team.GetName(Attacker:Team())) then
					Attacker:ChatPrint("[BugMug]: You're not allowed to mug as a " .. team.GetName(Attacker:Team()) .. "!")
				return end
				
				if Attacker.NextMugAttacker >= CurTime() then
					Attacker:ChatPrint("[BugMug]: Please wait " .. string.NiceTime(Attacker.NextMugAttacker - CurTime()) .. " before mugging someone again.")
				return end

				if not Victim:IsPlayer() then
					Attacker:ChatPrint("[BugMug]: You need to be looking at a player in order to mug someone!")
				return end
				
				if Victim:GetPos():Distance(Attacker:GetPos()) > 250 then
					Attacker:ChatPrint("[BugMug]: You're too far away to mug " .. Victim:Nick() .. "!")
				return end

				if Victim.NextMugVictim >= CurTime() then
					Attacker:ChatPrint("[BugMug]: Please wait .. " .. string.NiceTime(Victim.NextMugVictim - CurTime()) .. " before mugging " .. Victim:Nick() .. " again.")
				return end

			
				for k,v in pairs(player.GetAll()) do
					if v == Attacker then
						v:ChatPrint("[BugMug]: You're mugging " .. Victim:Nick() .. " for $500! They have 10 seconds.")
					elseif v == Victim then
						v:ChatPrint("[BugMug]: " .. Attacker:Nick() .. " IS MUGGING YOU FOR $500!!!")
						v:ChatPrint("[BugMug]: " .. Attacker:Nick() .. " IS MUGGING YOU FOR $500!!!")
						v:ChatPrint("[BugMug]: " .. Attacker:Nick() .. " IS MUGGING YOU FOR $500!!!")
					else
						v:ChatPrint("[BugMug]: " .. Attacker:Nick() .. " is mugging " .. Victim:Nick() .. " for $500!")
					end
				end
				
				Victim:EmitSound("ambient/alarms/klaxon1.wav")
				
				Attacker:ConCommand("say /advert DROP $500 OR DIE, " .. Victim:Nick() .. "! You have 10 seconds!")
				
				Attacker.NextMugAttacker = CurTime() + MugDelay
				Victim.NextMugVictim = CurTime() + MugDelay
				
			end
			
			

		end

	--end

end

hook.Add("FinishMove","BugMug: FinishMove", BugMugKeyPress)

local NextTick = 0

function BugMugThink()

	if NextTick <= CurTime() then
		
		for k,v in pairs(player.GetAll()) do
		
			v:SendLua([[
			
				chat.AddText( Color(100,255,255), "This server has BugMug installed. If you're a thief, press ALT + R to mug someone.")
			
			
			]])
		
		
		
		end
		
		NextTick = CurTime() + 300
	end
	
end

hook.Add("Think","BugMug: Think", BugMugThink)

