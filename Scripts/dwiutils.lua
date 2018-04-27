-- Grab Judgment, Combo and Hold NG/OK.
function ComboCommand(self) ComboTween(self) end
function JudgmentCommand(self,n) JudgmentTween(self) end
function HoldCommand(self,n) HoldTween(self) end
-- Animation for Judgment.
function JudgmentTween(self) self:shadowlength(0); self:diffusealpha(0.3); self:zoom(0.6); self:linear(0.13); self:diffusealpha(1); self:zoom(1.1); self:linear(0.05) self:zoom(1) self:sleep(1); self:diffusealpha(0); end
-- Animation for Combo.
function ComboTween(self) local combo=self:GetZoom(); local newZoom=scale(combo,50,3000,0.7,0.9); self:zoom(0.5*newZoom); self:y(10) self:diffusealpha(0.3) self:linear(0.13); self:zoom(newZoom*1.1); self:y(40) self:diffusealpha(1) self:linear(0.05) self:y(35) self:zoom(newZoom); end
-- Animation for Hold NG/OK.
function HoldTween(self) self:shadowlength(0) self:diffusealpha(1) self:y(-64) self:zoom(1) self:linear(1.5) self:addy(-32) self:sleep(0.5) self:diffusealpha(0) end
-- Animation for Debug Text
-- MOVED TO METRICS TO PREVENT CRASHES.
-- Info about it, can be found in the 1.5.0 changelog.

-- Function for neccesary profile request calls.
function Profile() return PROFILEMAN:GetMachineProfile():GetSaved() end
function SaveProfiles() return PROFILEMAN:SaveMachineProfile() end

-- Version Number.
function DWIVersion() return "1.6.8" end
function DWIVerDate() return "13/April/2018" end

-- Shorcuts
function ThemeFile( file ) return THEME:GetPath( EC_GRAPHICS, '' , file ) end
function AudioPlay( file )
	if Profile().DWIAnnouncer then
		return SOUND:PlayOnce( THEME:GetPath( EC_SOUNDS, '', file ) )
	end
end
function FindAspRatio(n) return string.find(string.lower(PREFSMAN:GetPreference('DisplayAspectRatio')), n) end

-- Check for Online mode!
-- This feature does not work in NITG. That one has internet completely removed.
-- Which is why you don't see the option when using NITG.
function OptionsMenuList() if FUCK_EXE then return "1,2,3,6,8,9,10,15,17,18" else return "1,2,3,6,8,9,10,15,17,18,19" end end

-- This is the check for the menu timer.
-- If the menu timer is enabled, then show it. Otherwise hide it. This is what DWI normally did.
-- Not set the timer to 99, just disable/hide it.
function MenuTimer(self) if PREFSMAN:GetPreference("MenuTimer") then self:zoom(1); else self:zoom(0); end self:draworder(109) end

-- Get Possible Dance Points
function ScorePossible( pn, name )
	local CalcPerNames = {
    	["Cur"] = STATSMAN:GetCurStageStats(),
    	["Accum"] = STATSMAN:GetAccumStageStats(),
	}

	return CalcPerNames[name]:GetPlayerStageStats(pn):GetPossibleDancePoints()
end
-- Get Actual/Current Dance Points.
function ScoreActual( pn, name )
	local CalcPerNames = {
    	["Cur"] = STATSMAN:GetCurStageStats(),
    	["Accum"] = STATSMAN:GetAccumStageStats(),
	}

	return CalcPerNames[name]:GetPlayerStageStats(pn):GetActualDancePoints()
end

function AccumProfileScore(self, pn)
	if (OPENITG or FUCK_EXE) and STATSMAN:GetAccumStageStats() then
        if GAMESTATE:IsPlayerEnabled(pn) then
            local poss = STATSMAN:GetAccumStageStats():GetPlayerStageStats(pn):GetPossibleDancePoints()
            local act = STATSMAN:GetAccumStageStats():GetPlayerStageStats(pn):GetActualDancePoints()
            if PStage(pn)+1 == 1 then
                self:settext(GetProfileName(1)..': 0.00%')
            else
                if act/poss <= 0 then
                    self:settext(GetProfileName(1)..': 0.00%')
                else
                    self:settext(GetProfileName(1)..': '.. FormatPercentScore(act/poss))
                end
            end
        end
    end
end

-- Get Player Score
function GetScore( pn ) return STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetScore() end

--[[ 
This is a mayor cleanup for the Scores in ScreenEvaluation and ScreenEvaluationStage.
	n1 looks for the TapNoteScore that is requested.
	n2 is the X position relative to SCREEN_CENTER_X
	n3 is the Y position relative to SCREEN_CENTER_Y
	n4 is the time of sleep multiplied from 0.125
		This is for the start animation, that shows every number individually after the next.
	name is the type of score to look for. "Stage" or "Total". If non of those are picked
	then return an "invalid".
]]
function RecieveTapNoteScore(self, pn, n1, n2, n3, n4, name)
	local NoteType = {
    	["Stage"] = GetPSStageStats(pn),
    	["Total"] = GetPSStats(pn),
	}

	self:x( SCREEN_CENTER_X+n2 )
    self:shadowlength(0)
    self:y( SCREEN_CENTER_Y+n3 )
    self:zoom(0.3)
    --
    if GAMESTATE:IsPlayerEnabled(pn) then
    	if NoteType[name] == nil then
    		self:settext('     ')
    	else
        	self:settext( string.format('% 5d',NoteType[name]:GetTapNoteScores(n1)) )
        end
        self:sleep(0.125*n4)
        self:bounceend(0.4)
        self:zoom(0.6)
    else
        self:settext('     ')
    end
end

-- Find if the mod is being used.
-- If true, then show it.
function ModFind(self, n, name)
	if GAMESTATE:IsPlayerEnabled(n-1) then
		if string.find(SCREENMAN:GetTopScreen():GetChild('PlayerOptionsP'..n):GetText(), name ) then
			self:diffusealpha(1)
		else
			self:diffusealpha(0)
		end
	else
		self:diffusealpha(0)
	end
end

-- Determines if Max Combo number glows
function MaxComboGlow(self, pn)
	self:settext( GetFormattedMaxCombo(pn) )
    if STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):FullCombo() then
        self:glowshift()
    else
        self:diffuse(1,1,0,1)
    end
end

-- Checks who won in Battle Mode.
function WhoIsWinner(self, pn)
	if GAMESTATE:IsWinner(pn) then
       	self:settext('Winner!')
       	self:diffuse(238/255,221/255,0,1)
       	self:glowshift()
   	elseif not GAMESTATE:IsWinner(PLAYER_1) and not GAMESTATE:IsWinner(PLAYER_2) then
       	self:settext('Tie.')
       	self:diffuse(1,1,1,1)
   	else
       	self:settext('Loser...')
       	self:diffuse(0.5,0.5,0.5,1)
   	end
end

-- Calculates the percentage that you see in ScreenEvaluation.
function CalculatePercentage(self, pn, name)
	local CalcPerNames = {
    	["Cur"] = STATSMAN:GetCurStageStats(),
    	["Accum"] = STATSMAN:GetAccumStageStats(),
	}

    if (FUCK_EXE or OPENITG) and CalcPerNames[name] and GAMESTATE:IsPlayerEnabled(pn) then
        local GPSS = CalcPerNames[name]:GetPlayerStageStats(pn);
        self:settext( FormatPercentScore( GPSS:GetActualDancePoints()/GPSS:GetPossibleDancePoints() ) )
    else
        self:settext(' ')
    end
end

JudgmentColors = {
	Marvelous = {0,0.5,1},
	Perfect = {1,1,0},
	Great = {0,1,0},
	Good = {0,1,1},
	Boo = {1,0,1},
}

-- This whooooole three commands are for the judgment window display that you see in display options.
-- This one sets the Quad length of the judgment.
function JudgmentWindowPreviewSet(self, name)
    self:zoomto(100,5);
    self:horizalign('left')
    self:shadowlength(0);
    self:diffuse( JudgmentColors[name][1],JudgmentColors[name][2],JudgmentColors[name][3],1 )

    self:cropright( 1 - ( PREFSMAN:GetPreference( 'JudgeWindowScale' ) * PREFSMAN:GetPreference( 'JudgeWindowSeconds'..name ) ) )
end

-- This one, sets the marker for it, at the end of the quad of said judgment.
function JudgmentWindowPreviewMarker(self, name)
    self:zoomto(1,20);
    self:horizalign('left')
    self:shadowlength(0);

    self:x( (PREFSMAN:GetPreference( 'JudgeWindowScale' ) * PREFSMAN:GetPreference( 'JudgeWindowSeconds'..name ) ) * 310 )
end

-- This one gathers the data from said window, as a number.
-- Judgment in OITG works with a scale, so, Judgment Windows don't get
-- affected heavily, but just get multiplied with smaller values when
-- the Judgment difficulty is higher.$
function PJLFPData(self, n, name)
	self:x(SCREEN_CENTER_X-10)
	self:y(SCREEN_CENTER_Y+n)
	self:horizalign('right')
	self:vertalign('top')
	self:zoom(0.4);
	self:cropright(0.75)
	self:settext( PREFSMAN:GetPreference( 'JudgeWindowScale' ) * PREFSMAN:GetPreference( 'JudgeWindowSeconds'..name ) )
	self:shadowlength(1);
end

function PostionJudgmentLabelsForPreview(self, n1, n2, n3, n4)
	self:x(SCREEN_CENTER_X-250)
	self:y(SCREEN_CENTER_Y+n1)
	self:horizalign('left')
	self:vertalign('top')
	self:zoom(0.4);
	self:diffuse(n2,n3,n4,1)
	self:shadowlength(1);
end


-- The function names speak for themselves.
function OptionsMenuHeader(self)
	self:x(SCREEN_CENTER_X-290)
	self:y(SCREEN_CENTER_Y-190)
	self:horizalign('left')
	self:vertalign('top')
	self:zoom(0.78);
	self:shadowlength(2);
end

function OptionsMenuSubtitle(self)
	self:x(SCREEN_CENTER_X-270)
	self:y(SCREEN_CENTER_Y-165)
	self:horizalign('left')
	self:vertalign('top')
	self:zoom(0.78);
	self:shadowlength(2);
end

function OpIco(n, name)
	return ThemeFile("PlayerOptionIcons/P".. n .."/"..name)
end

-- Checks for Background songs and load their backgrounds.
function SongBGCredits(self, n)
	self:x(SCREEN_CENTER_X-195)
	self:y(250 * n)
	BGSong = _G['Song'..n]
	-- Did you found the directory of the song?
	-- Great, now get the background image.
	if BGSong:GetSongDir() then
		-- Found the background image directory?
		-- Now we need to check if its valid.
		if BGSong:GetBackgroundPath() then
			-- It isn't valid? Yikes...
			-- We'll have to load the CFB to prevent crashing.
			if BGSong:GetBackgroundPath() == nil then
				self:Load( ThemeFile('Common fallback background') )
			else
				-- Otherwise, load the background!
				self:Load( BGSong:GetBackgroundPath() )
			end
		else
			-- The background image directory returned nil?
			-- damn. We'll have to load the CFB to prevent crashing.
			self:Load( ThemeFile('Common fallback background') )
		end
	else
		-- It didn't found a song?
		-- damn. We'll have to load the CFB to prevent crashing.
		self:Load( ThemeFile('Common fallback background') )
	end
	-- Then resize the result to 250x250.
	self:zoomto(250,250,0,0)
	-- And if the player is using NotITG,
	-- disable the Texture Filtering on those images!
	DWITextureFiltering(self)
end

function Center(self)
	-- This is self-explanatory.
	-- This is to "recreate" the Center() command that exists in SM5.
	self:x(SCREEN_CENTER_X)
	self:y(SCREEN_CENTER_Y)
end

function DWITextureFiltering(self)
	-- DWI always ran without any kind of texture filtering.
	-- Luckily, NotITG has this function. So we can run this command at will.
	-- OpenITG will still have to suffer the Antialiasing though...

	-- I do hope someday this can also apply to Fonts, because those are heavily used.
	-- Unfortunately, NotITG's format for the command only applies to textures.
	if FUCK_EXE then
		self:SetTextureFiltering(false)
	end
end

function UpdateSortName(self)
	self:finishtweening()
      	local GetSort = GAMESTATE:GetSortOrder()
      	local SetSort = {
          	{'All Music (Folder/Separated)'},
          	{'Title'},
          	{'BPM'},
          	{'Player\'s Best'},
          	{'Best Grades'},
          	{'Artist'},
          	{'Genre'},
          	{'Song Length'},
          	{'Difficulty: Easy'},
          	{'Difficulty: Medium'},
          	{'Difficulty: Hard'},
          	{'Difficulty: Challenge'},
          	{' '},
      	}
    -- Because ROULETTE is sort number 18, we need to do a check for this.
    -- Because there's no sorting on Course mode at all in this theme.
  	if GetSort ~= 18 then
      	self:settext( SetSort[GetSort][1] or ' ' )
  	else
      	self:settext( ' ' )
  	end
end

-- Checks where to put the difficulty icon during gameplay.
function ReverseDiffCheck(self, n)
	-- Did it find reverse in the mod list for the player?
	if string.find( SCREENMAN:GetTopScreen():GetChild('PlayerOptionsP'..n):GetText(), 'Reverse' ) then
		-- Then put the difficulty icon on the top of the screen, not the bottom!
		self:y(SCREEN_CENTER_Y-190)
	end
end

-- Timer for Course mode.
-- Command only works on NotITG, so a check is used
-- so that the Course Select screen can still be used in OpenITG.
function NITG_CourseTimer(self, pn)

	if FUCK_EXE then
        if GAMESTATE:IsPlayerEnabled(pn) then
            self:settext('Time: '..SecondsToMMSS( GAMESTATE:GetCurrentTrail(pn):GetLengthSeconds() ) )
        end
    else
        self:settext(' ')
    end
end

function DiffPlacement(self, pn, name)
	if pn == PLAYER_1 then
		self:x(SCREEN_LEFT+45)
	elseif pn == PLAYER_2 then
		self:x(SCREEN_RIGHT-45)
	end
	self:y(SCREEN_BOTTOM-55)
	self:animate(0)
	if pn == PLAYER_2 then
		self:setstate(2*name(pn)+1)
	else
		self:setstate(2*name(pn))
	end
	self:sleep(0.2)
	self:queuecommand('CheckLocation')
end

function CheckForBannerIcon(self, name, pn)
    self:finishtweening()
	if name == "Challenge" then
        self:diffusealpha(0)
        if GAMESTATE:GetCurrentSong() then
            self:diffusealpha(0)
                if PDiff(pn) == 4 then
                    self:sleep(0.1502)
                    self:diffusealpha(1)
                else
                    self:diffusealpha(0)
                end
            else
            self:diffusealpha(0)
        end
    elseif name == "Battle" then
        self:diffusealpha(0)
            if GAMESTATE:GetCurrentSong() then
                self:diffusealpha(0)
                if PlayModeName() == 'Rave' then
                    self:sleep(0.1502)
                    self:diffusealpha(1)
                else
                    self:diffusealpha(0)
                end
            else
            self:diffusealpha(0)
        end
    end
end

function ProfileNamesWarningCheck(self)
	if GetProfileName(1) == 'Player 1' and GetProfileName(2) == 'Player 2' then
        self:settext('You can change the Profile names in:\nDance With Intensity/Scripts/Profile Information.lua')
    else
        self:settext(' ')
    end
end

function LevelMeterTicks(self, pn, n)
	self:finishtweening()
    self:settext('0')
    if GAMESTATE:GetCurrentSong() then
        self:settext( PMeter(pn) )
        if PMeter(pn) > 7 then
            self:x(SCREEN_CENTER_X+n)
            self:settext( 'LEVEL     x '..PMeter(pn) )
        else
            self:x(SCREEN_CENTER_X+n)
            self:settext( ' ' )
        end
    else
        self:settext(' ')
        self:x(SCREEN_CENTER_X+n-20)
        if GAMESTATE:IsPlayerEnabled(PLAYER_1) and GAMESTATE:IsPlayerEnabled(PLAYER_2) then
            self:settext(' ')
        end
    end
end

function NextCourseSongFade(self)
	self:sleep(0.1)
	self:linear(0.3)
	self:diffusealpha(1)
	self:shadowlength(2)
	self:sleep(2)
	self:linear(0.3)
	self:diffusealpha(0)
end

function TickDisplayMovement(self, pn, n)
	self:finishtweening()
    self:diffusealpha(0)
    if GAMESTATE:GetCurrentSong() then
        self:diffuse(0,0,0,1)
            if PMeter(pn) > 7 then
                self:diffusealpha(0)
            else
                self:cropright(0)
                self:diffusealpha(1)
                self:x(SCREEN_CENTER_X+n)
            end
    else
        self:diffuse(1,1,1,0)
        self:cropright(1)
        self:x(SCREEN_CENTER_X+n)
    end
end

CropAmmounts = {
-- Left, P1
-- Right, P2
	{0.89, 0.88},
	{0.7, 0.7},
	{0.6, 0.6},
	{0.42, 0.42},
	{0.3, 0.3},
	{0.15, 0.15},
	{0, 0},
}

TickDiffuses = {
	{0,1,1,1},
	{1,1,0,1},
	{1,0,0.5,1},
	{0,1,0,1},
	{1,0.5,1,1},
	{1,1,1,1},
}

function TickDisplay(self, pn)
	self:finishtweening()
    self:diffusealpha(0)
    if GAMESTATE:GetCurrentSong() then
    	if pn == PLAYER_1 then
    		if PMeter(pn) < 8 then
    			self:cropright( CropAmmounts[PMeter(pn)][1] )
    			self:x(SCREEN_CENTER_X-300)
    			self:diffuse( TickDiffuses[PDiff(pn)+1][1], TickDiffuses[PDiff(pn)+1][2], TickDiffuses[PDiff(pn)+1][3],1 )
    		else
    			self:cropright( 0.9 )
    			self:x(SCREEN_CENTER_X-245)
    			self:diffuse( TickDiffuses[PDiff(pn)+1][1], TickDiffuses[PDiff(pn)+1][2], TickDiffuses[PDiff(pn)+1][3],1 )
    		end
    	elseif pn == PLAYER_2 then
    		if PMeter(pn) < 8 then
    			self:cropleft( CropAmmounts[PMeter(pn)][2] )
    			self:x(SCREEN_CENTER_X-30)
    			self:diffuse( TickDiffuses[PDiff(pn)+1][1], TickDiffuses[PDiff(pn)+1][2], TickDiffuses[PDiff(pn)+1][3],1 )
    		else
    			self:cropleft( 0.88 )
    			self:x(SCREEN_CENTER_X-65)
    			self:diffuse( TickDiffuses[PDiff(pn)+1][1], TickDiffuses[PDiff(pn)+1][2], TickDiffuses[PDiff(pn)+1][3],1 )
    		end
    	end
    else
        self:diffuse(1,1,1,0)
    end
end

function GrooveRadarAnimation(self, name)
	-- This is here for a reason.
	-- Some machines have a weird bug with the Radar, that shows up as rotated squares
	-- rather than an actual pentagon.
	-- This is because of SmoothLines. It is required to be enabled in order to make the radar
	-- function correctly. If it's not on, then warn about it, so the player can re-enable
	-- it, if his/her machine supports it anyway.
	if name == "Begin" then
		if PREFSMAN:GetPreference( 'SmoothLines' ) then
			self:zoom(70*1.5);
			self:addx(-8);
			self:addy(-8);
			self:rotationz(-720);
			self:linear(0.6);
			self:rotationz(0);
			self:zoom(70);
		else
			self:zoom(0)
			SCREENMAN:SystemMessage("SmoothLines is not enabled. The Radar has been disabled to prevent visual garbage.")
		end
	elseif name == "End" then
		if PREFSMAN:GetPreference( 'SmoothLines' ) then
			self:rotationz(0);
			self:linear(0.6);
			self:rotationz(-720);
			self:zoom(70*2);
		else
			self:zoom(0)
		end
	end
end

function DWI_LoadBanner(self)
	if GAMESTATE:GetCurrentSong() then
        if GAMESTATE:GetCurrentSong():GetBannerPath() then
            self:hidden(0)
            self:scaletoclipped(254,79);
            self:LoadBanner(GAMESTATE:GetCurrentSong():GetBannerPath());
        else
            self:LoadBanner(ThemeFile('Common fallback banner'))
        end
    else
        self:LoadBanner(ThemeFile('Common fallback banner'))
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

function CutCheck(self)
	if not IsUsingWideScreen() then
		self:cropleft(0.124)
		self:cropright(0.124)
	end
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

    -- Check if its connected to SMO
    if GAMESTATE:GetPlayMode() == 0 and IsNetConnected() and IsNetSMOnline() then
        s = 'ScreenSMOnlineLogin'
    end

    -- Check if its connected to a server that is not SMO
    if GAMESTATE:GetPlayMode() == 0 and IsNetConnected() and not IsNetSMOnline() then
        s = 'ScreenNetSelectMusic'
    end

	return s
end

function CharacterTransferCheckStart()
	local s = "ScreenSelect";

	local CharacterLoaded = string.find(string.lower(PREFSMAN:GetPreference('ShowDancingCharacters')), '2')
	
	-- Dancing Characters are on "SELECT"? Send them to this screen.
	if CharacterLoaded then
		s = s.."Character"
	end

	-- Dancing Characters are on "DEFAULT TO OFF" or "DEFAULT TO RANDOM"? Send them to their respective next screens.
	if GAMESTATE:GetPlayMode() == 0 and not CharacterLoaded and not IsNetConnected() then
		s = s..'Music'
	end
	if GAMESTATE:GetPlayMode() == 1 and not CharacterLoaded then
		s = s..'Course'
	end

	if GAMESTATE:GetPlayMode() == 0 and not CharacterLoaded and IsNetConnected() and IsNetSMOnline() then
		s = 'ScreenSMOnlineLogin'
	end

	if GAMESTATE:GetPlayMode() == 0 and not CharacterLoaded and IsNetConnected() and not IsNetSMOnline() then
		s = 'ScreenNetSelectMusic'
	end

	return s
end

-- THE HUGE ANNOUNCER DATA VALUE TREE.

function AnnouncerAudio()
    local BestGrade = STATSMAN:GetBestGrade()
	-- AAAA
    if BestGrade == 0 then return 'Internal/eval/AAA/sss-00' end 
    -- AAA and AAAA
    if BestGrade >= 1 and BestGrade < 2 then return 'Internal/eval/AAA/sss-00' end
    -- AA
    if BestGrade >= 2 or BestGrade <= 3  then return 'Internal/eval/AA/s-0'.. RandomNumber end
    -- A
    if BestGrade >= 3 or BestGrade <= 4 then return 'Internal/eval/A/a-0'.. RandomNumber end                        
    -- B
    if BestGrade >= 4 and BestGrade < 5 then return 'Internal/eval/B/b-0'.. RandomNumber end     
    -- C
    if BestGrade >= 5 and BestGrade < 6 then return 'Internal/eval/C/c-0'.. RandomNumber end   
   	-- D
   	if BestGrade >= 7 and BestGrade < 8 then return 'Internal/eval/D/d-0'.. RandomNumber end    
    -- E
   	if BestGrade >= 6 and BestGrade < 7 then return 'Internal/eval/E/e-0'.. RandomNumber end                        
	-- F
    if BestGrade > 7 then return 'Internal/eval/E/e-0'.. RandomNumber end

    return 'Internal/eval/E/e-0'
end

-- Radar Values:
	-- 0 - Stream
	-- 1 - Voltage
	-- 2 - Air
	-- 3 - Freeze
	-- 4 - Chaos
function RadarValue(pn,n) return GAMESTATE:GetCurrentSteps(pn):GetRadarValues(pn):GetValue(n) end
function RadarValueNonstop(pn,n) return GAMESTATE:GetCurrentTrail(pn):GetRadarValues(pn):GetValue(n) end

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

function SongSelectionScreen()
    if PlayModeName() == "Nonstop" then return "ScreenSelectCourse" end
    if IsNetConnected() then ReportStyle() end
    if IsNetSMOnline() then return SMOnlineScreen() end
    if IsNetConnected() then return "ScreenNetSelectMusic" end
    return "ScreenSelectMusic"
end

function SMOnlineScreen()
    if not IsSMOnlineLoggedIn(PLAYER_1) and GAMESTATE:IsPlayerEnabled(PLAYER_1) then return "ScreenSMOnlineLogin" end
    if not IsSMOnlineLoggedIn(PLAYER_2) and GAMESTATE:IsPlayerEnabled(PLAYER_2) then return "ScreenSMOnlineLogin" end
    if IsNetSMOnline() and GAMESTATE:IsPlayerEnabled(PLAYER_1) then return "ScreenNetSelectMusic" end
    if IsNetSMOnline() and GAMESTATE:IsPlayerEnabled(PLAYER_2) then return "ScreenNetSelectMusic" end
    return "ScreenNetSelectMusic"
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
	if IsNetConnected() or IsNetSMOnline() then return "ScreenNetSelectMusic" end
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

function SMOnlineScreen()
	if not IsSMOnlineLoggedIn(PLAYER_1) and GAMESTATE:IsPlayerEnabled(PLAYER_1) then
		SCREENMAN:SystemMessage("You are not logged in. Please log in to continue.")
		return "ScreenSMOnlineLogin"
	end
	if not IsSMOnlineLoggedIn(PLAYER_2) and GAMESTATE:IsPlayerEnabled(PLAYER_2) then
		SCREENMAN:SystemMessage("You are not logged in. Please log in to continue.")
		return "ScreenSMOnlineLogin"
	end
	return "ScreenNetRoom"
end	

function DangerSize()
	if IsUsingWideScreen() then 
		return 0.75
	else
		return 0.5
	end 
end


function ScrollBarPos()
	if FindAspRatio(1.7777) then return 260
	elseif FindAspRatio(1.600) then return 220
	else return 152 end
end

-- Lifebar Stuff
function LifeBarLength() if IsUsingWideScreen() then return 388 else return 289 end end
function StripsNumber()  if IsUsingWideScreen() then return 66 else return 33 end end
function LifeBarP1PosX() if IsUsingWideScreen() then return SCREEN_CENTER_X-232 else return SCREEN_CENTER_X-176 end end
function LifeBarP2PosX() if IsUsingWideScreen() then return SCREEN_CENTER_X+232 else return SCREEN_CENTER_X+176 end end

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
	t.LayoutType = "ShowAllInRow"
	t.OneChoiceForAllPlayers = true
	t.Choices = { "On", "Off" }
	t.LoadSelections = function(self, list, pn) if not Profile().DWIAnnouncer then list[2] = true elseif Profile().DWIAnnouncer then list[1] = true else list[2] = true end end
	t.SaveSelections = function(self, list, pn)
		if list[1] then Profile().DWIAnnouncer = true; end
		if list[2] then Profile().DWIAnnouncer = false; end
	end
	return t
end

function DWIBeatNum()
	local t = OptionRowBase('DWIBeatNum')
	t.LayoutType = "ShowAllInRow"
	t.OneChoiceForAllPlayers = true
	t.Choices = { "On", "Off" }
	t.LoadSelections = function(self, list, pn) if not Profile().DWIBeatNum then list[2] = true elseif Profile().DWIBeatNum then list[1] = true else list[2] = true end end
	t.SaveSelections = function(self, list, pn)
		if list[1] then Profile().DWIBeatNum = true; end
		if list[2] then Profile().DWIBeatNum = false; end
	end
	return t
end

function DWIITGReceptor()
	local t = OptionRowBase('DWIITGReceptor')
	t.LayoutType = "ShowAllInRow"
	t.OneChoiceForAllPlayers = true
	t.Choices = { "In The Groove", "Dance With Intensity" }
	t.LoadSelections = function(self, list, pn) if not Profile().DWIITGReceptor then list[2] = true elseif Profile().DWIITGReceptor then list[1] = true else list[2] = true end end
	t.SaveSelections = function(self, list, pn)
		if list[1] then Profile().DWIITGReceptor = true; end
		if list[2] then Profile().DWIITGReceptor = false; end
	end
	return t
end

function DWIPercentageShow()
	local t = OptionRowBase('DWIPercentageShow')
	t.LayoutType = "ShowAllInRow"
	t.OneChoiceForAllPlayers = true
	t.Choices = { "Number Scoring", "Percentage Scoring" }
	t.LoadSelections = function(self, list, pn) if not Profile().DWIPercentageShow then list[1] = true elseif Profile().DWIPercentageShow then list[2] = true else list[1] = true end end
	t.SaveSelections = function(self, list, pn)
		if list[1] then Profile().DWIPercentageShow = false; end
		if list[2] then Profile().DWIPercentageShow = true; end
	end
	return t
end

function DWIToggleDemonstration()
	local t = OptionRowBase('DWIToggleDemonstration')
	t.LayoutType = "ShowAllInRow"
	t.OneChoiceForAllPlayers = true
	t.Choices = { "Enable", "Disable" }
	t.LoadSelections = function(self, list, pn) if not Profile().DWIToggleDemonstration then list[2] = true elseif Profile().DWIToggleDemonstration then list[1] = true else list[2] = true end end
	t.SaveSelections = function(self, list, pn)
		if list[1] then Profile().DWIToggleDemonstration = true; end
		if list[2] then Profile().DWIToggleDemonstration = false; end
	end
	return t
end

function DWIHighestSessionScore()
	local t = OptionRowBase('DWIHighestSessionScore')
	t.LayoutType = "ShowAllInRow"
	t.OneChoiceForAllPlayers = true
	t.Choices = { "Highest Total Session", "Highest Single" }
	t.LoadSelections = function(self, list, pn) if not Profile().DWIHighestSessionScore then list[2] = true elseif Profile().DWIHighestSessionScore then list[1] = true else list[2] = true end end
	t.SaveSelections = function(self, list, pn)
		if list[1] then Profile().DWIHighestSessionScore = true; end
		if list[2] then Profile().DWIHighestSessionScore = false; end
	end
	return t
end

function DWIShowProfileInSelectMusic()
	local t = OptionRowBase('DWIShowProfileInSelectMusic')
	t.LayoutType = "ShowAllInRow"
	t.OneChoiceForAllPlayers = true
	t.Choices = { "Show", "Hide" }
	t.LoadSelections = function(self, list, pn) if not Profile().DWIShowProfileInSelectMusic then list[2] = true elseif Profile().DWIShowProfileInSelectMusic then list[1] = true else list[2] = true end end
	t.SaveSelections = function(self, list, pn)
		if list[1] then Profile().DWIShowProfileInSelectMusic = true; end
		if list[2] then Profile().DWIShowProfileInSelectMusic = false; end
	end
	return t
end

-- The timer for Demonstration.
-- Thanks to LDanii for pointing this out, because i forgot
-- That DWI had a option to disable the demonstration.
function DemoTimer()
	if Profile().DWIToggleDemonstration then
		return 60
	else
		return 0
	end
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
	

	local function StatsCombined(pn, n1, n2, n3)
		return GetPSStageStats(pn):GetTapNoteScores(n1) + GetPSStageStats(pn):GetTapNoteScores(n2) + GetPSStageStats(pn):GetTapNoteScores(n3)
	end

	local GameSecs = STATSMAN:GetCurStageStats():GetGameplaySeconds()

	if GAMESTATE:IsPlayerEnabled(PLAYER_1) then

		if not GAMESTATE:IsCourseMode() then

        	Profile().DWITotalStepsHitP1 = Profile().DWITotalStepsHitP1 + StatsCombined(PLAYER_1, 8, 7, 6)

        	Profile().DWITotalSongsPlayedP1 = Profile().DWITotalSongsPlayedP1 + 1

        	if GetScore(PLAYER_1) > Profile().DWIHighestScoreP1 then Profile().DWIHighestScoreP1 = GetScore(PLAYER_1) end

        	if GetTotalScore(PLAYER_1) > Profile().DWIHighestSessionScoreP1 then Profile().DWIHighestSessionScoreP1 = GetTotalScore(PLAYER_1) end

        	if GetPSStageStats(PLAYER_1):MaxCombo() > Profile().DWIHighestComboP1 then Profile().DWIHighestComboP1 = GetPSStageStats(PLAYER_1):MaxCombo() end


    	else

    		Profile().DWITotalStepsHitP1 = Profile().DWITotalStepsHitP1 + StatsCombined(PLAYER_1, 8, 7, 6)

			if GameSecs > Profile().DWILongestTimeNonstopP1 then Profile().DWILongestTimeNonstopP1 = GameSecs end

			if GetPSStageStats(PLAYER_1):MaxCombo() > Profile().DWIHighestComboNonstopP1 then Profile().DWIHighestComboNonstopP1 = GetPSStageStats(PLAYER_1):MaxCombo() end

			if GetScore(PLAYER_1) > Profile().DWIHighestScoreNonstopP1 then Profile().DWIHighestScoreNonstopP1 = GetScore(PLAYER_1) end


        end
        
    end

    if GAMESTATE:IsPlayerEnabled(PLAYER_2) then

    	if not GAMESTATE:IsCourseMode() then

    		Profile().DWITotalStepsHitP2 = Profile().DWITotalStepsHitP2 + StatsCombined(PLAYER_2, 8, 7, 6)

        	Profile().DWITotalSongsPlayedP2 = Profile().DWITotalSongsPlayedP2 + 1

        	if GetScore(PLAYER_2) > Profile().DWIHighestScoreP2 then Profile().DWIHighestScoreP2 = GetScore(PLAYER_2) end

        	if GetTotalScore(PLAYER_2) > Profile().DWIHighestSessionScoreP2 then Profile().DWIHighestSessionScoreP2 = GetTotalScore(PLAYER_2) end

        	if GetPSStageStats(PLAYER_2):MaxCombo() > Profile().DWIHighestComboP2 then Profile().DWIHighestComboP2 = GetPSStageStats(PLAYER_2):MaxCombo() end


		else

    		Profile().DWITotalStepsHitP2 = Profile().DWITotalStepsHitP2 + StatsCombined(PLAYER_2, 8, 7, 6)

			if GameSecs > Profile().DWILongestTimeNonstopP2 then Profile().DWILongestTimeNonstopP2 = GameSecs end

			if GetPSStageStats(PLAYER_2):MaxCombo() > Profile().DWIHighestComboNonstopP2 then Profile().DWIHighestComboNonstopP2 = GetPSStageStats(PLAYER_2):MaxCombo() end

			if GetScore(PLAYER_2) > Profile().DWIHighestScoreNonstopP2 then Profile().DWIHighestScoreNonstopP2 = GetScore(PLAYER_2) end


        end

    end

    SaveProfiles()
end

function InitializeProfile()
	Profile().DWISongs = 0;
	Profile().DWIAnnouncer = false;
	Profile().DWIBeatNum = false;
	Profile().DWIPercentageShow = false;
	Profile().DWIRandomCompany = false;
	Profile().DWIToggleDemonstration = false;
	SaveProfiles()
end

-- Profile deletion
function DeleteProfileData(n)

	local PlayerNumber = n

	if PlayerNumber == 1 then
		Profile().DWITotalStepsHitP1 = 0
		Profile().DWITotalSongsPlayedP1 = 0
		Profile().DWIHighestScoreP1 = 0
		Profile().DWIHighestSessionScoreP1 = 0
		Profile().DWIHighestComboP1 = 0
		Profile().DWILongestTimeNonstopP1 = 0
		Profile().DWIHighestComboNonstopP1 = 0
		Profile().DWIHighestScoreNonstopP1 = 0
	end

	if PlayerNumber == 2 then
		Profile().DWITotalStepsHitP2 = 0
		Profile().DWITotalSongsPlayedP2 = 0
		Profile().DWIHighestScoreP2 = 0
		Profile().DWIHighestSessionScoreP2 = 0
		Profile().DWIHighestComboP2 = 0
		Profile().DWILongestTimeNonstopP2 = 0
		Profile().DWIHighestComboNonstopP2 = 0
		Profile().DWIHighestScoreNonstopP2 = 0
	end

	SaveProfiles()
end

function EditorHelpText()
	local text = ''

		text = text ..'Help:\n'
		text = text ..'\n'
		text = text ..'Up/Down\n'
		text = text ..'Change Beat\n'
		text = text ..'\n'
		text = text ..'Left/Right\n'
		text = text ..'Change Snap\n'
		text = text ..'\n'
		text = text ..'1/2/3/4\n'
		text = text ..'Add/Remove Tap Note\n'
		text = text ..'\n'
		text = text ..'1/2/3/4 Holded\n'
		text = text ..'Add Hold Note\n'
		text = text ..'\n'
		text = text ..'Space Bar\n'
		text = text ..'Set Area Marker\n'
		text = text ..'\n'
		text = text ..'Enter\n'
		text = text ..'Area Menu\n'
		text = text ..'\n'
		text = text ..'ESC\n'
		text = text ..'Main Menu\n'

	return text
end

--[[
    Dance With Intensity, NotITG Theme Metrics File
    Copyright (C) 2017-2018  Jose_Varela

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

]]