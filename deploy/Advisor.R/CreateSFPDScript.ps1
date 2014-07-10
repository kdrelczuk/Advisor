$path = ".\artefacts\out"

$0 = Test-Path $path
if (!$0) { New-Item -ItemType directory -Path $path }
else { Remove-Item ($path + '\*') }

'option batch abort' | Out-File ($path + "\spdf.txt") -Append
'option confirm off' | Out-File ($path + "\spdf.txt") -Append

$a = Get-Content 'rservers\dns.txt'

$a | 
%{ 
    ('open scp://' + $_ + ' -privatekey=keys/rserver01.ppk') | Out-File ($path + "\spdf.txt") -Append
    'put src\ /Advisor.R/' | Out-File ($path + "\spdf.txt") -Append
}

'exit' | Out-File ($path + "\spdf.txt") -Append
