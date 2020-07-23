Function Start-AdvaniaPrompt { 
    Function global:prompt {
        $ESC = [char]27

        $Black = @{
            r = 0
            g = 0
            b = 0
        }

        $DarkYellow = @{
            r = 235
            g = 96
            b = 19
        }
        $LightYellow = @{
            r = 255
            g = 188
            b = 35
        }

        $Darkblue = @{
            r = 47
            g = 145
            b = 147
        }
        $LightBlue = @{
            r = 111
            g = 200
            b = 224
        }

        $DarkGreen = @{
            r = 99
            g = 153
            b = 15
        }
        $LightGreen = @{
            r = 146
            g = 184
            b = 78
        }

        $DarkPurple = @{
            r = 194
            g = 1
            b = 137
        }
        $LightPurple = @{
            r = 131
            g = 17
            b = 139
        }

        $TenPercent = [math]::Floor($Host.UI.RawUI.WindowSize.Width / 10)
        $SeventyPercent = $Host.UI.RawUI.WindowSize.Width - ($TenPercent * 3)

        # Calculate and set line position
        $StartPosition = $Host.UI.RawUI.CursorPosition
        $LinePosY = 0
        $LinePosX = 0

        # Dont overwrite the line
        If ($StartPosition.Y -eq 0) {
            $StartPosition.Y = 1
        }
        # Uncomment this for multiline prompt
        # If ($StartPosition.Y -ge ($Host.UI.RawUI.WindowSize.Height -1 )) {
        #    $LinePosY = 1
        #}
        $Host.UI.RawUI.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($LinePosX,$LinePosY)

        # Contents of header line
        $AdvaniaText = "[Advania]".PadRight($TenPercent,' ')
        $PoshOrPWSH = if ($PSVersionTable.PSVersion.Major -ge 6) {
            "[PWSH]".PadRight($TenPercent,' ')
        } else {
            "[PowerShell]".PadRight($TenPercent,' ')
        }
        $PSVersion = "[$($PSVersionTable.PSVersion.ToString())]".PadRight($TenPercent,' ')

        if ($TenPercent -lt $AdvaniaText.Length -or $TenPercent -lt $PoshOrPWSH.Length -or $TenPercent -lt $PSVersion.Length) {
            $AdvaniaText = $(' '*$TenPercent)
            $PoshOrPWSH = $(' '*$TenPercent)
            $PSVersion = $(' '*$TenPercent)
        }
        
        function Add-Color {
            param (
                $Color,
                $Increments
            )
            
            return @{
                r = $Color.r + $Increments.r
                g = $Color.g + $Increments.g
                b = $Color.b + $Increments.b
            }
        }

        # Green Yellow Blue
        # Dark to Light

        # Purple
        # Light to Dark
        $CurrentYellow = $DarkYellow
        $YellowIncrements = @{
            r = [math]::Round(([math]::Max($DarkYellow.r, $LightYellow.r) - [math]::Min($DarkYellow.r, $LightYellow.r))/$AdvaniaText.Length)
            g = [math]::Round(([math]::Max($DarkYellow.g, $LightYellow.g) - [math]::Min($DarkYellow.g, $LightYellow.g))/$AdvaniaText.Length)
            b = [math]::Round(([math]::Max($DarkYellow.b, $LightYellow.b) - [math]::Min($DarkYellow.b, $LightYellow.b))/$AdvaniaText.Length)
        }
        for ($i = 0; $i -lt $AdvaniaText.Length; $i++) {
            $CurrentYellow = Add-Color $CurrentYellow $YellowIncrements
            Write-Host -ForegroundColor White -NoNewline "$ESC[48;2;$($CurrentYellow.r);$($CurrentYellow.g);$($CurrentYellow.b)m$($AdvaniaText[$i])"
        }

        $CurrentBlue = $DarkBlue
        $BlueIncrements = @{
            r = [math]::Round(([math]::Max($DarkBlue.r, $LightBlue.r) - [math]::Min($DarkBlue.r, $LightBlue.r))/$PSVersion.Length)
            g = [math]::Round(([math]::Max($DarkBlue.g, $LightBlue.g) - [math]::Min($DarkBlue.g, $LightBlue.g))/$PSVersion.Length)
            b = [math]::Round(([math]::Max($DarkBlue.b, $LightBlue.b) - [math]::Min($DarkBlue.b, $LightBlue.b))/$PSVersion.Length)
        }
        for ($i = 0; $i -lt $PSVersion.Length; $i++) {
            $CurrentBlue = Add-Color $CurrentBlue $BlueIncrements
            Write-Host -ForegroundColor White -NoNewline "$ESC[48;2;$($CurrentBlue.r);$($CurrentBlue.g);$($CurrentBlue.b)m$($PSVersion[$i])"
        }

        $CurrentGreen = $DarkGreen
        $GreenIncrements = @{
            r = [math]::Round(([math]::Max($DarkGreen.r, $LightGreen.r) - [math]::Min($DarkGreen.r, $LightGreen.r))/$PoshOrPWSH.Length)
            g = [math]::Round(([math]::Max($DarkGreen.g, $LightGreen.g) - [math]::Min($DarkGreen.g, $LightGreen.g))/$PoshOrPWSH.Length)
            b = [math]::Round(([math]::Max($DarkGreen.b, $LightGreen.b) - [math]::Min($DarkGreen.b, $LightGreen.b))/$PoshOrPWSH.Length)
        }
        for ($i = 0; $i -lt $PoshOrPWSH.Length; $i++) {
            $CurrentGreen = Add-Color $CurrentGreen $GreenIncrements
            Write-Host -ForegroundColor White -NoNewline "$ESC[48;2;$($CurrentGreen.r);$($CurrentGreen.g);$($CurrentGreen.b)m$($PoshOrPWSH[$i])"
        }

        $CurrentPurple = $DarkPurple
        $PurpleIncrements = @{
            r = -([math]::Round(([math]::Max($DarkPurple.r, $LightPurple.r) - [math]::Min($DarkPurple.r, $LightPurple.r))/$SeventyPercent))
            g = [math]::Round(([math]::Max($DarkPurple.g, $LightPurple.g) - [math]::Min($DarkPurple.g, $LightPurple.g))/$SeventyPercent)
            b = [math]::Round(([math]::Max($DarkPurple.b, $LightPurple.b) - [math]::Min($DarkPurple.b, $LightPurple.b))/$SeventyPercent)
        }
        for ($i = 0; $i -lt $SeventyPercent; $i++) {
            $CurrentPurple = Add-Color $CurrentPurple $PurpleIncrements
            Write-Host -ForegroundColor White -NoNewline "$ESC[48;2;$($CurrentPurple.r);$($CurrentPurple.g);$($CurrentPurple.b)m$(' ')"
        }
        
        # Write header
        #Write-Host -ForegroundColor White -NoNewline "$ESC[48;2;$($DarkYellow.r);$($DarkYellow.g);$($DarkYellow.b)m$AdvaniaText"
        #Write-Host -ForegroundColor White -NoNewline "$ESC[48;2;$($DarkBlue.r);$($DarkBlue.g);$($DarkBlue.b)m$PSVersion"
        #Write-Host -ForegroundColor White -NoNewline "$ESC[48;2;$($DarkGreen.r);$($DarkGreen.g);$($DarkGreen.b)m$PoshOrPWSH"
        #Write-Host -ForegroundColor White -NoNewline "$ESC[48;2;$($DarkPurple.r);$($DarkPurple.g);$($DarkPurple.b)m$(' ' * $SeventyPercent)"
        Write-Host "$ESC[48;2;$($Black.r);$($Black.g);$($Black.b)m"
        $Host.UI.RawUI.CursorPosition = $StartPosition

        # Actual Prompt - Change your layout here
        #Write-Host -NoNewline "[$(Get-Date -UFormat %T)] "
        # Path
        Write-Host -NoNewline "$($executionContext.SessionState.Path.CurrentLocation)"
        # I like the git
        If (Get-Module Posh-git -ListAvailable) {
            Write-VcsStatus
        }
        "$('>' * ($NestedPromptLevel + 1)) "
    }
}

Import-Module posh-git

If ($Host.UI.RawUI.WindowTitle -eq 'AdvaniaPS') {
    Start-AdvaniaPrompt
}

# Update regex match with beautiful colours! 
Function Invoke-RegexColorizer { 
    $BeautifullRegex = @'
    <Configuration>
    <!-- Add with Update-FormatData -PrependPath -->	
    <ViewDefinitions>
    <View>
        <Name>MatchInfo</Name>
        <ViewSelectedBy>
        <TypeName>Microsoft.PowerShell.Commands.MatchInfo</TypeName>
        </ViewSelectedBy>
        <CustomControl>
        <CustomEntries>
            <CustomEntry>
            <CustomItem>
                <ExpressionBinding>
                    <ScriptBlock>
    [string]$curDir = $pwd.Path 
    if (!$host.UI.SupportsVirtualTerminal)
    {
    $_.ToString($curDir)
    return
    }

    class MatchGroupInfo : System.IComparable{
    [bool] $IsStart
    [int] $GroupId
    [int] $Index
    [string] $Color
    
    static [string] $noColor   = "$([char]0x1B)[0m"
    static [string] $dgray     = "$([char]0x1B)[90m"
    static [string] $lred      = "$([char]0x1B)[91m"
    static [string] $lgreen    = "$([char]0x1B)[92m"
    static [string] $lyellow   = "$([char]0x1B)[93m"
    static [string] $lblue     = "$([char]0x1B)[94m"
    static [string] $lmagenta  = "$([char]0x1B)[95m"
    static [string] $lcyan     = "$([char]0x1B)[96m"

    hidden static [string[]] $_groupColors = 
        [MatchGroupInfo]::noColor, 
        [MatchGroupInfo]::lyellow, 
        [MatchGroupInfo]::lmagenta,
        [MatchGroupInfo]::lcyan, 
        [MatchGroupInfo]::dgray,  
        [MatchGroupInfo]::lblue,          
        [MatchGroupInfo]::lgreen,                                      
        [MatchGroupInfo]::lred
    
    hidden static [hashtable] $_colorNameToColor = @{
        nocolor = [MatchGroupInfo]::noColor
        yellow =  [MatchGroupInfo]::lyellow
        ye =      [MatchGroupInfo]::lyellow
        magenta = [MatchGroupInfo]::lmagenta
        ma =      [MatchGroupInfo]::lmagenta
        cyan =    [MatchGroupInfo]::lcyan
        cy =      [MatchGroupInfo]::lcyan
        gray =    [MatchGroupInfo]::dgray
        gy =      [MatchGroupInfo]::dgray
        blue =    [MatchGroupInfo]::lblue
        bl =      [MatchGroupInfo]::lblue
        green =   [MatchGroupInfo]::lgreen
        gn =      [MatchGroupInfo]::lgreen
        red =     [MatchGroupInfo]::lred
        re =      [MatchGroupInfo]::lred
    }
    hidden static [string[]] $_colorNames = 'ye', 'yellow', 'gy', 'red', 're', 'bl', 'gn', 'nocolor', 'magenta', 'gray', 'green', 'blue', 'ma', 'cy', 'cyan'

    [string] ToString(){
        if ($this.IsStart){
            return "Start of {0} at {1}" -f $this.GroupId, $this.Index
        }
        else{
            return "End of {0} at {1}" -f $this.GroupId, $this.Index
        }
    }

    MatchGroupInfo([int] $Index, [int] $GroupId, [bool] $IsStart){
        $this.Index = $Index
        $this.GroupId = $GroupId
        $this.IsStart = $IsStart
        $this.Color = [MatchGroupInfo]::noColor
    }

    MatchGroupInfo([int] $Index, [int] $GroupId, [bool] $IsStart, [string] $Color){
        $this.Index = $Index
        $this.GroupId = $GroupId
        $this.IsStart = $IsStart
        $this.Color = $color
    }

    [int] CompareTo([object]$obj){
        [MatchGroupInfo] $other = $obj
        $res = $this.Index.CompareTo($other.Index)
        if ($res -ne 0){
            return $res
        }
        if(!$this.IsStart -and !$other.IsStart){
            $res= $other.GroupId.CompareTo($this.GroupId)
        }
        else{
            $res= $this.GroupId.CompareTo($other.GroupId)
        }
        if($res -ne 0)
        {
            return $res
        }
        $res = $this.IsStart.CompareTo($other.IsStart)
        return -$res
    }

    static [string] GetGroupColor([int] $index){
        $len = [MatchGroupInfo]::_groupColors.Length
        if($index -ge $len){
            $retVal =  [MatchGroupInfo]::_groupColors[$len - 1] 
        }
        else{
            $retVal =  [MatchGroupInfo]::_groupColors[$index]
        }
        Write-Debug "$index -> $($retVal.SubString(1))"
        return $retVal
    }

    static [string] GetGroupColor([string] $groupName){
        $local:color = [MatchGroupInfo]::_colorNameToColor[$groupName]
        if ($color){
            return $color
        }
        return [MatchGroupInfo]::noColor
    }
    
    static [System.Collections.Generic.List[MatchGroupInfo]] GetGroupInfo([Microsoft.PowerShell.Commands.MatchInfo] $matchInfo){
        $text = $matchInfo.Line       
        [regex] $re = $matchInfo.Pattern
        $namedColors = if($matchInfo.Matches[0].Groups.Count -eq 1){
            $false
        }
        else{
            $groupNames = [System.Linq.Enumerable]::Skip($re.GetGroupNames(),1)
            [System.Linq.Enumerable]::All($groupNames, [Func[string,bool]] {param([string]$s)$s -in [MatchGroupInfo]::_colorNames}) 
        }
        $matchList = [System.Collections.Generic.List[MatchGroupInfo]]::new($MatchInfo.Matches[0].Groups.Count)
        $matchList.Add([MatchGroupInfo]::new(0, 0, $true))
        for($i = 0; $i -lt $matchInfo.Matches[0].Groups.Count; $i++){
            $g = $matchInfo.Matches[0].Groups[$i]
            [string] $local:color = if($namedColors){
                $groupName = $re.GroupNameFromNumber($i)
                [MatchGroupInfo]::GetGroupColor($groupName) 
            }
            else {
                [MatchGroupInfo]::GetGroupColor($i+1)
            }
            $matchList.Add([MatchGroupInfo]::new($g.Index, $i + 1, $true, $color))        
            $matchList.Add([MatchGroupInfo]::new($g.Index + $g.Length, $i + 1, $false))
        } 
        $matchList.Sort()
        $matchList.Add([MatchGroupInfo]::new($text.Length, 0, $false))
                
        return $matchList
    }

    static [string] FormatMatchInfo([Microsoft.PowerShell.Commands.MatchInfo] $matchInfo){
        
        $sb = [System.Text.StringBuilder]::new()
        $text = $matchInfo.Line
        $sb.Capacity = $matchInfo.Line.Length*2
        
        $matchList = [MatchGroupInfo]::GetGroupInfo($matchInfo)
        
        $colorStack = [System.Collections.Generic.Stack[string]]::new()
        
        for($j = 0; $j -le $matchList.Count -2; $j++){
            $currentInfo = $matchList[$j]
            $end = $matchList[$j +1].Index
            $startIndex = $currentInfo.Index
            $length = $end - $startIndex
            
            if($currentInfo.IsStart){
                $c = $currentInfo.Color
                $colorStack.Push($c)
                if ($length -ne 0){
                    if($j -ne 0){
                        $sb.Append($c)
                    }
                    $t=$text.SubString($startIndex, $length)                    
                    $sb.Append($t)
                }
            }
            else{
                $colorStack.Pop()
                $c = $colorStack.Peek()
                
                if ($length -gt 0){
                    $t=$text.SubString($startIndex, $length)                    
                    $sb.Append($c)
                    $sb.Append($t)
                }
            }
            
        }
                    
        $sb.Append([MatchGroupInfo]::noColor)
        return $sb.ToString()
    }
    }


    function FormatLine($matchInfo, [string]$line, [int]$lineNumber, [string]$displayPath, [string]$prefix, [switch]$isMatchLine)
    {
    if ($isMatchLine)
    {
        $line = [MatchGroupInfo]::FormatMatchinfo($matchInfo)
    }

    if ($matchInfo.Path -ne 'InputStream')
    {
        "{0}{1}:{2}:{3}" -f $prefix, $displayPath, $lineNumber, $line
    }
    else
    {
        "{0}{1}" -f $prefix, $line
    }
    }

    $displayPath = if ('' -eq $curDir) { $_.Path } else { $_.RelativePath($curDir) }
    if ($null -eq $_.Context)
    {
    FormatLine -MatchInfo $_ -Line $_.Line -LineNumber $_.LineNumber -DisplayPath $displayPath -Prefix "" -IsMatchLine
    }
    else
    {
    $lines = . {
    $displayLineNumber = $_.LineNumber - $_.Context.DisplayPreContext.Length;
    foreach ($contextLine in $_.Context.DisplayPreContext)
    {
        FormatLine -MatchInfo $_ -Line $contextLine -LineNumber $displayLineNumber -DisplayPath $displayPath -Prefix "  "
        $displayLineNumber += 1
    }

    FormatLine -MatchInfo $_ -Line $_.Line -LineNumber $displayLineNumber -DisplayPath $displayPath -Prefix "> " -IsMatchLine
        $displayLineNumber += 1

    foreach ($contextLine in $_.Context.DisplayPostContext)
    {
        FormatLine -MatchInfo $_ -Line $contextLine -LineNumber $displayLineNumber -DisplayPath $displayPath -Prefix "  "
        $displayLineNumber += 1
    }
    }

    $lines -join ([Environment]::Newline)
    }
    </ScriptBlock>
                </ExpressionBinding>
                </CustomItem>
            </CustomEntry>
            </CustomEntries>
        </CustomControl>
    </View>
    </ViewDefinitions>
    </Configuration>
'@
    $RegexTmpFile = New-TemporaryFile
    $BeautifullRegex | Out-File -FilePath $RegexTmpFile
    Rename-Item $RegexTmpFile -NewName $($RegexTmpFile.FullName.Replace('.tmp','.ps1xml'))
    Update-FormatData -Prepend $RegexTmpFile.FullName.Replace('.tmp','.ps1xml')
    Remove-Item $($RegexTmpFile.FullName.Replace('.tmp','.ps1xml'))
}

function ff($uri) {& 'C:\Program Files\Mozilla Firefox\firefox.exe' $uri}
function np($file){& 'C:\Program Files\Notepad++\notepad++.exe' $file}

