Set-AWSCredentials -AccessKey AKIAICHBP6K4MHHIKWZQ -SecretKey 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 -StoreAs AdvisorAWS
Set-AWSCredentials -StoredCredentials AdvisorAWS

$path = ".\artefacts\rservers"

$0 = Test-Path $path
if (!$0) { New-Item -ItemType directory -Path $path }
else { Remove-Item ($path + '\*') }

$runningInstances = (Get-EC2Instance -Region us-west-2).Instances | ?{ ($_.State.Name -eq 'running') -and ($_.KeyName -eq 'rserver01') }  
$runningInstances | %{
   $_.PublicIpAddress | Out-File ($path + "\ips.txt") -Append
   $_.PublicDnsName | Out-File ($path + "\dns.txt") -Append
}
# Get-Command -Module AWSPowerShell | Select-String region