Function magma-prepare {
  <#
    .SYNOPSIS
    .DESCRIPTION
    .INPUTS
    .OUTPUTS
    .EXAMPLE
    .LINKS

#>
param(
   [Parameter(Mandatory=$true,
    ValueFromPipeline=$false)]
    [string[]]$Path,
   [Parameter()]
      [string[]]$Study,
      [string[]]$Samplesheet
)
 $samples = ls $path | ForEach-Object {$_.split("_")[0]} | sort -u
 $reads = ls $path
 # Study,Sample,Library,Attempt,R1,R2,Flowcell,Lane,Index Sequence
 #$line = "$study"+","+"$sample"
 if(Test-Path $samplesheet){
 Write-Output "Overwriting $Samplesheet"
 Set-Content "Study,Sample,Library,Attempt,R1,R2,Flowcell,Lane,Index Sequence" -path $samplesheet
 }
 foreach ($sample in $samples){
 Write-Output "Processing $sample" 
 $matches = $reads | Select-String -Pattern $sample
 if($matches.count -eq 2){
	$library = 1
	$attempt = 1
	$flowcell = 1
	$lane = 1
	$indexSequence = 1
	$line= @("$Study",$sample,$library,$attempt,$matches[0],$matches[1],$flowcell,$Lane,$indexSequence) -Join "," 
 	Write-Output $line >> $samplesheet
 }
 elseif($matches.count%2 -eq0){
	$library = 1
        $attempt = 0
	$flowcell = 1
        $lane = 1
   	$indexSequence = 1
 	foreach($i in 1..($matches.count/2)){
	$attempt +=1
	$line=@("$Study",$sample,$library,$attempt,$matches[$i*2-2],$matches[$i*2-1],$flowcell,$lane,$indexSequence) -Join ","
	Write-Output $line >> $samplesheet
	
	}
 }
 elseif($matches.count%2 -ne 0){
	 write-host "$sample match a odd number of reads"}
 #Write-Output $line
 }

}
