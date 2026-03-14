# Kanata Keyboard Remapping

Kanata is a powerful keyboard remapping tool for Windows that allows you to customize your keyboard layout at a low level.

## What is Kanata?

Kanata intercepts keyboard input and remaps keys according to your configuration. It's perfect for:
- Creating ergonomic layouts (like Colemak or Dvorak)
- Adding layers (like Vim navigation anywhere)
- Making dual-function keys (tap vs hold behavior)
- Improving productivity with custom shortcuts

## Installation

### Option 1: Download Executable (Easiest)

1. **Download Kanata** from the official releases:
   ```
   https://github.com/jtroo/kanata/releases
   ```
   Download `kanata_wintercept.exe` or `kanata_winIOv2.exe`

2. **Place in a permanent location**:
   ```powershell
   # Example: Create a Tools directory
   New-Item -Path "$env:USERPROFILE\Tools\Kanata" -ItemType Directory -Force
   Move-Item kanata_*.exe "$env:USERPROFILE\Tools\Kanata\kanata.exe"
   ```

### Option 2: Using Scoop (Recommended)

```powershell
scoop install kanata
```

## Configuration Files

This repository includes a starter configuration for your **AULA F75 keyboard**:

- `kanata-aula-f75.kbd` - Configuration for AULA F75 (75% layout)

### Key Remappings

The default config provides:

1. **Caps Lock → Esc/Nav Layer**
   - Tap: Escape key
   - Hold: Activate navigation layer

2. **Swap Ctrl ↔ Alt** (Left side only)
   - Makes Ctrl easier to reach
   - Better ergonomics for Windows shortcuts

3. **Navigation Layer (hold Caps Lock)**
   - `H` → Left Arrow
   - `J` → Down Arrow
   - `K` → Up Arrow
   - `L` → Right Arrow
   - Vim-style navigation without moving hands!

## Running Kanata

### Manual Start

```powershell
# Navigate to Kanata directory
cd "$env:USERPROFILE\Tools\Kanata"

# Run with your config
.\kanata.exe --cfg "path\to\kanata-aula-f75.kbd"
```

### Auto-Start with Windows (Recommended)

Create a Task Scheduler entry to run Kanata at login:

1. **Open Task Scheduler**: `Win + R` → `taskschd.msc`

2. **Create Basic Task**:
   - Name: `Kanata Keyboard Remapper`
   - Trigger: `At log on`
   - Action: `Start a program`
   - Program: `C:\Users\<YourUsername>\Tools\Kanata\kanata.exe`
   - Arguments: `--cfg "C:\Users\<YourUsername>\.config\kanata\kanata-aula-f75.kbd"`

3. **Advanced Settings**:
   - ✓ Run with highest privileges (required for keyboard interception)
   - ✓ Run whether user is logged on or not

### Quick Auto-Start Script

Run this PowerShell command to create a startup shortcut:

```powershell
# Create startup shortcut (runs at login)
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut("$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Kanata.lnk")
$shortcut.TargetPath = "$env:USERPROFILE\Tools\Kanata\kanata.exe"
$shortcut.Arguments = "--cfg `"$env:USERPROFILE\.config\kanata\kanata-aula-f75.kbd`""
$shortcut.WorkingDirectory = "$env:USERPROFILE\Tools\Kanata"
$shortcut.WindowStyle = 7  # Minimized
$shortcut.Save()
```

## Customization

Edit `kanata-aula-f75.kbd` to customize your layout:

### Common Modifications

**Change tap-hold timing:**
```lisp
;; Syntax: (tap-hold tap-ms hold-ms tap-action hold-action)
(defalias
  cap (tap-hold 150 150 esc (layer-toggle nav))  ; Faster response
)
```

**Add more navigation keys:**
```lisp
(defsrc
  h j k l u i o p
)

(deflayer nav
  left down up right home pgdn pgup end
)
```

**Create a symbols layer:**
```lisp
(deflayer sym
  _ _ _
  _
  [ ] \{ \}  ; Brackets on home row
  _
)
```

## Troubleshooting

### Kanata doesn't start
- **Run as Administrator**: Kanata requires admin privileges to intercept keyboard input
- Check Windows Defender hasn't quarantined the executable

### Keys not remapping
- Verify config file syntax (check for typos)
- Make sure Kanata is running (check system tray)
- Some applications (games) may bypass Kanata - this is normal

### Typing feels weird
- Adjust tap-hold timing in the config
- Start with conservative timings (200ms) and decrease gradually
- Practice makes perfect!

### Want to disable temporarily
- Right-click Kanata tray icon → Exit
- Or press your configured "pause" key (can be added to config)

## Resources

- **Kanata GitHub**: https://github.com/jtroo/kanata
- **Configuration Guide**: https://github.com/jtroo/kanata/blob/main/docs/config.adoc
- **Example Configs**: https://github.com/jtroo/kanata/tree/main/cfg_samples
- **Your Friend's Config**: https://github.com/shivajreddy/dotfiles/tree/main/windows/kanata

## AULA F75 Specific Notes

The AULA F75 is a 75% mechanical keyboard with:
- **80 keys total**
- Dedicated arrow keys
- Compact function row
- No numpad

This makes it perfect for Kanata remapping because:
- You already have arrow keys (so nav layer is optional)
- Compact layout means hands stay in home position
- Mechanical switches provide great tactile feedback for dual-function keys

Enjoy your optimized keyboard experience!
