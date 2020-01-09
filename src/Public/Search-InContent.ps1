function  Search-InContent {
  [Alias('jagreb')]
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [string]$Path,
    # [Parameter(Mandatory)]
    # [string]$Pattern,
    # [Parameter(Mandatory, ParameterSetName = 'Basic')]
    # [string]$ReplaceWith,
    [Parameter(Mandatory)]
    [string[]]$PatternsAndReplaces,
    [switch]$FileRename

  )

  $isWildCard = $path -like '.' -or $path -match '\*'

  if ($isWildCard) { $files = Get-ChildItem $Path -Recurse }
  else { $files = @(Get-Item $path) }


  if ($PatternsAndReplaces.count -eq 1) {
    $result = $files | Select-String $PatternsAndReplaces[0]
  } else {

    if ($FileRename) {
      # $files = $files | Rename-Item
    }

    $result = $files |
      ForEach-Object {
        $content = Get-Content $_ -Raw
        $replaceResult = @()

        for ($i = 0; $i -lt $PatternsAndReplaces.Count; $i += 2) {
          $pattern, $ReplaceWith = $PatternsAndReplaces[$i], $PatternsAndReplaces[($i + 1)]
          $content = $content -replace $pattern, $ReplaceWith
          $replaceResult += , (Select-String -Path $_ -Pattern $ReplaceWith)
        }

        $content > $_
        $replaceResult
      }

  }

  return $result
}

# $path = ".\jsonPlaceholder.comments.json"


# # Search-InContent $path body, content, email, postfang
# # Search-InContent $path content, body, postfang, email

# $files = Search-InContent $path email

# $list = 'body, content, email, postfang'.split(', ')








