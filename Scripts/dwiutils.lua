-- Grab Judgment, Combo and Hold NG/OK.
function ComboCommand(self) ComboTween(self) end
function JudgmentCommand(self,n) JudgmentTween(self) end
function HoldCommand(self,n) HoldTween(self) end
-- Animation for Judgment.
function JudgmentTween(self) self:shadowlength(0); self:diffusealpha(0.3); self:zoom(0.5); self:linear(0.15); self:diffusealpha(1); self:zoom(1.1); self:linear(0.05) self:zoom(1) self:sleep(1); self:diffusealpha(0); end
-- Animation for Combo.
function ComboTween(self) local combo=self:GetZoom(); local newZoom=scale(combo,50,3000,0.7,0.9); self:zoom(0.5*newZoom); self:y(10) self:diffusealpha(0.3) self:linear(0.15); self:zoom(newZoom*1.1); self:y(40) self:diffusealpha(1) self:linear(0.05) self:y(35) self:zoom(newZoom); end
-- Animation for Hold NG/OK.
function HoldTween(self) self:shadowlength(0) self:diffusealpha(1) self:y(-64) self:zoom(1) self:linear(1.5) self:addy(-32) self:sleep(0.5) self:diffusealpha(0) end
-- Animation for Debug Text
function DebugTween(self)
		self:finishtweening()
		self:x(SCREEN_LEFT+5)
		self:y(SCREEN_TOP)
		self:horizalign("left")
		self:vertalign("top")
		self:zoom(0)
			if IsUsingWideScreen() then
				self:wrapwidthpixels(SCREEN_WIDTH*2.0)
			else
				self:wrapwidthpixels(SCREEN_WIDTH*1.2)
			end
		self:shadowlength(2)
		self:sleep(0.01)
		self:zoom(0.5)
end

-- Version Number.
function DWIVersion() return "1.4.5" end
function DWIVerDate() return "5/September/2017" end

-- Shorcuts
function ThemeFile( file ) return THEME:GetPath( EC_GRAPHICS, '' , file ) end
function AudioPlay( file ) return SOUND:PlayOnce( THEME:GetPath( EC_SOUNDS, '', file ) ) end

-- Get Possible Dance Points
function ScorePossible( pn ) return STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetPossibleDancePoints() end
-- Get Actual/Current Dance Points.
function ScoreActual( pn ) return STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetActualDancePoints() end

-- Get Player Score
function GetScore( pn ) return STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetScore() end

-- Determines if Max Combo number glows
function MaxComboGlow(pn)
	local bMaxComboObtained = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):FullCombo()
	if not bMaxComboObtained then return
	else return "glowshift"
	end
end

-- Checks if the game is being run at Widescreen.
-- Thanks to MadkaT for the suggestion.
-- I had to rewrite the code however as GetScreenAspectRatio() doesn't actually exist in OITG.
-- However, we have GetPreference, so we can track the number and apply it to that.

-- Initially it was " if math.floor at PREFSMAN:GetPreference( 'DisplayAspectRatio' ) multiplied by 100000 and divided by 100000 was higher than 1.333333. "
-- BrotherMojo noticed this, and provided with a result that was really self-explanatory. There was no need for a floor.
-- Instead just make it check that the value is higher than 1.34.
-- since PREFSMAN:GetPreference( 'DisplayAspectRatio' ) gives you 12 decimals.
-- In 4:3 is 1.333333700492, and 16:9 is 1.777777982301 so, making it check for a value higher than 1.34 was pretty logical.
function IsUsingWideScreen()
    return PREFSMAN:GetPreference( 'DisplayAspectRatio' ) > 1.34
end

-- Checks if the Characters are Enabled.
-- 1 and 2 are going to enable the characters, no matter what.
-- This is used for the 3D note overlaping Fix.
function HasCharactersEnabled()
    return PREFSMAN:GetPreference( 'ShowDancingCharacters' ) > 1
end

-- Checks if both players are enabled to activate the option to start Battle mode.
function SongWheelOrderList()
	local Version = 'Group,'
	local Difficulty = 'EasyMeter,MediumMeter,HardMeter,ExpertMeter,'
	local NormalStuff = 'Title,Artist,Bpm,Popularity,'

	if GAMESTATE:IsPlayerEnabled(PLAYER_1) and GAMESTATE:IsPlayerEnabled(PLAYER_2) then
		return Version .. Difficulty .. NormalStuff ..'Dance,Battle'
	else
		return Version .. Difficulty .. NormalStuff
	end
end

-- For Battle mode's combined lifebar.
function BattleModeLifeBarLength()
	if IsUsingWideScreen() then
		return 800
	else
		return 630
	end
end


-- Data needed for the Summary screen and also for the Perfect percentage in the ProfileCheck Screen.
-- Also this is added for compatibility, and stability, just in case you delete these strings from default
-- and you don't know how they were written.
function GetActual( stepsType )
	return 
		PROFILEMAN:GetMachineProfile():GetSongsActual(stepsType,DIFFICULTY_EASY)+
		PROFILEMAN:GetMachineProfile():GetSongsActual(stepsType,DIFFICULTY_MEDIUM)+
		PROFILEMAN:GetMachineProfile():GetSongsActual(stepsType,DIFFICULTY_HARD)+
		PROFILEMAN:GetMachineProfile():GetSongsActual(stepsType,DIFFICULTY_CHALLENGE)+
		PROFILEMAN:GetMachineProfile():GetCoursesActual(stepsType,COURSE_DIFFICULTY_REGULAR)+
		PROFILEMAN:GetMachineProfile():GetCoursesActual(stepsType,COURSE_DIFFICULTY_DIFFICULT)
end

function GetPossible( stepsType )
	return 
		PROFILEMAN:GetMachineProfile():GetSongsPossible(stepsType,DIFFICULTY_EASY)+
		PROFILEMAN:GetMachineProfile():GetSongsPossible(stepsType,DIFFICULTY_MEDIUM)+
		PROFILEMAN:GetMachineProfile():GetSongsPossible(stepsType,DIFFICULTY_HARD)+
		PROFILEMAN:GetMachineProfile():GetSongsPossible(stepsType,DIFFICULTY_CHALLENGE)+
		PROFILEMAN:GetMachineProfile():GetCoursesPossible(stepsType,COURSE_DIFFICULTY_REGULAR)+
		PROFILEMAN:GetMachineProfile():GetCoursesPossible(stepsType,COURSE_DIFFICULTY_DIFFICULT)
end

function GetTotalPercentComplete( stepsType )
	return GetActual(stepsType) / (0.96*GetPossible(stepsType))
end

function GetSongsPercentComplete( stepsType, difficulty )
	return PROFILEMAN:GetMachineProfile():GetSongsPercentComplete(stepsType,difficulty)/0.96
end

function GetCoursesPercentComplete( stepsType, difficulty )
	return PROFILEMAN:GetMachineProfile():GetCoursesPercentComplete(stepsType,difficulty)/0.96
end

function GetExtraCredit( stepsType )
	return GetActual(stepsType) - (0.96*GetPossible(stepsType))
end

function GetMaxPercentCompelte( stepsType )
	return 1/0.96;
end

-- Data needed for the Summary screen and also for the Perfect percentage in the ProfileCheck Screen.
-- Also this is added for compatibility, and stability, just in case you delete these strings from default
-- and you don't know how they were written.
function GetActual( stepsType )
	return 
		PROFILEMAN:GetMachineProfile():GetSongsActual(stepsType,DIFFICULTY_EASY)+
		PROFILEMAN:GetMachineProfile():GetSongsActual(stepsType,DIFFICULTY_MEDIUM)+
		PROFILEMAN:GetMachineProfile():GetSongsActual(stepsType,DIFFICULTY_HARD)+
		PROFILEMAN:GetMachineProfile():GetSongsActual(stepsType,DIFFICULTY_CHALLENGE)+
		PROFILEMAN:GetMachineProfile():GetCoursesActual(stepsType,COURSE_DIFFICULTY_REGULAR)+
		PROFILEMAN:GetMachineProfile():GetCoursesActual(stepsType,COURSE_DIFFICULTY_DIFFICULT)
end

function GetPossible( stepsType )
	return 
		PROFILEMAN:GetMachineProfile():GetSongsPossible(stepsType,DIFFICULTY_EASY)+
		PROFILEMAN:GetMachineProfile():GetSongsPossible(stepsType,DIFFICULTY_MEDIUM)+
		PROFILEMAN:GetMachineProfile():GetSongsPossible(stepsType,DIFFICULTY_HARD)+
		PROFILEMAN:GetMachineProfile():GetSongsPossible(stepsType,DIFFICULTY_CHALLENGE)+
		PROFILEMAN:GetMachineProfile():GetCoursesPossible(stepsType,COURSE_DIFFICULTY_REGULAR)+
		PROFILEMAN:GetMachineProfile():GetCoursesPossible(stepsType,COURSE_DIFFICULTY_DIFFICULT)
end

function GetTotalPercentComplete( stepsType )
	return GetActual(stepsType) / (0.96*GetPossible(stepsType))
end

function GetSongsPercentComplete( stepsType, difficulty )
	return PROFILEMAN:GetMachineProfile():GetSongsPercentComplete(stepsType,difficulty)/0.96
end

function GetCoursesPercentComplete( stepsType, difficulty )
	return PROFILEMAN:GetMachineProfile():GetCoursesPercentComplete(stepsType,difficulty)/0.96
end

function GetExtraCredit( stepsType )
	return GetActual(stepsType) - (0.96*GetPossible(stepsType))
end

function GetMaxPercentCompelte( stepsType )
	return 1/0.96;
end

-- Stage Number for Gameplay, Select Music and Evaluation
function StageNumberAdded()
	if GAMESTATE:StageIndex()+1 == 1 or GAMESTATE:StageIndex()+1 == 21 or GAMESTATE:StageIndex()+1 == 31 then 
		return GAMESTATE:StageIndex()+1 ..'st'
	elseif GAMESTATE:StageIndex()+1 == 2 or GAMESTATE:StageIndex()+1 == 22 or GAMESTATE:StageIndex()+1 == 32 then 
		return GAMESTATE:StageIndex()+1 ..'nd'
	elseif GAMESTATE:StageIndex()+1 == 3 or GAMESTATE:StageIndex()+1 == 23 or GAMESTATE:StageIndex()+1 == 33 then 
		return GAMESTATE:StageIndex()+1 ..'rd'
	elseif GAMESTATE:StageIndex()+1 > 99 then 
		return GAMESTATE:StageIndex()+1
	else
		return GAMESTATE:StageIndex()+1 ..'th'
	end
end

-- Stage Number for Normal occasions
function StageNumber()
	if GAMESTATE:StageIndex() == 1 or GAMESTATE:StageIndex() == 21 or GAMESTATE:StageIndex() == 31 then 
		return GAMESTATE:StageIndex() ..'st'
	elseif GAMESTATE:StageIndex() == 2 or GAMESTATE:StageIndex() == 22 or GAMESTATE:StageIndex() == 32 then 
		return GAMESTATE:StageIndex() ..'nd'
	elseif GAMESTATE:StageIndex() == 3 or GAMESTATE:StageIndex() == 23 or GAMESTATE:StageIndex() == 33 then 
		return GAMESTATE:StageIndex() ..'rd'
	elseif GAMESTATE:StageIndex() > 99 then 
		return GAMESTATE:StageIndex()
	else
		return GAMESTATE:StageIndex() ..'th'
	end
end

-- Character stuff
function CharacterTransferCheckEnd()
	local s = "ScreenSelect"

	-- Check for Dance
	if GAMESTATE:GetPlayMode() == 0 then s = s..'Music' end

	-- Check for Nonstop
	if GAMESTATE:GetPlayMode() == 1 then s = s..'Course' end

	return s
end

function CharacterTransferCheckStart()
	local s = "ScreenSelect";
	
	-- Dancing Characters are on "SELECT"? Send them to this screen.
	if string.find(string.lower(PREFSMAN:GetPreference('ShowDancingCharacters')), '2') then
		s = s.."Character"
	end

	-- Dancing Characters are on "DEFAULT TO OFF" or "DEFAULT TO RANDOM"? Send them to their respective next screens.
	if GAMESTATE:GetPlayMode() == 0 and not string.find(string.lower(PREFSMAN:GetPreference('ShowDancingCharacters')), '2') then
		s = s..'Music'
	end
	if GAMESTATE:GetPlayMode() == 1 and not string.find(string.lower(PREFSMAN:GetPreference('ShowDancingCharacters')), '2') then
		s = s..'Course'
	end

	return s
end

-- THE HUGE ANNOUNCER DATA VALUE TREE.

function AnnouncerAudio()

	-- AAAA
    if STATSMAN:GetBestGrade() == 0 then
        return 'Internal/eval/AAA/sss-00'
    end
    
    -- AAA and AAAA
    if STATSMAN:GetBestGrade() >= 1 and STATSMAN:GetBestGrade() < 2 then
		return 'Internal/eval/AAA/sss-00'
    end

    -- AA
    if STATSMAN:GetBestGrade() >= 2 or STATSMAN:GetBestGrade() <= 3  then
    	return 'Internal/eval/AA/s-0'.. RandomNumber
    end

    -- A
    if STATSMAN:GetBestGrade() >= 3 or STATSMAN:GetBestGrade() <= 4 then
    	return 'Internal/eval/A/a-0'.. RandomNumber
    end
                        
    -- B
    if STATSMAN:GetBestGrade() >= 4 and STATSMAN:GetBestGrade() < 5 then
    	return 'Internal/eval/B/b-0'.. RandomNumber
    end
     
    -- C
    if STATSMAN:GetBestGrade() >= 5 and STATSMAN:GetBestGrade() < 6 then
    	return 'Internal/eval/C/c-0'.. RandomNumber
   end
   
   -- D
   if STATSMAN:GetBestGrade() >= 7 and STATSMAN:GetBestGrade() < 8 then
    	return 'Internal/eval/D/d-0'.. RandomNumber
    end
    
    -- E
   if STATSMAN:GetBestGrade() >= 6 and STATSMAN:GetBestGrade() < 7 then
       return 'Internal/eval/E/e-0'.. RandomNumber
    end
                        
	-- F
    if STATSMAN:GetBestGrade() > 7 then
	return 'Internal/eval/E/e-0'.. RandomNumber
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
function GetFormattedMaxCombo(pn) return string.format("% 4d",STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):MaxCombo()) end

-- If the player has passed AT LEAST one song, take them to the Summary screen if they back out.
-- Otherwise, return them to the main menu.
function TitleMusicRedirect()
	if GAMESTATE:StageIndex() >= 1 then 
		return "ScreenEvaluationSummaryTitle"
	else
		return "ScreenTitleMenu"
	end
end

-- Set the next screen for Evaluation.
function SetEvaluationNextScreen()
	Trace( "GetGameplayNextScreen: " )
	-- If all failed the song
	Trace( " AllFailed = "..tostring(AllFailed()) )
	-- If the game is in Event Mode.
	Trace( " IsEventMode = "..tostring(GAMESTATE:IsEventMode()) )
	-- If it's the Final Stage.
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

function DangerSize()
	if IsUsingWideScreen() then 
		return 0.75
	else
		return 0.5
	end 
end


function ScrollBarPos()
	function AsRatio(n)
		return string.find(string.lower(PREFSMAN:GetPreference('DisplayAspectRatio')), n)
	end
	if AsRatio(1.7777) then
		return 260
	elseif AsRatio(1.600) then
		return 220
	else
		return 152
	end 
end

-- Lifebar Stuff
function LifeBarLength()
	if IsUsingWideScreen() then 
		return 388
	else
		return 289
	end 
end

function StripsNumber()
	if IsUsingWideScreen() then 
		return 66
	else
		return 33
	end 
end

function LifeBarP1PosX()
	if IsUsingWideScreen() then
		return SCREEN_CENTER_X-232
	else
		return SCREEN_CENTER_X-176
	end
end

function LifeBarP2PosX()
	if IsUsingWideScreen() then 
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
-- Get Specific Tap Note Score for Normal Evaluation
function GetPSStageStats( pn ) return STATSMAN:GetCurStageStats():GetPlayerStageStats(pn) end

-- Position For Players
function PlayerPositionP1()
	if CurStyleName() == 'solo' then
		return SCREEN_CENTER_X
	else
		return SCREEN_CENTER_X-(SCREEN_WIDTH*160/640)
	end
end

function PlayerPositionP2()
	if CurStyleName() == 'solo' then
		return SCREEN_CENTER_X
	else
		return SCREEN_CENTER_X+(SCREEN_WIDTH*160/640)
	end
end

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
	t.LoadSelections = function(self, list, pn) if not Pr.DWIRandomCompany then list[2] = true elseif Pr.DWIRandomCompany then list[1] = true else list[2] = true end end
	t.SaveSelections = function(self, list, pn)
		if list[1] then Pr.DWIRandomCompany = true; PROFILEMAN:SaveMachineProfile() end
		if list[2] then Pr.DWIRandomCompany = false; PROFILEMAN:SaveMachineProfile() end
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

function DWIHighestSessionScore()
	local t = OptionRowBase('DWIHighestSessionScore')
	local Pr = PROFILEMAN:GetMachineProfile():GetSaved()
	t.LayoutType = "ShowAllInRow"
	t.OneChoiceForAllPlayers = true
	t.Choices = { "Highest Total Session", "Highest Single" }
	t.LoadSelections = function(self, list, pn) if not Pr.DWIHighestSessionScore then list[2] = true elseif Pr.DWIHighestSessionScore then list[1] = true else list[2] = true end end
	t.SaveSelections = function(self, list, pn)
		if list[1] then Pr.DWIHighestSessionScore = true; end
		if list[2] then Pr.DWIHighestSessionScore = false; end
	end
	return t
end

function DWIShowProfileInSelectMusic()
	local t = OptionRowBase('DWIShowProfileInSelectMusic')
	local Pr = PROFILEMAN:GetMachineProfile():GetSaved()
	t.LayoutType = "ShowAllInRow"
	t.OneChoiceForAllPlayers = true
	t.Choices = { "Show", "Hide" }
	t.LoadSelections = function(self, list, pn) if not Pr.DWIShowProfileInSelectMusic then list[2] = true elseif Pr.DWIShowProfileInSelectMusic then list[1] = true else list[2] = true end end
	t.SaveSelections = function(self, list, pn)
		if list[1] then Pr.DWIShowProfileInSelectMusic = true; end
		if list[2] then Pr.DWIShowProfileInSelectMusic = false; end
	end
	return t
end

-- The timer for Demonstration.
-- Thanks to LDanii for pointing this out, because i forgot
-- That DWI had a option to disable the demonstration.
function DemoTimer()
	local Pr = PROFILEMAN:GetMachineProfile():GetSaved()
	if Pr.DWIToggleDemonstration then
		return 60
	else
		return 0
	end
end

-- Unfortunately this doesn't work in OpenITG.
-- So, it's likely i'll remove this bit of code laters
function RandomSongForSelectScreen()
	local SD = GAMESTATE:GetRandomSong():GetSongDir()
	return SD
end

function DWI_StrSplit(str, delim, maxNb)
	-- (Español)
	-- Elimina los malos casos donde el archivo
	-- Marque un formato NIL que significa que
	-- NO existe, o que el juego simplemente
	-- NO puede leer.

	-- (English)
	-- Delete the bad cases where the file
	-- Marks a NIL format that marks that
	-- it DOESN'T exist, or that the game
	-- simply CAN'T read it.

	-- If the file marks in then we mark str only.
	if string.find(str, delim) == nil then
		return { str }
	end
	-- if the maxNb is NIl or is less than 1 then we don't apply a limit.
	if maxNb == nil or maxNb < 1 then
		maxNb = 0    -- No hay que aplicar limite.
	end
		-- We stablish locals to help with the result string.
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
			-- Controla el ultimo campo.
			-- Controls the last field
				if nb ~= maxNb then
					result[nb + 1] = string.sub(str, lastPos)
				end
			return result
		end

				-- Al terminar de controlar todo de DWI_StrSplit, al cortar, aplica el texto en el lector.
				function DWI_GroupName(song)
					if song and DWI_StrSplit(song:GetSongDir(),'/') and DWI_StrSplit(song:GetSongDir(),'/')[3] then
						return DWI_StrSplit(song:GetSongDir(),'/')[3]
					else
						return ''
					end
				end

-- Save the profile contents of the players.
-- Thanks to Sora for pointing out some bloddy obvious mistakes.
-- The mistakes weren't crashes... but messy code.
function SaveToProfile()
	
	local Pr = PROFILEMAN:GetMachineProfile():GetSaved()

	local function StatsCombined(pn, n1, n2, n3)
		return GetPSStageStats(pn):GetTapNoteScores(n1) + GetPSStageStats(pn):GetTapNoteScores(n2) + GetPSStageStats(pn):GetTapNoteScores(n3)
	end

	local GameSecs = STATSMAN:GetCurStageStats():GetGameplaySeconds()

	if GAMESTATE:IsPlayerEnabled(PLAYER_1) then

		if not GAMESTATE:IsCourseMode() then

        	Pr.DWITotalStepsHitP1 = Pr.DWITotalStepsHitP1 + StatsCombined(PLAYER_1, 8, 7, 6)

        	Pr.DWITotalSongsPlayedP1 = Pr.DWITotalSongsPlayedP1 + 1
        
        	if GetScore(PLAYER_1) > Pr.DWIHighestScoreP1 then Pr.DWIHighestScoreP1 = GetScore(PLAYER_1) end

        	if GetTotalScore(PLAYER_1) > Pr.DWIHighestSessionScoreP1 then Pr.DWIHighestSessionScoreP1 = GetTotalScore(PLAYER_1) end

        	if GetPSStageStats(PLAYER_1):MaxCombo() > Pr.DWIHighestComboP1 then Pr.DWIHighestComboP1 = GetPSStageStats(PLAYER_1):MaxCombo() end

    	else

    		Pr.DWITotalStepsHitP1 = Pr.DWITotalStepsHitP1 + StatsCombined(PLAYER_1, 8, 7, 6)

			if GameSecs > Pr.DWILongestTimeNonstopP1 then Pr.DWILongestTimeNonstopP1 = GameSecs end

			if GetPSStageStats(PLAYER_1):MaxCombo() > Pr.DWIHighestComboNonstopP1 then Pr.DWIHighestComboNonstopP1 = GetPSStageStats(PLAYER_1):MaxCombo() end

			if GetScore(PLAYER_1) > Pr.DWIHighestScoreNonstopP1 then Pr.DWIHighestScoreNonstopP1 = GetScore(PLAYER_1) end

        end
        
    end

    if GAMESTATE:IsPlayerEnabled(PLAYER_2) then

    	if not GAMESTATE:IsCourseMode() then

    		Pr.DWITotalStepsHitP2 = Pr.DWITotalStepsHitP2 + StatsCombined(PLAYER_2, 8, 7, 6)

        	Pr.DWITotalSongsPlayedP2 = Pr.DWITotalSongsPlayedP2 + 1
        
        	if GetScore(PLAYER_2) > Pr.DWIHighestScoreP2 then Pr.DWIHighestScoreP2 = GetScore(PLAYER_2) end

        	if GetTotalScore(PLAYER_2) > Pr.DWIHighestSessionScoreP2 then Pr.DWIHighestSessionScoreP2 = GetTotalScore(PLAYER_2) end

        	if GetPSStageStats(PLAYER_2):MaxCombo() > Pr.DWIHighestComboP2 then Pr.DWIHighestComboP2 = GetPSStageStats(PLAYER_2):MaxCombo() end

		else

    		Pr.DWITotalStepsHitP2 = Pr.DWITotalStepsHitP2 + StatsCombined(PLAYER_2, 8, 7, 6)

			if GameSecs > Pr.DWILongestTimeNonstopP2 then Pr.DWILongestTimeNonstopP2 = GameSecs end

			if GetPSStageStats(PLAYER_2):MaxCombo() > Pr.DWIHighestComboNonstopP2 then Pr.DWIHighestComboNonstopP2 = GetPSStageStats(PLAYER_2):MaxCombo() end

			if GetScore(PLAYER_2) > Pr.DWIHighestScoreNonstopP2 then Pr.DWIHighestScoreNonstopP2 = GetScore(PLAYER_2) end

        end

    end

    PROFILEMAN:SaveMachineProfile()
end

-- Profile deletion
function DeleteProfileData(n)
	local Pr = PROFILEMAN:GetMachineProfile():GetSaved()

	local PlayerNumber = n

	if PlayerNumber == 1 then
		Pr.DWITotalStepsHitP1 = 0
		Pr.DWITotalSongsPlayedP1 = 0
		Pr.DWIHighestScoreP1 = 0
		Pr.DWIHighestSessionScoreP1 = 0
		Pr.DWIHighestComboP1 = 0
		Pr.DWILongestTimeNonstopP1 = 0
		Pr.DWIHighestComboNonstopP1 = 0
		Pr.DWIHighestScoreNonstopP1 = 0
	end

	if PlayerNumber == 2 then
		Pr.DWITotalStepsHitP2 = 0
		Pr.DWITotalSongsPlayedP2 = 0
		Pr.DWIHighestScoreP2 = 0
		Pr.DWIHighestSessionScoreP2 = 0
		Pr.DWIHighestComboP2 = 0
		Pr.DWILongestTimeNonstopP2 = 0
		Pr.DWIHighestComboNonstopP2 = 0
		Pr.DWIHighestScoreNonstopP2 = 0
	end

	PROFILEMAN:SaveMachineProfile()
end