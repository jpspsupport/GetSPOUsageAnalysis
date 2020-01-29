<#
 This Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment. 

 THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, 
 INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.  

 We grant you a nonexclusive, royalty-free right to use and modify the sample code and to reproduce and distribute the object 
 code form of the Sample Code, provided that you agree: 
    (i)   to not use our name, logo, or trademarks to market your software product in which the sample code is embedded; 
    (ii)  to include a valid copyright notice on your software product in which the sample code is embedded; and 
    (iii) to indemnify, hold harmless, and defend us and our suppliers from and against any claims or lawsuits, including 
          attorneys' fees, that arise or result from the use or distribution of the sample code.

Please note: None of the conditions outlined in the disclaimer above will supercede the terms and conditions contained within 
             the Premier Customer Services Description.
#>
param(
    [Parameter(Mandatory=$true)]
    $siteUrl,
    [Parameter(Mandatory=$false)]
    $path,
    [Parameter(Mandatory=$false)]
    [ValidateSet("ViewsLifeTime", "ViewsLifeTimeUniqueUsers", "ViewsRecent", "ViewsRecentUniqueUsers")]
    $sort,
    [Parameter(Mandatory=$false)]
    $username,
    [Parameter(Mandatory=$false)]
    $password
)

Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Search.dll"

$selectProperties = ("Path", "ViewsLifeTime", "ViewsLifeTimeUniqueUsers", "ViewsRecent", "ViewsRecentUniqueUsers", "ViewsLast1Days", "ViewsLast1DaysUniqueUsers", "ViewsLast2Days", "ViewsLast2DaysUniqueUsers","ViewsLast3Days", "ViewsLast3DaysUniqueUsers","ViewsLast4Days", "ViewsLast4DaysUniqueUsers","ViewsLast5Days", "ViewsLast5DaysUniqueUsers","ViewsLast6Days", "ViewsLast6DaysUniqueUsers","ViewsLast7Days", "ViewsLast7DaysUniqueUsers", "ViewsLastMonths1", "ViewsLastMonths1Unique", "ViewsLastMonths2", "ViewsLastMonths2Unique", "ViewsLastMonths3", "ViewsLastMonths3Unique")
#"ViewCount", "ViewCountLifetime","ViewerCount" 
function Convert-HashToPSObject
{
  param(
   [parameter(Mandatory=$true, Position=0, ValueFromPipeLine=$true)]
   $InputObject
  )
  return New-Object PSObject -Property $InputObject
}

function Convert-HashesToPSObjects
{
  param(
   [parameter(Mandatory=$true, Position=0, ValueFromPipeLine=$true)]
   $InputObject
  )
  process { $InputObject |% { Convert-HashToPSObject $_ } }
}

$context = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)
$pwd = $null
if ($username -eq $null)
{
  $cred = Get-Credential
  $username = $cred.UserName
  $secpass = $cred.Password
}
else
{
  $secpass = convertto-securestring $password -AsPlainText -Force
}
$context.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($username, $secpass)


$keywordQuery = New-Object Microsoft.SharePoint.Client.Search.Query.KeywordQuery($context)
$queryText = "*"
if ($path -ne $null)
{
    $queryText += " path:" + $path
}
$keywordQuery.QueryText = $queryText
foreach ($managedprop in $selectProperties)
{
    $keywordQuery.SelectProperties.Add($managedprop)
}

if($sort -eq $null)
{
  $sort = "ViewsLifetime"
}
$sortList = $keywordQuery.SortList
$sortList.Add($sort, 1)

$searchExecutor = New-Object Microsoft.SharePoint.Client.Search.Query.SearchExecutor($context)
$searchResults = $searchExecutor.ExecuteQuery($keywordQuery)
$context.ExecuteQuery()

$searchResults.Value.ResultRows | Convert-HashesToPSObjects
