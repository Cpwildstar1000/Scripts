$Names = Get-Content "C:\Users\OCP\Desktop\PeopleMailboxSizeList.csv"
ForEach ($User in $Names) {
	Get-MailboxStatistics -Identity "$User" | Format-Table DisplayName, TotalItemSize, ItemCount >> C:\Users\OCP\Desktop\UserMailboxSize2.csv
}