Param(
  [string] $Base64File = "hello.docx.base64",
  [string] $TargetFile = "hello.docx",
  [switch] $Commit
)

if (-not (Test-Path $Base64File)) {
  Write-Error "找不到 $Base64File，請先確認檔案存在於 repo root。"
  exit 1
}

$base64 = Get-Content -Raw -Path $Base64File
[byte[]] $bytes = [System.Convert]::FromBase64String($base64)
[System.IO.File]::WriteAllBytes($TargetFile, $bytes)
Write-Host "已產生 $TargetFile"

if ($Commit) {
  git config user.name "github-actions[bot]"
  git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
  git add $TargetFile
  git commit -m "Generate hello.docx from hello.docx.base64" -q || Write-Host "No changes to commit"
  git push
}