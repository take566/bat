echo %date%
echo %time%

SET yyyy=%date:~0,4%
SET mm=%date:~5,2%
SET dd=%date:~8,2%

SET time2=%time: =0%

SET hh=%time2:~0,2%
SET mn=%time2:~3,2%
SET ss=%time2:~6,2%

SET filename=%yyyy%-%mm%%dd%-%hh%%mn%%ss%

SET LOG_DIR=C:\work\log
SET LOG=%LOG_DIR%\cinst_%filename%.txt

REM Check if the log directory exists, create it if it doesn't
IF NOT EXIST "%LOG_DIR%" (
    MKDIR "%LOG_DIR%"
    echo Created log directory: %LOG_DIR%
)
choco install 1password8 -y
choco install 7zip.install -y
choco install adobereader -y
choco install autohotkey.portable -y
choco install brave -y
choco install chocolatey -y
choco install chocolatey-compatibility.extension -y
choco install chocolatey-core.extension -y
choco install chocolatey-dotnetfx.extension -y
choco install chocolatey-windowsupdate.extension -y
choco install curl -y
choco install dbeaver -y
choco install docker-desktop -y
choco install DotNet4.5 -y
choco install DotNet4.5.2 -y
choco install dotnet4.7.1 -y
choco install dotnet4.7.2 -y
choco install dotnetfx -y
choco install Everything -y
choco install filezilla -y
choco install Firefox -y
choco install git -y
choco install git.install -y
choco install GoogleChrome -y
choco install google-chrome-x64 -y
choco install googledrive -y
choco install google-drive-file-stream -y
choco install GoogleJapaneseInput -y
choco install iTunes -y
choco install kubernetes-cli -y
choco install kubernetes-helm -y
choco install lhaplus -y
choco install miniconda3 -y
choco install Minikube -y
choco install netfx-4.7.2 -y
choco install nodejs -y
choco install nodejs.install -y
choco install nvm -y
choco install nvm.install -y
choco install openssh -y
choco install packer -y
choco install PowerShell -y
choco install pyenv-win -y
choco install python -y
choco install python3 -y
choco install python312 -y
choco install python313 -y
choco install sakuraeditor -y
choco install slack -y
choco install sourcetree -y
choco install squid -y
choco install steam -y
choco install teracopy -y
choco install teraterm -y
choco install vcredist140 -y
choco install vcredist2015 -y
choco install virtualbox -y
choco install vlc -y
choco install vlc.install -y
choco install vmware-powercli-psmodule -y
choco install vscode -y
choco install vscode.install -y
choco install winmerge -y
choco install winscp -y
choco install winscp.install -y
choco install zoom -y