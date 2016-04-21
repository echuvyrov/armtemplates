$dbname=$args[0]
$batfilesource = "https://s3.amazonaws.com/dgsecure/sqlserveronazure/db/sqlcmdadmin.bat"
$zipfilesource = "https://s3.amazonaws.com/dgsecure/sqlserveronazure/db/dbscript.zip"
$sqlinitfilesource = "https://s3.amazonaws.com/dgsecure/sqlserveronazure/db/sqlinitquery.sql"

"After zipfilesource"

$guid=[system.guid]::NewGuid().Guid
$folder="$env:temp\$guid"
New-Item -Path $folder -ItemType Directory

"Folder created"

$batfilelocal = "$folder\sqlcmdadmin.bat"
$zipfilelocal = "$folder\dbscript.zip" 
$zipextracted = "$folder\dbscript\"
$sqlinitfilelocal = "$folder\sqlinitquery.sql"

Invoke-WebRequest $zipfilesource -OutFile $zipfilelocal

Invoke-WebRequest $sqlinitfilesource -OutFile $sqlinitfilelocal

"After invoke"


Add-Type -assembly "system.io.compression.filesystem"
[io.compression.zipfile]::ExtractToDirectory($zipfilelocal, $zipextracted)

"downloading batch file"

Invoke-WebRequest $batfilesource -OutFile $batfilelocal

"batch file downlaoded"

$A = Start-Process -FilePath $folder\sqlcmdadmin.bat -Wait -passthru;$a.ExitCode

"Admin permission granted"

invoke-sqlcmd -InputFile "$folder\dbscript\dbscript\instawdb.sql" -Variable SqlSamplesSourceDataPath="$folder\dbscript\dbscript\" -verbose -ServerInstance $dbname

invoke-sqlcmd -InputFile "$folder\sqlinitquery.sql"  -verbose -ServerInstance $dbname