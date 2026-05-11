$DisconnectedSessions = Get-RemoteSession -State "Disconnected" | Sort
ForEach ($DisconnectedSession in $DisconnectedSessions) {
	#Send-SessionLogoff -Session_id $DisconnectedSession.session_id
	Write-Host "$($DisconnectedSession.username) has been logged off."
	}