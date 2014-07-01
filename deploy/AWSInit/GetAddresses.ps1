Set-AWSCredentials -AccessKey AKIAICHBP6K4MHHIKWZQ -SecretKey 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 -StoreAs AdvisorAWS
Set-AWSCredentials -StoredCredentials AdvisorAWS


$runningInstances = (Get-EC2Instance -Region us-west-2).Instances | ?{ $_.State.Name -eq 'running' }  
$runningInstances | %{
   $_.PublicIpAddress | Out-File "C:\rserversIps.txt" -Append
   $_.PublicDnsName | Out-File "C:\rserversDns.txt" -Append
}
# Get-Command -Module AWSPowerShell | Select-String region