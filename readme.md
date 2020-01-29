# GetSPOUsageAnalysis.ps1

This PowerShell Script is to retrieve the Usage Report from SharePoint Online using CSOM Search API.

## Note
We can retrieve the similar kinds of data from this script.
But as Usage and Popularity reports are discontinued in SPO, you cannot expect too much on this functionality.

https://docs.microsoft.com/en-us/sharepoint/troubleshoot/sites/classic-usage-popularity-reports-discontinued

## Prerequitesite

You need to download SharePoint Online Client Components SDK to run this script. 

https://www.microsoft.com/en-us/download/details.aspx?id=42038

You can also acquire the latest SharePoint Online Client SDK by Nuget as well.
1. You need to access the following site. https://www.nuget.org/packages/Microsoft.SharePointOnline.CSOM
2. Download the nupkg.
3. Change the file extension to *.zip.
4. Unzip and extract those file.
5. place them in the specified directory from the code.

## How to run - parameters

-siteUrl ... The target site/tenant to be connected.

-path ... (OPTIONAL) The scope of the search. You can specify URL of site, web, list or folder.

-sort ... (OPTIONAL) Make Descending sort of the specified option; "ViewsLifeTime", "ViewsLifeTimeUniqueUsers", "ViewsRecent", "ViewsRecentUniqueUsers". Default option is ViewsLifeTime

-username ... (OPTIONAL) The target user to retrieve the search result.

-password ... (OPTIONAL) The password of the above user.

## Example

.\GetSPOUsageAnalysis.ps1 | Out-GridView

.\GetSPOUsageAnalysis.ps1 | Export-CSV -Path C:\temp\out.csv -NoTypeInformation

.\GetSPOUsageAnalysis.ps1 -siteUrl https://tenant.sharepoint.com -path https://tenant.sharepoint.com/DocLib | Out-GridView

.\GetSPOUsageAnalysis.ps1 -siteUrl https://tenant.sharepoint.com -path https://tenant.sharepoint.com/DocLib -sort ViewsRecent | Out-GridView

