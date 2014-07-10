$path = ".\artefacts\out"

$0 = Test-Path $path
if (!$0) { New-Item -ItemType directory -Path $path }
else { Remove-Item ($path + '\*') }

'option batch abort' | Out-File ($path + "\sfpd.txt") -Append
'option confirm off' | Out-File ($path + "\sfpd.txt") -Append

$a = Get-Content 'rservers\dns.txt'

$a | 
%{ 
    ('open scp://ubuntu@' + $_ + ' -privatekey=keys/rserver01.ppk') | Out-File ($path + "\sfpd.txt") -Append
    'put src\ /Advisor.R/' | Out-File ($path + "\sfpd.txt") -Append
}

'exit' | Out-File ($path + "\sfpd.txt") -Append
