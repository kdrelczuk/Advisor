$path = ".\artefacts\out"

$0 = Test-Path $path
if (!$0) { New-Item -ItemType directory -Path $path }
else { Remove-Item ($path + '\*') }

'option batch abort' | Out-File ($path + "\spdf.txt") -Append
'option confirm off' | Out-File ($path + "\spdf.txt") -Append

'open scp://ubuntu@ec2-54-191-63-43.us-west-2.compute.amazonaws.com -privatekey=C:\rserver01.ppk ' | Out-File ($path + "\spdf.txt") -Append
'put C:\Git\Advisor\src\Advisor.R\ /Advisor.R/' | Out-File ($path + "\spdf.txt") -Append

'exit' | Out-File ($path + "\spdf.txt") -Append
