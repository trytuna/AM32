# rules to download and install the tools for windows and linux

# download location for tools
WINDOWS_TOOLS=https://github.com/xpack-dev-tools/arm-none-eabi-gcc-xpack/releases/download/v13.2.1-1.1/xpack-arm-none-eabi-gcc-13.2.1-1.1-win32-x64.zip
LINUX_TOOLS=https://github.com/xpack-dev-tools/arm-none-eabi-gcc-xpack/releases/download/v13.2.1-1.1/xpack-arm-none-eabi-gcc-13.2.1-1.1-linux-x64.tar.gz
MACOS_ARM64_TOOLS=https://github.com/xpack-dev-tools/arm-none-eabi-gcc-xpack/releases/download/v13.2.1-1.1/xpack-arm-none-eabi-gcc-13.2.1-1.1-darwin-arm64.tar.gz
MACOS_X64_TOOLS=https://github.com/xpack-dev-tools/arm-none-eabi-gcc-xpack/releases/download/v13.2.1-1.1/xpack-arm-none-eabi-gcc-13.2.1-1.1-darwin-x64.tar.gz

ifeq ($(OS),Windows_NT)

arm_sdk_install:
	@echo Installing windows tools
	@echo downloading windows-tools.zip
	@powershell -Command "& { (New-Object System.Net.WebClient).DownloadFile('$(WINDOWS_TOOLS)', 'windows-tools.zip') }"
	@echo unpacking windows-tools.zip
	@powershell -Command "Expand-Archive -Path windows-tools.zip -Force -DestinationPath tools/xpack"
	@echo windows tools install done

else
# macOS or Linux
UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)

ifeq ($(UNAME_S),Darwin)

arm_sdk_install:
	@which wget || (echo "No wget installed. Consider doing brew install wget"; exit 1)
	@echo Installing macos tools
ifeq ($(UNAME_M),arm64)
	@wget -O macos-tools.tar.gz $(MACOS_ARM64_TOOLS)
else
	@wget $(MACOS_X64_TOOLS)
endif
	@tar xzf macos-tools.tar.gz -C tools --strip-components=1
	@echo macos tools install done

else

arm_sdk_install:
	@echo Installing linux tools
	@wget -O linux-tools.tar.gz $(LINUX_TOOLS)
	@tar xzf linux-tools.tar.gz -C tools --strip-components=1
	@echo linux tools install done

endif
endif
