# Windows 10 LTSC IoT

1. **Download Windows 10 LTSC IoT** from: [massgrave.dev/windows_ltsc_links](https://massgrave.dev/windows_ltsc_links)
2. **Download Rufus**: [rufus.ie](https://rufus.ie/)
3. **Use Rufus** to flash the ISO onto a USB drive.
   * *Optional:* Select the option to "Create a local account" (recommended).
4. **Important:** Install all Windows Updates immediately after installation before proceeding with further configurations.

---

## Post-Installation

Recommended steps to optimize and set up your environment.

### Applications and Windows Store

In order to install the **Microsoft Store**, run this command in PowerShell as an Administrator:

```powershell
wsreset -i
```

If you prefer to install applications via **winget**, you can install the package manager with the following command (see [Microsoft Learn](https://learn.microsoft.com/en-us/windows/package-manager/winget/) for details):

```powershell
Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
```

### Activation

Refer to [massgrave.dev](https://massgrave.dev/) for documentation. To use the activation script:

1. Run **PowerShell** as an Administrator.
2. Copy and paste the following command, then press **Enter**:

```powershell
irm https://get.activated.win | iex
```

1. Select one of the options highlighted in **Green** (preferably "HWID / Hardware Activation").

### Debloat and Software

1. Run **PowerShell** as an Administrator.
2. Execute the Chris Titus Tech utility command:

```powershell
irm https://christitus.com/win | iex
```

#### Recommendations:

- Navigate to **Tweaks**, select **Desktop**, and choose the **Standard** selection (customize according to your preferences).
- Run **O&O ShutUp10** (via the Tweaks tab).
- Activate the **Ultimate Performance** power profile.
- **Restart** your computer.
- Relaunch the tool to install your desired software from the **Config** or **Install** tabs.

My personal Software configuration for importing into **Chris Titus Tech utility:**

```json
winget install OpenWhisperSystems.Signal Mozilla.Thunderbird Microsoft.VisualStudioCode 7zip.7zip Nextcloud.NextcloudDesktop Obsidian.Obsidian ElectronicArts.EADesktop Discord.Discord Microsoft.WindowsTerminal EpicGames.EpicGamesLauncher Microsoft.PowerToys Valve.Steam Mozilla.Firefox Git.Git Docker.DockerDesktop CoreyButler.NVMforWindows Brave.Brave GitHub.GitHubDesktop JetBrains.Toolbox Bitwarden.Bitwarden Microsoft.VisualStudio.Community dbeaver.dbeaver usebruno.bruno Spotify.Spotify 9WZDNCRFJBH4 -e --accept-package-agreements --accept-source-agreements
```
