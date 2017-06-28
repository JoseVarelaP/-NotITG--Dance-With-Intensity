local ProfileNames = {
	-- Profile Names that will appear in Select Music and the Options Menu
	-- If you change the names while the game is open, PLEASE DO F3+R TO RELOAD THE THEME.
	-- Otherwise, it won't update until you restart the game, or you do that.

	-- Player 1
	"Jose_Varela",

	-- Player 2
	"D3M3NC14",
}

function GetProfileName(n)
	return ProfileNames[n]
end
