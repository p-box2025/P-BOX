<div align="center">

# 🚀 P-BOX

**A Modern Cross-Platform Proxy Management Panel**

Powered by Mihomo (Clash.Meta) Core | Elegant Web UI | One-Click Deployment

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Go](https://img.shields.io/badge/Go-1.21+-00ADD8?logo=go)](https://go.dev)
[![React](https://img.shields.io/badge/React-18-61DAFB?logo=react)](https://react.dev)
[![TypeScript](https://img.shields.io/badge/TypeScript-5-3178C6?logo=typescript)](https://typescriptlang.org)

<img src="frontend/public/p-box-logo.png" width="120" alt="P-BOX Logo">

</div>

---

## ✨ Features

- 🎨 **Modern UI** - Beautiful Apple Glass style design with dark/light themes
- ��️ **Cross-Platform** - Supports macOS, Windows, Linux (**OpenWrt NOT supported**)
- 🔧 **System Proxy** - Auto-configure system proxy (macOS/Windows), no manual setup needed
- 📊 **Real-time Dashboard** - Traffic stats, connection monitoring, exit IP display
- 📦 **Subscription Management** - Multiple subscription sources with one-click update
- �� **Core Management** - Auto version detection, one-click download and install
- ⚡ **Config Generator** - Visual rule configuration with smart routing
- 🌐 **i18n** - Chinese/English language support
- 🔐 **Authentication** - Built-in login system to protect the panel

## 📸 Screenshots

### Dashboard
Real-time throughput, traffic stats, DNS statistics, traffic ranking, route stats, and system info.

![Dashboard](https://raw.githubusercontent.com/p-box2025/P-BOX/main/1.png)

### Core Management
Manage Mihomo and Sing-box cores, version detection, one-click install and switch.

![Core Management](https://raw.githubusercontent.com/p-box2025/P-BOX/main/2.png)

### Sing-box Config
Advanced configuration: DNS, traffic routing, rulesets, TLS, NTP, TUN settings and more.

![Sing-box Config](https://raw.githubusercontent.com/p-box2025/P-BOX/main/3.png)

### Traffic History
Traffic trend charts, upload/download statistics, and traffic classification.

![Traffic History](https://raw.githubusercontent.com/p-box2025/P-BOX/main/4.png)

## 🚀 Quick Start

### Linux One-Click Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/p-box2025/P-BOX/main/install.sh | sudo bash
```

The script will:
- Detect system architecture automatically (amd64/arm64)
- Download the latest stable release
- Install to `/etc/p-box`
- Start P-BOX on port **8383**

### Manual Installation

Download pre-built binaries from the [Releases](../../releases) page:

| Platform | File |
|:---|:---|
| macOS Apple Silicon | `p-box-darwin-arm64.tar.gz` |
| macOS Intel | `p-box-darwin-amd64.tar.gz` |
| Linux x64 | `p-box-linux-amd64.tar.gz` |
| Linux ARM64 | `p-box-linux-arm64.tar.gz` |
| Windows x64 | `p-box-windows-amd64.zip` |

```bash
# Extract and run
tar -xzf p-box-*.tar.gz
cd p-box-*
./p-box
```

Visit http://localhost:8383 to access the panel.

### Local Development & Installation

To run P-BOX from source or contribute to development:

#### 📋 Prerequisites
- **Go** 1.21 or higher
- **Node.js** 18 or higher
- **npm** (comes with Node.js)

#### 🔨 Step-by-Step Setup
1. **Clone the repository:**
   ```bash
   git clone https://github.com/p-box2025/P-BOX.git
   cd P-BOX
   ```

2. **Initialize Data Directory:**
   ```bash
   mkdir -p data/configs data/cores data/logs
   ```

3. **Setup Backend:**
   ```bash
   cd backend
   go mod tidy
   go build -o p-box .
   cd ..
   ```

4. **Setup Frontend:**
   ```bash
   cd frontend
   npm install
   cd ..
   ```

#### 🚀 Running the App
The easiest way is to use the provided startup script:
```bash
chmod +x start-all.sh
./start-all.sh
```
Follow the prompts to choose **Development Mode** (1) or **Production Mode** (2).

- **Frontend**: http://localhost:5173
- **Backend**: http://localhost:8383

## 📁 Project Structure

```
p-box/
├── backend/                 # Go Backend
│   ├── main.go              # Entry point
│   ├── server/              # HTTP server
│   ├── modules/             # Feature modules
│   └── data/                # Runtime data
├── frontend/                # React Frontend
│   ├── src/                 # Source code
│   └── public/              # Static assets
├── data/                    # App data (configs, cores, rules)
├── build.sh                 # Multi-platform build script
├── install.sh               # Linux installer script
└── start-all.sh             # Development startup script
```

## 🛠️ Tech Stack

| Backend | Frontend |
|:---:|:---:|
| Go 1.21+ | React 18 |
| Gin | Vite 5 |
| WebSocket | TypeScript |
| YAML | Tailwind CSS |
| | Zustand |
| | i18next |

## ⚙️ Configuration

A default configuration file `data/config.yaml` is generated on the first run:

```yaml
# Server port (Linux default: 8666, others: 8383)
port: 8383

# Proxy port
mixedPort: 7890

# API secret (optional)
secret: ""

# Transparent proxy mode: off, tun, tproxy
transparentMode: "off"
```

## 🤝 Contributing

Pull Requests and Issues are welcome! 

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m "Add amazing feature"`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📜 License

This project is licensed under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- [Mihomo](https://github.com/MetaCubeX/mihomo) - High-performance proxy core
- [Clash](https://github.com/Dreamacro/clash) - Original Clash core
- [Sing-box](https://github.com/SagerNet/sing-box) - The universal proxy platform
- [React](https://react.dev) - Frontend framework
- [Tailwind CSS](https://tailwindcss.com) - CSS framework

---

<div align="center">

**If you find this project helpful, please give it a ⭐️ Star!**

</div>
