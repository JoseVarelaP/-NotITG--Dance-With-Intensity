-- Grab Judgment And Combo.
-- We're gonna tween those bois.
function ComboCommand(self) ComboTween(self) end
function JudgmentCommand(self,n) JudgmentTween(self) end
function HoldCommand(self,n) HoldTween(self) end
-- Animation for Judgment.
function JudgmentTween(self) self:shadowlength(0); self:diffusealpha(0.3); self:zoom(0.5); self:linear(0.15); self:diffusealpha(1); self:zoom(1.1); self:linear(0.05) self:zoom(1) self:sleep(1); self:diffusealpha(0); end
function ComboTween(self) local combo=self:GetZoom(); local newZoom=scale(combo,50,3000,0.7,0.9); self:zoom(0.5*newZoom); self:y(10) self:diffusealpha(0.3) self:linear(0.15); self:zoom(newZoom*1.1); self:y(40) self:diffusealpha(1) self:linear(0.05) self:y(35) self:zoom(newZoom); end
function HoldTween(self) self:shadowlength(0) self:diffusealpha(1) self:y(-64) self:zoom(1) self:linear(1.5) self:addy(-32) self:sleep(0.5) self:diffusealpha(0) end

function DWIVersion()
	--[[
	Because silly me doesn't really understand it.

	Patch version Z (x.y.Z | x > 0) MUST be incremented if only backwards compatible bug fixes are introduced.
	A bug fix is defined as an internal change that fixes incorrect behavior.

	Minor version Y (x.Y.z | x > 0) MUST be incremented if new, backwards compatible functionality is introduced to the public API.
	It MUST be incremented if any public API functionality is marked as deprecated.
	It MAY be incremented if substantial new functionality or improvements are introduced within the private code. 
	It MAY include patch level changes. Patch version MUST be reset to 0 when minor version is incremented.

	Major version X (X.y.z | X > 0) MUST be incremented if any backwards incompatible changes are introduced to the public API.
	It MAY include minor and patch level changes. Patch and minor version MUST be reset to 0 when major version is incremented.

	]]
	return "0.6.2"
end

-- Shorcuts
function ThemeFile( file ) return THEME:GetPath( EC_GRAPHICS, '' , file ) end

-- Get Player Score
function GetScore( pn )
	return STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetScore()
end

function MaxComboGlow(pn)
	local bMaxComboObtained = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):FullCombo()
	if not bMaxComboObtained then return
	else return "glowshift"
	end
end

function RadarValue(pn,n)
	-- 0 - Stream
	-- 1 - Voltage
	-- 2 - Air
	-- 3 - Freeze
	-- 4 - Chaos
	return GAMESTATE:GetCurrentSteps(pn):GetRadarValues(pn):GetValue(n)
end

function RadarValueNonstop(pn,n)
	-- 0 - Stream
	-- 1 - Voltage
	-- 2 - Air
	-- 3 - Freeze
	-- 4 - Chaos
	return GAMESTATE:GetCurrentTrail(pn):GetRadarValues(pn):GetValue(n)
end

-- get a formatted max combo text, sine Lua's string.format
function GetFormattedMaxCombo(pn)
    return string.format("% 4d",STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):MaxCombo())
end

function TitleMusicRedirect()
	if PStage(PLAYER_1) >= 1 or PStage(PLAYER_2) >= 1 then 
		return "ScreenEvaluationSummaryTitle"
	else
		return "ScreenTitleMenu"
	end
end

function SetEvaluationNextScreen()
	Trace( "GetGameplayNextScreen: " )
	Trace( " AllFailed = "..tostring(AllFailed()) )
	Trace( " IsEventMode = "..tostring(GAMESTATE:IsEventMode()) )
	Trace( " IsFinalStage = "..tostring(IsFinalStage()) )

	if GAMESTATE:IsEventMode() then return SongSelectionScreen() end
	if AllFailed() or IsFinalStage() then return "ScreenEvaluationSummary" end
	return SongSelectionScreen();
end

function GetGameplayNextScreen()
	Trace( "GetGameplayNextScreen: " )
	Trace( " AllFailed = "..tostring(AllFailed()) )
	Trace( " IsEventMode = "..tostring(GAMESTATE:IsEventMode()) )
	Trace( " IsSyncDataChanged = "..tostring(GAMESTATE:IsSyncDataChanged()) )

	if GAMESTATE:IsSyncDataChanged() then 
		return "ScreenSaveSync"
	end
		
	-- Never show evaluation for training.
	-- Since it's not really neccesary.
	if GAMESTATE:GetCurrentSong():GetSongDir() == "Songs/In The Groove/Training1/" then 
		if GAMESTATE:IsEventMode() then 
			return SongSelectionScreen()
		else
			return EvaluationNextScreen()
		end
	elseif AllFailed() and not GAMESTATE:IsCourseMode() then 
		if GAMESTATE:IsEventMode() then 
			return SelectEvaluationScreen()
		else
			return "ScreenEvaluationStage"
		end
	else 
		return SelectEvaluationScreen() 
	end
	
	return "GetGameplayNextScreen: YOU SHOULD NEVER GET HERE"
end


function ScrollBarPos()
	if string.find(string.lower(PREFSMAN:GetPreference('DisplayAspectRatio')), '1.7777') then 
		return 260
	else
		return 152
	end 
end

-- Lifebar Stuff
function LifeBarLength()
	if string.find(string.lower(PREFSMAN:GetPreference('DisplayAspectRatio')), '1.7777') then 
		return 388
	else
		return 289
	end 
end

function LifeBarP1PosX()
	if string.find(string.lower(PREFSMAN:GetPreference('DisplayAspectRatio')), '1.7777') then
		return SCREEN_CENTER_X-232
	else
		return SCREEN_CENTER_X-176
	end
end

function LifeBarP2PosX()
	if string.find(string.lower(PREFSMAN:GetPreference('DisplayAspectRatio')), '1.7777') then 
		return SCREEN_CENTER_X+232
	else
		return SCREEN_CENTER_X+176
	end
end

-- Get Final Grade for Player
function FinalGrade( pn ) return STATSMAN:GetFinalGrade(pn) end
-- Get Player Difficulty Meter
function PMeter( pn ) return GAMESTATE:GetCurrentSteps(pn):GetMeter() end
-- Get Player Difficulty
function PDiff( pn ) return GAMESTATE:GetCurrentSteps(pn):GetDifficulty() end
-- Get Player Stage Number
function PStage( pn ) return PROFILEMAN:GetProfile(pn):GetTotalNumSongsPlayed() end
-- Get Current Sort Order
function SortOrder( n ) return GAMESTATE:GetSortOrder(n) end
-- Get Player Trail Difficulty
function TDiff( pn ) return GAMESTATE:GetCurrentTrail(pn):GetDifficulty() end
-- Get Total Score for Summary Screen And Normal EventMode Results
function GetTotalScore( pn ) return STATSMAN:GetAccumStageStats():GetPlayerStageStats(pn):GetScore() end
-- Get Specific Tap Note Score for Summary Screen
function GetPSStats( pn ) return STATSMAN:GetAccumStageStats():GetPlayerStageStats(pn) end

-- You probably saw this in SL and SLGJUVM's Code.
-- I just love how this makes it simple to do stuff.
function OptionRowBase(name,modList)
	local t = {
		Name = name or 'Unnamed Options',
		LayoutType = (ShowAllInRow and 'ShowAllInRow') or 'ShowOneInRow',
		SelectType = 'SelectOne',
		OneChoiceForAllPlayers = false,
		ExportOnChange = true,
		Choices = modList or {'Off','On'},
		LoadSelections = function(self, list, pn) list[1] = true end,
		SaveSelections = function(self, list, pn)	 end
	}
	return t
end

function DWIAnnouncer()
	local t = OptionRowBase('DWIAnnouncer')
	local Pr = PROFILEMAN:GetMachineProfile():GetSaved()
	t.LayoutType = "ShowAllInRow"
	t.OneChoiceForAllPlayers = true
	t.Choices = { "On", "Off" }
	t.LoadSelections = function(self, list, pn) if not Pr.DWIAnnouncer then list[2] = true elseif Pr.DWIAnnouncer then list[1] = true else list[2] = true end end
	t.SaveSelections = function(self, list, pn)
		if list[1] then Pr.DWIAnnouncer = true; end
		if list[2] then Pr.DWIAnnouncer = false; end
	end
	return t
end

function DWIBeatNum()
	local t = OptionRowBase('DWIBeatNum')
	local Pr = PROFILEMAN:GetMachineProfile():GetSaved()
	t.LayoutType = "ShowAllInRow"
	t.OneChoiceForAllPlayers = true
	t.Choices = { "On", "Off" }
	t.LoadSelections = function(self, list, pn) if not Pr.DWIBeatNum then list[2] = true elseif Pr.DWIBeatNum then list[1] = true else list[2] = true end end
	t.SaveSelections = function(self, list, pn)
		if list[1] then Pr.DWIBeatNum = true; end
		if list[2] then Pr.DWIBeatNum = false; end
	end
	return t
end

function DWIITGReceptor()
	local t = OptionRowBase('DWIITGReceptor')
	local Pr = PROFILEMAN:GetMachineProfile():GetSaved()
	t.LayoutType = "ShowAllInRow"
	t.OneChoiceForAllPlayers = true
	t.Choices = { "In The Groove", "Dance With Intensity" }
	t.LoadSelections = function(self, list, pn) if not Pr.DWIITGReceptor then list[2] = true elseif Pr.DWIITGReceptor then list[1] = true else list[2] = true end end
	t.SaveSelections = function(self, list, pn)
		if list[1] then Pr.DWIITGReceptor = true; end
		if list[2] then Pr.DWIITGReceptor = false; end
	end
	return t
end

function DWIPercentageShow()
	local t = OptionRowBase('DWIPercentageShow')
	local Pr = PROFILEMAN:GetMachineProfile():GetSaved()
	t.LayoutType = "ShowAllInRow"
	t.OneChoiceForAllPlayers = true
	t.Choices = { "Number Scoring", "Percentage Scoring" }
	t.LoadSelections = function(self, list, pn) if not Pr.DWIPercentageShow then list[1] = true elseif Pr.DWIPercentageShow then list[2] = true else list[1] = true end end
	t.SaveSelections = function(self, list, pn)
		if list[1] then Pr.DWIPercentageShow = false; end
		if list[2] then Pr.DWIPercentageShow = true; end
	end
	return t
end

function DWIRandomCompany()
	local t = OptionRowBase('DWIRandomCompany')
	local Pr = PROFILEMAN:GetMachineProfile():GetSaved()
	t.LayoutType = "ShowAllInRow"
	t.OneChoiceForAllPlayers = true
	t.Choices = { "Enable", "Disable" }
	t.LoadSelections = function(self, list, pn) if not Pr.DWIRandomCompany then list[1] = true elseif Pr.DWIRandomCompany then list[2] = true else list[1] = true end end
	t.SaveSelections = function(self, list, pn)
		if list[1] then Pr.DWIRandomCompany = false; end
		if list[2] then Pr.DWIRandomCompany = true; end
	end
	return t
end

function DWIToggleDemonstration()
	local t = OptionRowBase('DWIToggleDemonstration')
	local Pr = PROFILEMAN:GetMachineProfile():GetSaved()
	t.LayoutType = "ShowAllInRow"
	t.OneChoiceForAllPlayers = true
	t.Choices = { "Enable", "Disable" }
	t.LoadSelections = function(self, list, pn) if not Pr.DWIToggleDemonstration then list[2] = true elseif Pr.DWIToggleDemonstration then list[1] = true else list[2] = true end end
	t.SaveSelections = function(self, list, pn)
		if list[1] then Pr.DWIToggleDemonstration = true; end
		if list[2] then Pr.DWIToggleDemonstration = false; end
	end
	return t
end

function DemoTimer()
	local Pr = PROFILEMAN:GetMachineProfile():GetSaved()
	if Pr.DWIToggleDemonstration then
		return 60
	else
		return 9999999999999
	end
end

function RandomSongForSelectScreen()
	local SD = GAMESTATE:GetRandomSong():GetSongDir()
	return SD
end


function DWI_StrSplit(str, delim, maxNb)
	-- Eliminate bad cases...
	if string.find(str, delim) == nil then
		return { str }
	end
	if maxNb == nil or maxNb < 1 then
		maxNb = 0    -- No limit
	end
		local result = {}
		local pat = '(.-)' .. delim .. '()'
		local nb = 0
		local lastPos
			for part, pos in string.gfind(str, pat) do
				nb = nb + 1
				result[nb] = part
				lastPos = pos
			if nb == maxNb then break end
				end
			-- Handle the last field
				if nb ~= maxNb then
					result[nb + 1] = string.sub(str, lastPos)
				end
			return result
		end

				
				function DWI_GroupName(song)
					if song and DWI_StrSplit(song:GetSongDir(),'/') and DWI_StrSplit(song:GetSongDir(),'/')[3] then
						return DWI_StrSplit(song:GetSongDir(),'/')[3]
					else
						return ''
					end
				end



-- Please, ignore this bullshitery
--

local CompanyNames = {
	"BENAMI",
	"KONMAI",
	"Manco",
	"KONAMIRO",
	"ANDAMI",
	"BBBBBB",
	"ROXXXOR",
	"MOMANI",
	"MONAKAI",
	"KONAMIWILLSUE",
	"NOKOMI",
	"NAOKIM",
	"Plinko machines inc.",
	"NAYOKI",
	"NAOKI M.",
	"Naoki 180",
	"DANBAI MANCO",
	"MONKAI",
	"SENDAI NO BAKUDAN",
	"KANOMI",
	"DAISAN NO BAKUDAN",
	"SENPAI KONMAI",
	"BITES ZA DUSTO",
	"BOXXOROXXOXOR",
	"WE NEED MOAR",
	"MAIKON",
	"ITGKiller inc.",
	"TAKIO",
	"SHAEM",
	"SANPOI",
	"BETASTREM",
	"BUTTMANAIC",
	"KONMUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU",
	"VORTEX^TEN",
	"USO",
	"Kyle Weird",
	"STEPMANIAX",
	"dakimakura",
	"PIUX",
	"PIG: Pump It Groove",
	"Not Open Pump it Up: Stepmania version",
	"PTGR: Pump the groove revolution",
	"ITPIU: In The Pump It Up.",
	"PTUG",
	"NOITPIUS",
	"Pump The Groove Up",
	"TEAM DRAGONFORCE",
	}

	function GetRandomCompanyName()
		return CompanyNames[math.random(1,table.getn(CompanyNames))]
	end