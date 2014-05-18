# Autor - Priit Varul A21
# Kuupäev - 18.05.2014
# Skript logib sisse BasicAuth abil kaitstud veebilehele ja laeb sealt alla faili.

#Argumentide sisestamine
$link=$args[0] #Aadressi argument.
$kaust=$args[1] #Kausta argument.
$liigne=$args[2] #Kui argumentide arv ületab lubatu.
$test_kaust="C:\test_kaust"
$test_link="http://enos.itcollege.ee/~pvarul/Test/Test1.txt"

#Kontrollime argumente.
if (!$link)
{
    $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Jah", `
        "Kasuta test väärtus $test_link"

    $no = New-Object System.Management.Automation.Host.ChoiceDescription "&Ei", `
        "Lõpetab skripti töö ja proovib uuesti."
    $kysitlus=[System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
    $result = $host.ui.PromptForChoice("Aadress pole sisestatud", "Kas kasutame test aadresi?", $kysitlus, 0)
    switch ($result)
        {
            0 { 
                $link=$test_link 
                Write-Host "Aadressiks kasutame $test_link"
              }
            1 { 
                Write-Host "HTTP aadress pole määratud. Käivita skript järgnevalt: .\priit_powershell.ps1 http://testlink.com $test_kaust"
                exit 1 
              }
        }
}
if (!$kaust)
{
    Write-Host "Salvestamiseks pole kausta määratud, kasutan kausta: $test_kaust" #Kui kasutaja kausta parameetrit ei määra siis kasutatakse automaatselt $test_kaust
    $kaust=$test_kaus
}
if ($liigne)
{
    Write-Host "Skriptile on antud üleliigne argument. Käivita skript järgnevalt: .\priit_powershell.ps1 http://testlink.com $test_kaust"
    exit 1
}

Write-Host "Laadime alla faili aadresilt $link ja salvestame selle kausta $kaust"

#Kontrollime kausta olemasolu, kui on puudu loome.
if(!(Test-Path -Path $kaust ))
{
    New-Item -ItemType directory -Path $kaust
}

$kaust = $kaust + "\index.txt"
$tomba=new-object system.net.webclient
$tomba.Credentials=Get-Credential #Küsime kasutajalt kontot, kui neid ei ole vaja siis kasutaja sisestust ignoreeritakse ja skript jätkab tööd.
$tomba.downloadfile($link,$kaust)