$ErrorActionPreference = 'Stop'

$RepoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$SourcePath = Join-Path $RepoRoot 'hotstrings\powershell-open.ahk'
$TargetPath = Join-Path $RepoRoot 'hotstrings\vscode-open.ahk'

# ============================================================
# 特殊ケース定義 (トリガー名 -> 生成ブロック)
# ============================================================
$SpecialBlocks = @{
    'stae' = @(
        ':*://vstae:: {'
        '    SendInput("shell:startup{Enter}")'
        '}'
    )
    'ahk' = @(
        ':*://vahk:: {'
        '    OpenInVSCode("C:\Users\0000250059\Documents\AutoHotkey")'
        '}'
    )
    'rep' = @(
        ':*://vrep:: {'
        '    y := FormatTime(, "yyyy")'
        '    m := FormatTime(, "M")'
        '    d := FormatTime(, "yyyy-MM-dd")'
        '    path := "C:\MEIDEN\Box\DA\システム管理課\K-教育訓練\新入社員教育など\20250804_教育資料（藤田充人）\daily_repport\" y "\" m ""'
        '    OpenInVSCode(path)'
        '}'
    )
}

# ============================================================
# パーサー: powershell-open.ahk を hotstring 単位に分解
# ============================================================
function Parse-Blocks {
    param([string[]]$Lines)

    $blocks = [System.Collections.Generic.List[hashtable]]::new()
    $pendingLines = [System.Collections.Generic.List[string]]::new()

    $hotstringHeader = -1
    for ($idx = 0; $idx -lt $Lines.Count; $idx++) {
        if ($Lines[$idx] -match '^\s*#Hotstring\b') {
            $hotstringHeader = $idx
            break
        }
    }
    if ($hotstringHeader -lt 0) {
        return , $blocks
    }

    $firstHotstring = -1
    for ($idx = $hotstringHeader + 1; $idx -lt $Lines.Count; $idx++) {
        if ($Lines[$idx] -match '^\s*:\*://.+?::') {
            $firstHotstring = $idx
            break
        }
    }
    if ($firstHotstring -lt 0) {
        return , $blocks
    }

    $prefix = [System.Collections.Generic.List[string]]::new()
    for ($idx = $firstHotstring - 1; $idx -gt $hotstringHeader; $idx--) {
        if ($Lines[$idx] -match '^\s*$|^\s*;') {
            $prefix.Insert(0, $Lines[$idx])
            continue
        }
        break
    }
    foreach ($line in $prefix) {
        $pendingLines.Add($line)
    }

    $i = $firstHotstring
    while ($i -lt $Lines.Count) {
        $line = $Lines[$i]

        if ($line -match '^\s*:\*://(.+?)::\s*\{') {
            $trigger = $Matches[1]
            $bodyLines = [System.Collections.Generic.List[string]]::new()
            $i++
            while ($i -lt $Lines.Count -and $Lines[$i] -notmatch '^\s*}\s*$') {
                $bodyLines.Add($Lines[$i])
                $i++
            }
            if ($i -lt $Lines.Count) {
                $i++
            }

            $blocks.Add(@{
                Type = 'block'
                Trigger = $trigger
                Body = $bodyLines.ToArray()
                Before = $pendingLines.ToArray()
            })
            $pendingLines.Clear()
            continue
        }

        if ($line -match '^\s*:\*://(.+?)::(.+)$') {
            $blocks.Add(@{
                Type = 'inline'
                Trigger = $Matches[1]
                Replacement = $Matches[2]
                Before = $pendingLines.ToArray()
            })
            $pendingLines.Clear()
            $i++
            continue
        }

        $pendingLines.Add($line)
        $i++
    }

    if ($pendingLines.Count -gt 0) {
        $blocks.Add(@{
            Type = 'trailing'
            Lines = $pendingLines.ToArray()
        })
    }

    return , $blocks
}

if (-not (Test-Path -LiteralPath $SourcePath)) {
    throw "source not found: $SourcePath"
}

$lines = $null
$loaded = $false
for ($attempt = 1; $attempt -le 5; $attempt++) {
    try {
        $lines = Get-Content -LiteralPath $SourcePath -Encoding UTF8
        $loaded = $true
        break
    }
    catch {
        Start-Sleep -Milliseconds 120
    }
}
if (-not $loaded) {
    throw "source read failed: $SourcePath"
}

$blocks = Parse-Blocks -Lines $lines
$out = [System.Collections.Generic.List[string]]::new()

$out.Add('#Requires AutoHotkey v2.0')
$out.Add('')
$out.Add('; ============================================================')
$out.Add('; AUTO-GENERATED from powershell-open.ahk - 編集禁止')
$out.Add('; VSCode でフォルダ/ファイルを開くショートカット集')
$out.Add('; ============================================================')
$out.Add('')
$out.Add('#Hotstring *')
$out.Add('')
$out.Add('; ============================================================')
$out.Add('; ヘルパー関数')
$out.Add('; ============================================================')
$out.Add('')
$helperLines = @(
    'OpenInVSCode(path) {'
    "    code := EnvGet(`"LOCALAPPDATA`") '\Programs\Microsoft VS Code\bin\code.cmd'"
    "    cmd := '`"' code '`" `"' path '`"'"
    '    if A_IsAdmin'
    "        Run('runas /trustlevel:0x20000 `"' cmd '`"',, `"Hide`")"
    '    else'
    "        Run(cmd,, `"Hide`")"
    '}'
)
foreach ($hl in $helperLines) {
    $out.Add($hl)
}

foreach ($block in $blocks) {
    if ($block.Type -eq 'trailing') {
        foreach ($line in $block.Lines) {
            if ($line -notmatch '^\s*$|^\s*;') {
                continue
            }
            $out.Add(($line -replace '; //esp は削除', '; //vesp は削除'))
        }
        continue
    }

    foreach ($line in $block.Before) {
        if ($line -notmatch '^\s*$|^\s*;') {
            continue
        }
        $out.Add(($line -replace '; //esp は削除', '; //vesp は削除'))
    }

    $trigger = $block.Trigger
    if ($SpecialBlocks.ContainsKey($trigger)) {
        foreach ($specialLine in $SpecialBlocks[$trigger]) {
            $out.Add($specialLine)
        }
        continue
    }

    $newTrigger = "v$trigger"
    if ($block.Type -eq 'inline') {
        $replacement = $block.Replacement -replace 'OpenPowerShell\(', 'OpenInVSCode('
        $out.Add(":*://${newTrigger}::${replacement}")
        continue
    }

    $out.Add(":*://${newTrigger}:: {")
    foreach ($bodyLine in $block.Body) {
        $out.Add(($bodyLine -replace 'OpenPowerShell\(', 'OpenInVSCode('))
    }
    $out.Add('}')
}

$content = ($out -join "`n").TrimEnd() + "`n"
[System.IO.File]::WriteAllText($TargetPath, $content, [System.Text.UTF8Encoding]::new($false))
Write-Host "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Generated: $TargetPath"
