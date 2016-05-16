$dbname=$args[0]

" dbname : $dbname"

$batfilesource = "https://s3.amazonaws.com/dgsecure/sqlserveronazure/db/sqlcmdadmin.bat"
$sqlinitfilesource = "https://s3.amazonaws.com/dgsecure/sqlserveronazure/db/sqlinitquery.sql"
$bakfilesource = "https://s3.amazonaws.com/dgsecure/sqlserveronazure/db/northwind.bak"
$restoredbfilesource = "https://s3.amazonaws.com/dgsecure/sqlserveronazure/db/restoredb.sql"
$advwrkbakfilesource = "https://s3.amazonaws.com/dgsecure/sqlserveronazure/db/AdventureWorks.bak"


"After filesource"

$guid=[system.guid]::NewGuid().Guid
$folder="$env:temp\$guid"
New-Item -Path $folder -ItemType Directory

"Folder created $folder"

$batfilelocal = "$folder\sqlcmdadmin.bat"
$sqlinitfilelocal = "$folder\sqlinitquery.sql"
$bakfilelocal = "C:\northwind.bak"
$advwrkbakfilelocal = "C:\AdventureWorks.bak"
$restoredbfilelocal = "$folder\restoredb.sql"

Invoke-WebRequest $sqlinitfilesource -OutFile $sqlinitfilelocal

Invoke-WebRequest $bakfilesource -OutFile $bakfilelocal

Invoke-WebRequest $batfilesource -OutFile $batfilelocal

Invoke-WebRequest $advwrkbakfilesource -OutFile $advwrkbakfilelocal

Invoke-WebRequest $restoredbfilesource -OutFile $restoredbfilelocal


"After invoke"


"batch file downlaoded"

$A = Start-Process -FilePath $folder\sqlcmdadmin.bat -Wait -passthru;$a.ExitCode

"Admin permission granted"

"input file - $folder\dbscript\dbscript\instawdb.sql"

invoke-sqlcmd -InputFile "$folder\restoredb.sql" -verbose -ServerInstance $dbname -querytimeout ([int]::MaxValue)

invoke-sqlcmd -InputFile "$folder\sqlinitquery.sql"  -verbose -ServerInstance $dbname -querytimeout ([int]::MaxValue)

"Done creating databases...."