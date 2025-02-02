<#
    This is a block comment in PowerShell.
    You can add multiple lines of comments here,
    and none of these lines will be executed by the script.
#>

# Define variables
$wildflyVersion = "26.1.2" # Latest WildFly version compatible with Java 8
$wildflyUrl = "https://github.com/wildfly/wildfly/releases/download/$wildflyVersion.Final/wildfly-$wildflyVersion.Final.zip"
$downloadPath = "$env:USERPROFILE\Downloads\wildfly-$wildflyVersion.Final.zip"
$installDir = "$env:USERPROFILE\wildfly-$wildflyVersion.Final"
$javaHome = "C:\Users\rhoum\Desktop\D\avaloq\jdk\OpenJDK8U-jdk_x64_windows_hotspot_8u442b06\jdk8u442-b06" # Update this to your Java 8 installation path

# Step 1: Check if Java 8 is installed
Write-Host "Checking for Java 8 installation..."
if (-not (Test-Path $javaHome)) {
    Write-Host "Error: Java 8 not found at $javaHome. Please install Java 8 and update the JAVA_HOME path in the script."
    exit 1
}


# Step 2: Download WildFly

Write-Host "Downloading WildFly $wildflyVersion..."
try {
    Invoke-WebRequest -Uri $wildflyUrl -OutFile $downloadPath
    Write-Host "WildFly downloaded successfully to $downloadPath"
} catch {
    Write-Host "Error downloading WildFly: $_"
    exit 1
}

# Step 3: Extract WildFly
Write-Host "Extracting WildFly to $installDir..."
try {
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($downloadPath, $installDir)
    Write-Host "WildFly extracted successfully to $installDir"
} catch {
    Write-Host "Error extracting WildFly: $_"
    exit 1
}



# Step 4: Configure JAVA_HOME in WildFly
Write-Host "Configuring JAVA_HOME in WildFly..."
$standaloneConfPath = "C:\Users\rhoum\wildfly-26.1.2.Final\wildfly-26.1.2.Final\bin\standalone.conf.bat"
if (Test-Path $standaloneConfPath) {
    try {
        $content = Get-Content $standaloneConfPath
        $newContent = $content -replace "set JAVA_HOME=", "set JAVA_HOME=$javaHome"
        Set-Content -Path $standaloneConfPath -Value $newContent
        Write-Host "JAVA_HOME configured in standalone.conf.bat"
    } catch {
        Write-Host "Error configuring JAVA_HOME: $_"
        exit 1
    }
} else {
    Write-Host "Error: standalone.conf.bat not found. Please check the WildFly installation."
    exit 1
}

# Step 5: Start WildFly to Verify Installation
Write-Host "Starting WildFly to verify installation..."
try {
    Push-Location "C:\Users\rhoum\wildfly-26.1.2.Final\wildfly-26.1.2.Final\bin"
    Start-Process -FilePath ".\standalone.bat" -NoNewWindow
    Write-Host "WildFly started successfully. Access it at http://localhost:8080"
} catch {
    Write-Host "Error starting WildFly: $_"
    exit 1
} finally {
    Pop-Location
}

Write-Host "WildFly installation completed successfully!"