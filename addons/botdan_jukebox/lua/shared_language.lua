/*																					*\
	Please note that I am currently working on language support.
	This here is currently unfinished but does work.
	PROGRESS:
	- ALL SONGS:
		- Normal User 		✔
		- Admin 			✖
	- QUEUE:
		- Normal User 		✔
		- Admin 			✖
	- OPTIONS
		- Normal User		✔
		- Admin 			✔
	- ADD A SONG - MANUAL
		- Normal User		✔
		- Admin				✔
	- ADD A SONG - SEARCH
		- Normal User		✔
		- Admin 			✔
	- ADMIN TABS			✖
	
	Also note that more phrases are to be added soon for Admin support.
	This means this file will change soon - don't get too confortable with it.
	I also recommend reading the README - Languages.txt file.
\*																					*/

JukeBox.Lang = {}
JukeBox.Lang.Current = "English"
JukeBox.Lang.Languages = {}

-- CREATING A LANGUAGE
-- To create a new language, copy the whole list below and paste it in the space under.
-- You can then rename the language by changing "English" to "YOUR LANGUAGE NAME"
-- Make sure to not remove any = or , because it can cause errors.

-- SPECIAL CHARACTERS
-- Make sure to keep the same amount of special characters in each phrase.
-- If a phrase has 2 %s, make sure to keep 2 %s.
-- %s	Replced by a variable, such as song name or artist
-- \n	Creates a new line

JukeBox.Lang.Languages["English"] = {
	-- GENERAL LIST HEADINGS
	["#HEADING_Name"] 		= "JukeBox",
	["#HEADING_Song"] 		= "Song Name",
	["#HEADING_Artist"] 	= "Artist",
	["#HEADING_Length"]		= "Length",
	["#HEADING_Favourite"]	= "Favourite",
	["#HEADING_Actions"]	= "Actions",
	
	-- GENERAL BUTTONS
	["#BUTTON_Cancel"]		= "Cancel",
	["#BUTTON_Close"]		= "Close",
	
	-- TABS NAMES/HEADINGS
	["#TAB_Main"]			= "Main",
	["#TAB_AllSongs"]		= "All Songs",
	["#TAB_Queue"]			= "Queue",
	["#TAB_User"]			= "User",
	["#TAB_Options"]		= "Options",
	["#TAB_AddSong"]		= "Add a Song",
	["#TAB_Manual"]			= "Manual",
	["#TAB_Search"]			= "Search",
	
	-- BASE
	["#BASE_NotPlaying"]	= "Not playing...",
	["#BASE_VotesTo"]		= "Votes to", 	-- These two are part of the same sentance
	["#BASE_Skip"]			= "Skip",		-- but are on 2 lines, \n doesn't work here
	["#BASE_PlayDisabled"]	= "Playback is disabled by the Server while you're alive!",
	["#BASE_VoteSkip"]		= "Vote Skip",
	["#BASE_ForceSkip"]		= "Force Skip",
	["#BASE_ChatCommand"]	= "To open, type %s",
	
	-- NOTIFICATIONS
	["#NOTIFY_SongRemovedQ"]	= "The song was removed from the Queue!",
	["#NOTIFY_AddedToAllSongs"] = "The song was added to the All Songs list!",
	["#NOTIFY_BannedRequest"]	= "You are currently banned from requesting songs. The request was not sent.",
	["#NOTIFY_CantAfford"] 		= "You can't afford to do that.",
	["#NOTIFY_URLInUse"]		= "Request was not sent, the YouTube URL is already in use!",
	["#NOTIFY_AddSongError"]	= "Request was not sent, the request was rejected by the server.",
	["#NOTIFY_ListeningToSkip"]	= "You must be listening to vote to skip!",
	["#NOTIFY_AlreadyVoteSkip"]	= "You have already voted to skip this song!",
	["#NOTIFY_NoSongPlaying"]	= "There is currently no song playing to skip!",
	["#NOTIFY_VotedToSkip"]		= "You have voted to skip the current song!",
	
	-- POPUPS
	["#POPUP_Error"]			= "Error",
	["#POPUP_URLInAllSongs"]	= "There was an issue when sending your request:\nThe requested YouTube URL is already in the All Songs list!\n\nThe request was not sent.",
	["#POPUP_URLInRequests"]	= "There was an issue when sending your request:\nThe requested YouTube URL is already in the Requests list!\n\nThe request was not sent.",
	["#POPUP_URLInAllSongsRem"]	= "There was an issue when accepting your request:\nThe requested YouTube URL is already in the All Songs list!\n\nThe request was not added (recommended to remove).",
	["#POPUP_AddSongCooldown"]	= "There was an issue when sending your request:\nYou have tried to add to many songs recently!\n\nThe request was not sent.",
	["#POPUP_AddSongGroupBan"]	= "There was an issue when sending your request:\nYour rank is not allowed to request songs to be added!\n\nThe request was not sent.",
	
	-- CHAT MESSAGES
	["#CHAT_IdlePlaying"]		= "Idle-playing: %s - %s",
	["#CHAT_SongQueued"]		= "Song Queued: %s - %s",
	["#CHAT_IdleSongStopped"]	= "The current idle-song has been stopped.",
	["#CHAT_NowPlaying"]		= "Now playing: %s - %s",
	["#CHAT_VotesToSkip"]		= "Votes to skip current song: %s/%s",
	["#CHAT_SongSkipped"]		= "The current song has been skipped.",
	["#CHAT_ForceSkipped"]		= "The current song has been Force skipped by a Manager.",
	["#CHAT_NewRequest"]		= "A new request has been submitted.",
	["#CHAT_SkipDeleted"]		= "The current song has been automatically skipped as it was deleted by a Manager.",
	["#CHAT_ListenInText"]		= "To listen to the JukeBox, type '%s' and press Play.",
	["#CHAT_StoppedJukeBox"]	= "You have stopped the music from the JukeBox!",
	
	-- SEARCH WORDS
	["#SEARCH_Total"]		= "There's a total of %s songs displayed.",
	["#SEARCH_Results"]		= "Search is displaying %s songs.", 
	
	-- ALL SONGS TAB
	["#ALLSONGS_Queue"]		= "Queue Song",
	["#ALLSONGS_SortBy"]	= "Sort By:",
	["#ALLSONGS_Refresh"]	= "Refresh All",
	["#ALLSONGS_ListenLocal"]	= "Listen Locally",
	["#ALLSONGS_RefreshWait"]	= "Please wait %s seconds before refreshing again..",
	["#ALLSONGS_TooMany"]		= "There are too many results to display!\nTry searching or refining your search to display results!",
	["#ALLSONGS_TooManyCount"]	= "Not all results could be displayed here! (Exceeded maximum of %s, which you can change in the Options tab)\nDidn't find what you're looking for? Try refining your search.",
	["#ALLSONGS_Fetching"]		= "We're currently fetching the All Songs list!\nPlease wait...",
	["#ALLSONGS_NoResults"]		= "There are no results to display!\nTry widening your search or adding the song to the JukeBox!",
		-- QUEUE POPUP
	["#ALLSONGS_ConfirmQueue"]	= "Are you sure you wish to queue:\n\n%s - %s\n\nIt will cost you %s %s.",
	["#ALLSONGS_CostPS"]		= "PointShop Points",
	["#ALLSONGS_CostPS2"]		= "standard PointShop 2 Points",
	["#ALLSONGS_CostDRPCash"]	= "DarkRP Cash",
	["#ALLSONGS_CostSMCash"]	= "Cash",
	["#ALLSONGS_CostNothing"]	= "nothing",
		-- QUEUE NOTIFICATIONS
	["#ALLSONGS_ManagerOnly"]	= "The JukeBox is currently in 'Manager-only' mode, meaning you can't queue songs.",
	["#ALLSONGS_Banned"]		= "You are currently banned from queueing songs. The song was not queue'd.",
	["#ALLSONGS_GroupBanned"]	= "Your current rank is not allowed to queue songs!",
	["#ALLSONGS_CurPlaying"]	= "The requested song is already playing!",
	["#ALLSONGS_CurQueued"]		= "The requested song is already in the song Queue!",
	["#ALLSONGS_RecentPlay"]	= "The requested song was recently played!",
	["#ALLSONGS_QueueCooldown"]	= "You have queue'd too many songs! This resets in %s seconds!",
	["#ALLSONGS_CantAffordPS"]	= "You can't afford to add a song to the Queue (%s points needed)!",
	["#ALLSONGS_CantAffordDRP"]	= "You can't afford to add a song to the Queue ($%s DarkRP cash needed)!",
	["#ALLSONGS_CantAffordMSC"]	= "You can't afford to add a song to the Queue ($%s cash needed)!",
	["#ALLSONGS_SongQueued"]	= "%s - %s has been added to the Queue!",
	
	-- OPTIONS TAB
	["#OPTIONS_Enable"]		= "Enable",
	["#OPTIONS_Enabled"]	= "Enabled",
		-- CHAT MESSAGE SETTINGS
	["#OPTIONS_ChatMessages"]	= "Chat Messages:",
	["#OPTIONS_SongStart"]		= "When a song starts playing.",
	["#OPTIONS_SongSkipped"]	= "When a song is skipped.",
	["#OPTIONS_SongVoteSkip"]	= "When someone votes to skip a song.",
	["#OPTIONS_SongQueued"]		= "When a song is added to the queue.",
	["#OPTIONS_NewRequest"]		= "[MANAGER] When a new request is submitted",
		-- MENU SETTINGS
	["#OPTIONS_UserInterface"]	= "User Interface:",
	["#OPTIONS_MaxListItems"]	= "The maximum amount of songs to display in the All Songs list:",
	["#OPTIONS_MaxListNote"]	= "Warning: Setting this value high (above 200) may cause your game to freeze when opening the All Songs list.",
		-- DEBUG SETTINGS
	["#OPTIONS_Debug"]			= "Debug:",
	["#OPTIONS_VideoOnScreen"]	= "Toggle displaying the video on-screen.",
		-- QUALITY SETTINGS
	["#OPTIONS_Quality"]		= "Playback Quality:",
		-- LANGUAGE SETTINGS
	["#OPTIONS_Language"]		= "Language:",
	["#OPTIONS_NoticeL1"]		= "Please note that this system is in development and is likely to have bugs - Admin translations are incomplete.",
	["#OPTIONS_NoticeL2"]		= "The JukeBox will re-open when a Language is chosen so that changes take effect.",
	
	-- MANUAL ADD A SONG TAB
	["#MANUAL_YouTubeURL"]		= "YouTube URL",
	["#MANUAL_Advanced"]		= "Advanced Options:",
	["#MANUAL_StartTime"]		= "Start Time",
	["#MANUAL_EndTime"]			= "End Time",
	["#MANUAL_SendRequest"]		= "Send Request",
	["#MANUAL_GetVideoLength"]	= "Get Video Length",
	["#MANUAL_Mins"]			= "Mins",
	["#MANUAL_Secs"]			= "Secs",
		-- ERRORS/REQUIREMENTS
	["#MANUAL_FieldBlank"]		= "Field must not be blank",
	["#MANUAL_FieldValidURL"]	= "Must be a valid YouTube URL with ID",
	["#MANUAL_LengthAbove0"]	= "Song length must be greater than 0",
	["#MANUAL_LengthBelowX"]	= "Song length must be shorter than %s seconds",
	["#MANUAL_StartNot0"]		= "Start time must not be negative",
	["#MANUAL_StartNotLength"]	= "Start time must not be greater than or equal to song length",
	["#MANUAL_EndNot0"]			= "End time must not be negative or zero",
	["#MANUAL_EndNotLength"]	= "End time must not be greater than song length",
		-- POPUP TEXT
	["#MANUAL_IssueWithFields"]	= "There's an issue with the fields: %s!",
	["#MANUAL_NoURL"]			= "There's currently no valid YouTube URL entered!",
	["#MANUAL_InvalidURL"]		= "The YouTube URL entered seems to be invalid!",
	["#MANUAL_SongTooLong"]		= "The song is too long (maximum %ss)!",
	["#MANUAL_ServerError"]		= "There was an issue contacting the server when getting video length!",
	["#MANUAL_UserCancel"]		= "Request was not sent, user cancelled process.",
		-- FINAL POPUP
	["#MANUAL_SendingRequest"]	= "Sending Request",
	["#MANUAL_CheckingURL"]		= "Checking YouTube URL and data...",
	["#MANUAL_VideoExists"]		= "Video exists",
	["#MANUAL_VideoNotExists"]	= "Video doesn't exists",
	["#MANUAL_ErrorWithServer"]	= "Error contacting server",
	["#MANUAL_ErrorList"]		= "Error: %s",
	["#MANUAL_RequestSent"]		= "Request has been sent. It will appear in the 'All Songs' list after Admin approval.",
	["#MANUAL_RequestInvalid"]	= "Request was not sent, Video ID was found invalid.",
	["#MANUAL_StraightToAll"]	= "Add song straight to All Songs list.",
	["#MANUAL_FastTrack"]		= "Fast-track request",
	["#MANUAL_FastTrackWarn"]	= "Doing this will add the song straight to the All Songs list.\n\nIt will cost you %s %s.",
	["#MANUAL_AddSong"]			= "Add Song",
	
	-- SEARCH ADD A SONG TAB
	["#SEARCH_Description"]		= "This allows you to search for a song from YouTube.\nThis returns the top 20 results so that you can easily add them to the JukeBox.",
	["#SEARCH_Search"]			= "Search",
	["#SEARCH_UnexpectedError"]	= "There was an unexpected error while searching.",
	["#SEARCH_NoResults"]		= "The search returned no results!",
	["#SEARCH_InPopup"]			= "JukeBox Pop-up",
	["#SEARCH_InSteamOverlay"]	= "Steam Overlay",
	["#SEARCH_ViewVideo"]		= "View Video",
	["#SEARCH_AddSong"]			= "Add song to JukeBox",
	["#SEARCH_CheckURL"]		= "Check URL",
	["#SEARCH_LengthCheck"]		= "Length: %s (%ss)",
	["#SEARCH_YouTubeID"]		= "YouTube ID",
	["#SEARCH_Error"]			= "Error",
	["#SEARCH_SubmitRequest"]	= "Submit Request",
	["#SEARCH_CheckYouTubeID"]	= "Check YouTube ID",
}

-- PASTE NEW LANGUAGES BELOW --







-- DO NOT EDIT BENEATH HERE -- 

JukeBox.Lang.Testing = false
function JukeBox.Lang:GetPhrase( code, ... )
	if not self:CheckPhrase( code ) then
		return code
	end
	local phrase = self.Languages[self.Current][code]
	if self.Testing then return "Hi" end
	if ... then
		return string.format( phrase, ... )
	else
		return phrase
	end
end

function JukeBox.Lang:GetPhraseCaps( code, ... )
	if not self:CheckPhrase( code ) then
		return code
	end
	local phrase = self.Languages[self.Current][code]
	if self.Testing then return "HI" end
	if ... then
		return string.upper( string.format( phrase, ... ) )
	else
		return string.upper( phrase )
	end
end

function JukeBox.Lang:CheckPhrase( code )
	if self.Languages[self.Current] then
		if self.Languages[self.Current][code] then
			return true
		else
			return false
		end
	else
		return false
	end
end