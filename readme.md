<div align="center">

<img src="https://media.discordapp.net/attachments/1445896089088819230/1446255885323337748/image.png?ex=69335241&is=693200c1&hm=6143222d962ff45084bf1ae55e190d51ad1e7878979ee68eb91990b6c5523b96&=&format=webp&quality=lossless&width=1796&height=902" alt="Custom HUD Preview" width="100%"/>

# 🎮 Custom FiveM HUD

[![FiveM](https://img.shields.io/badge/FiveM-Resource-3ABFEF?style=for-the-badge&logo=fivem&logoColor=white)](https://fivem.net/)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.0.0-blue?style=for-the-badge)](https://github.com/luckav-dev/custom-hud)

**A modern, lightweight, and fully customizable HUD system for FiveM servers with vehicle display and player status tracking.**

[Features](#-features) • [Installation](#-installation) • [Configuration](#-configuration) • [Support](#-support)

</div>

---

## ✨ Features

### 🎯 **Player Status Display**
- **Health** - Real-time health monitoring with low-health warning
- **Armor** - Dynamic armor display (auto-hides when depleted)
- **Hunger** - Food level tracking
- **Thirst** - Hydration monitoring
- **Stamina** - Sprint stamina indicator
- **Stress** - Stress level visualization

### 🚗 **Vehicle HUD**
- **Speedometer** - Clean, easy-to-read speed display (KM/H)
- **Fuel Gauge** - Live fuel level with low-fuel warning
- **RPM Meter** - Dynamic RPM bar with color gradient
- **Gear Indicator** - Current gear display
- **Street Name** - Shows current street location

### 🎨 **Design Highlights**
- Modern, minimalist interface
- Smooth animations and transitions
- Fully responsive scaling for all resolutions
- Custom square minimap integration
- Low-health pulse animation
- Dynamic RPM color changing (green → orange → red)
- Optimized performance (200ms update interval)

### 🔧 **Framework Support**
- ✅ **QBCore** - Full integration
- ✅ **ESX** - Full integration
- ✅ **Standalone** - Works without framework

---

## 📥 Installation

1. **Download** the resource and extract it to your `resources` folder
2. **Rename** the folder to `custom-hud` (or your preferred name)
3. Add the following to your `server.cfg`:
   ```cfg
   ensure custom-hud
   ```
4. **Restart** your server

### 📂 File Structure
```
custom-hud/
├── client.lua          # Client-side logic
├── fxmanifest.lua      # Resource manifest
├── index.html          # UI structure
├── style.css           # HUD styling
└── script.js           # UI interaction
```

---

## ⚙️ Configuration

### Framework Detection
The HUD automatically detects your framework (QBCore or ESX). No manual configuration needed!

### Customizing the HUD

#### **Change Status Update Interval**
Edit `client.lua` (line 102):
```lua
Citizen.Wait(200)  -- Change to your preferred milliseconds
```

#### **Modify Colors**
Edit `style.css` to customize status colors:
```css
/* Health Bar */
.health .progress-fill {
    background: linear-gradient(90deg, #C0392B, #E74C3C);
}

/* Armor Bar */
.armor .progress-fill {
    background: #2980B9;
}
```

#### **Adjust HUD Scale**
Modify the scale in `style.css`:
```css
.hud-container {
    scale: clamp(0.5, calc(0.35vw + 0.35vh), 0.85);
}
```

---

## 🎮 In-Game Usage

The HUD automatically:
- **Shows/hides** based on player state
- **Displays vehicle HUD** when entering a vehicle
- **Hides vehicle HUD** when exiting
- **Shows/hides minimap** dynamically
- **Updates status** in real-time

No commands required - it just works! ✨

---

## 🔄 Framework Events

### QBCore Events
```lua
-- Update player needs
RegisterNetEvent('hud:client:UpdateNeeds')

-- Update stress level
RegisterNetEvent('hud:client:UpdateStress')
```

### ESX Events
```lua
-- Automatic ESX status tick integration
RegisterNetEvent('esx_status:onTick')
```

---

## 🎨 Customization Examples

### Change Speed Unit to MPH
Edit `client.lua` (line 97):
```lua
local speed = GetEntitySpeed(vehicle) * 2.236936  -- MPH instead of KM/H
```

### Remove Specific Status Icons
Comment out the status card in `index.html`:
```html
<!-- Remove stress indicator
<div class="status-card stress">
    ...
</div>
-->
```

---

## 📊 Performance

- **Resmon:** ~0.01ms
- **Update Rate:** 200ms
- **Optimized:** Yes
- **FPS Impact:** Minimal

---

## 🤝 Support

Need help or found a bug?

[![Discord](https://img.shields.io/badge/Discord-Join%20Server-5865F2?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/2qFtaRPHQu)
[![GitHub Issues](https://img.shields.io/badge/GitHub-Report%20Issue-3ABFEF?style=for-the-badge&logo=github&logoColor=white)](https://github.com/luckav-dev/custom-hud/issues)

---

## 📝 Credits

**Developer:** [XoxoPistolas / luckav-dev](https://github.com/luckav-dev)  
**Framework:** FiveM  
**Font:** [Montserrat](https://fonts.google.com/specimen/Montserrat)  
**Icons:** Font Awesome

---

## 💡 More Projects

Explore my complete portfolio of open-source projects, tools, and contributions.

[![View All](https://img.shields.io/badge/View%20All%20Projects-3ABFEF?style=for-the-badge&logo=github&logoColor=white)](https://github.com/luckav-dev?tab=repositories)

---

## 📜 License

This project is licensed under the **MIT License** - feel free to use, modify, and distribute.

---

<div align="center">

**⭐ If you like this resource, please star the repository!**

Made with ❤️ by [luckav-dev](https://github.com/luckav-dev)

</div>
