AddCSLuaFile()
SWEP.PrintName				= "Rope Owner Finder"
SWEP.Author					= "Peklenc"
SWEP.Purpose				= "Find A Rope's Owner"
SWEP.Slot					= 0
SWEP.SlotPos				= 4
SWEP.Spawnable				= true
SWEP.ViewModel				= "models/weapons/c_toolgun.mdl"
SWEP.WorldModel				= "models/weapons/w_toolgun.mdl"
SWEP.UseHands				= true
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.DrawAmmo				= false
SWEP.Category 				= "Admin"
SWEP.Primary.Delay			= .5

function SWEP:Initialize()
	self:SendWeaponAnim(ACT_VM_HOLSTER)
end

local ropeowners = {}

function SWEP:DoHitEffects()

end


function SWEP:PrimaryAttack()	
	ropeowners = {}
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	local trace = self.Owner:GetEyeTraceNoCursor();
	if (trace.Hit or trace.HitWorld) then
		local entities = ents.FindInSphere( trace.HitPos, 5	)
		if entities != nil then
			for k,v in pairs(entities) do
				if v:GetClass() == ("keyframe_rope" or "phys_lengthconstraint") then
					ropeowners[v] = v:GetOwner()
				end
			end
			for k,v in pairs (ropeowners)do
				if v:IsValid() then
					self.Owner:ChatPrint("Owner: ".. v:Nick())
				else
					self.Owner:ChatPrint("This rope does not have an owner")
				end
			end
		end
	end
end


if CLIENT then

	
local matScreen 	= Material( "models/weapons/v_toolgun/screen" )
local txBackground	= surface.GetTextureID( "models/weapons/v_toolgun/screen_bg" )
local RTTexture 	= GetRenderTarget( "GModToolgunScreen", 256, 256 )

local function DrawText1( text, y, texwide )

	local w, h = surface.GetTextSize( text  )
	w = w + 64

	y = y - h / 2 -- Center text to y position

	local x = RealTime() * 250 % w * -1

	while ( x < texwide ) do
	

		surface.SetTextColor( 255, 255, 0, 255 )
		surface.SetTextPos( 3, 58 )
		surface.DrawText( text )

		x = x + w

	end

end

local function DrawText2( text, y, texwide )

	local w, h = surface.GetTextSize( text  )
	w = w + 64

	y = y - h / 2 -- Center text to y position

	local x = RealTime() * 250 % w * -1

	while ( x < texwide ) do
		surface.SetTextColor( 255, 255, 0, 255 )
		surface.SetTextPos( 3, 80 )
		surface.DrawText( text )
		x = x + w

	end

end

local function DrawText3( text, y, texwide )

	local w, h = surface.GetTextSize( text  )
	w = w + 64

	y = y - h / 2 -- Center text to y position

	local x = RealTime() * 250 % w * -1

	while ( x < texwide ) do
		surface.SetTextColor( 255, 255, 0, 255 )
		surface.SetTextPos( 3, 100 )
		surface.DrawText( text )
		x = x + w

	end

end


function SWEP:RenderScreen()
	local TEX_SIZE = 256
	local oldW = ScrW()
	local oldH = ScrH()
	

	matScreen:SetTexture( "$basetexture", RTTexture )
	
	local OldRT = render.GetRenderTarget()

	render.SetRenderTarget( RTTexture )
	render.SetViewPort( 0, 0, TEX_SIZE, TEX_SIZE )
	cam.Start2D()
	

		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetTexture( txBackground )
		surface.DrawTexturedRect( 0, 0, TEX_SIZE, TEX_SIZE )
		surface.SetFont( "Trebuchet24" )
		DrawText1( "Aim at a rope and click", 50, TEX_SIZE )
		DrawText2( "Rope Owners name will ", 50, TEX_SIZE )
		DrawText3( "print to chat", 50, TEX_SIZE )

		cam.End2D()
		render.SetRenderTarget( OldRT )
		render.SetViewPort( 0, 0, oldW, oldH )
	end
	
	
	
end

