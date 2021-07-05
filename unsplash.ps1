$BasePath = "C:\Users\18rag\Projects\Wallpaper\"
$OutFile = $BasePath + "wallpaper.jpeg"
$Logfile = $BasePath +"Log.log"
$WallCategory = "wallpaper,animals,countryside"
$Uri = "https://source.unsplash.com/1920x1080/?" + $WallCategory
$setwallpapersrc = @"
using System.Runtime.InteropServices;

public class Wallpaper
{
  public const int SetDesktopWallpaper = 20;
  public const int UpdateIniFile = 0x01;
  public const int SendWinIniChange = 0x02;
  [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
  private static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
  public static void SetWallpaper(string path)
  {
    SystemParametersInfo(SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange);
  }
}
"@

Function LogWrite
{
    Param ([string]$LogString)
    $DateTime = "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
    $LogMessage = "$Datetime $LogString"
    Add-content $LogFile -value $LogMessage
}

##### Download File #####
try{
    $webResults = Invoke-WebRequest -Uri $Uri -OutFile $OutFile -TimeoutSec 20 -ErrorAction Stop
    Add-Type -TypeDefinition $setwallpapersrc
    [Wallpaper]::SetWallpaper($WallPath + $OutFile)
}
catch{
    $ErrorObject = $_
    Write-Output $ErrorObject.Exception.
    LogWrite $ErrorObject.Exception.
}