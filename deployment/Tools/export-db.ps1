

function global:Export-Db([string]$dbname, [string]$server=".\SqlExpress",$output="$dbname.sql"){
    function export() {
        [reflection.assembly]::LoadWithPartialName(”Microsoft.SqlServer.Smo”) | Out-Null
        $serverSmo = New-Object (’Microsoft.SqlServer.Management.Smo.Server’) -argumentlist $server
        
        $db = $serversmo.databases[$dbname]
       
        if($db){
            "exporting $dbname from $server"
            if (test-path $output) { remove-item $output }
            Dump-Db $db > $output
            if (test-path ".\$output.zip") { remove-item ".\$output.zip" }
            ls $output | out-zip ".\$output.zip" $_
        }
    }

    function out-zip($path){
        $files = $input
          
        if (-not $path.EndsWith('.zip')) {$path += '.zip'} 

        if (-not (test-path $path)) { 
          set-content $path ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18)) 
        } 

        $zip=resolve-path($path)
        $ZipFile = (new-object -com shell.application).NameSpace( "$zip" ) 
        $files | foreach {$ZipFile.CopyHere($_.fullname)} 
    }


    function Dump-Db($db) {

        function Get-SmoObjects($db) {
            $all = $db.Tables 
            $all += $db.StoredProcedures
            $all += $db.Views
            $all += $db.UserDefinedFunctions
            $all | where {!($_.IsSystemObject)}
        }
        
        function Generate-ObjectsWithDependencies($objList, $parents) {
            Write-Host -noNewLine "  Calculating dependencies..."
            $depTree = $depWalker.DiscoverDependencies($objList, $parents)
            $orderedUrns = $depWalker.WalkDependencies($depTree)

            Write-Host "done"    
            Write-Host -noNewLine "  Writing script..."
        
            foreach($urn in $orderedUrns) {
                $smoObject = $serverSmo.GetSmoObject($urn.Urn)
                foreach($script in $scrp.EnumScript($smoObject)) {
                    $script
                    "GO"
                }
            }
            
            Write-Host "done"
        }

     

        $scrp = new-object ('Microsoft.SqlServer.Management.Smo.Scripter') ($db.Parent)
        $depWalker = New-Object ('Microsoft.SqlServer.Management.Smo.DependencyWalker') $db.Parent
        
        Write-Host -noNewLine "Stage 1/2: finding server objects..."
        $dbObjects = Get-SmoObjects $db
        Write-Host "done"
        
        Write-Host "Stage 2/2: Exporting Data"
        $scrp.Options.ScriptDrops = $False
        $scrp.Options.IncludeIfNotExists = $False
        
        $scrp.Options.ClusteredIndexes = $False
        $scrp.Options.DriAll = $False
        $scrp.Options.Indexes = $False
        $scrp.Options.Triggers = $False
        
        $scrp.Options.ScriptSchema = $False
        $scrp.Options.ScriptData = $True

        Generate-ObjectsWithDependencies $dbObjects $True
        Write-Host "Stage 2/2 complete" 
    }

    export
}
