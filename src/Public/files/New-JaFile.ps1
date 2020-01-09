function New-JaFile {

  [Alias('jatouch')]
  [cmdletbinding()]
  param(
    [Parameter(Mandatory, ValueFromPipeline)]
    [string]$fileName,
    [switch]$OverWrite,
    [parameter(ValueFromRemainingArguments)]
    [string[]]$Content
  )

  begin {
    $files = @()
    $boilerPlates = Get-ChildItem $home\.jaseisei\stores\boilerPlates -Recurse
  }

  process {

    $parent = Split-Path $fileName
    $fileName = Split-Path $fileName -Leaf

    if ([string]::IsNullOrEmpty($parent)) { $parent = "$pwd" }
    elseif (!(Test-Path $parent)) { $null = mkdir $parent }

    $path = Join-Path $parent $fileName
    $files += , ($path, $fileName, $content)

  }

  end {

    $files |
      ForEach-Object {
        $path, $fileName, $content = $_

        if (![string]::IsNullOrEmpty($Content)) { $content > "$path" }
        else {
          $save = $true

          $boilerPlates |
            Where-Object { $_.name -like $fileName } |
            ForEach-Object {
              Copy-Item $_ -Destination $path -ErrorAction Stop
              $save = $false
            }

          if ($save) {
            $null = New-Item -Path $path -Force:$OverWrite -ErrorAction SilentlyContinue
          }
        }
        $PSItem = $path
      }
    invoke-item $PSItem
  }
}
