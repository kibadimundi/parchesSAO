param(
    [Parameter(Mandatory=$true)]
    [String]$PathIn,
    [Parameter(Mandatory=$true)]
    [String]$PathOut
)

function Check-Command($cmdname)
{
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}



if ((Check-Command -cmdname "magick.exe") -eq $false)
{
    Write-Host "Not installed ImageMagick"
    exit(1)
}

$list=Get-ChildItem -Directory $PathIn -Depth 1

if (("(a)" -in $list.Name) -and ("(b)" -in $list.Name)-and ("anim" -in $list.Name))
{
    foreach ($folder in $list.Name)
    {
        if (("(a)" -eq $folder) -or ("(b)" -eq $folder) -or ("anim" -eq $folder))
        {
            $path=Join-Path $PathIn $folder
            $files=Get-ChildItem $path
            foreach ($file in $files.Name)
            {   $pathfile=Join-Path $path $file
                $pathfileout=Join-Path $PathOut $folder $file
                $string=@($pathfile,'-coalesce',$pathfileout)
                & 'magick.exe'  $string
            }
        }
    }
}else{
    Write-Host "Not complete folder list for char"
    exit(1)
}


Write-Host "Completed task"

exit(0)
