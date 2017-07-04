local ProfileNames = {
	-- Profile Names that will appear in Select Music and the Options Menu
	-- If you change the names while the game is open, PLEASE DO F3+R TO RELOAD THE THEME.
	-- Otherwise, it won't update until you restart the game, or you do that.

	-- Player 1
	"Player 1",

	-- Player 2
	"Player 2",
}

function GetProfileName(n)
	return ProfileNames[n]
end
