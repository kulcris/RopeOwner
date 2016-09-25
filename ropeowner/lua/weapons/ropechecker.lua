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

SWEP.SearchRadius = 5

-- You could even expand this to be a general entity search tool
SWEP.SearchEntities = {
	keyframe_rope = true,
	phys_lengthconstraint = true
}

function SWEP:PrimaryAttack()	
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	local pPlayer = self:GetOwner()
	
	if pPlayer == NULL then
		return false
	end
	
	local entities = ents.FindInSphere(self.Owner:GetEyeTrace().HitPos, self.SearchRadius)
	for i = 1, #entities do
		local pRope = entities[i]
		local sClass = pRope:GetClass()
		
		if self.SearchEntities[sClass] then
			local pOwner = pRope:GetOwner()
			pPlayer:ChatPrint(pOwner:IsPlayer() and string.format("%q owns this %s", pOwner:Nick(), sClass)
				or "This rope has no owner!")
		end
	end
	return true
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

