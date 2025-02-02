# Define variables
$installerPath = "C:\Users\rhoum\Desktop\D\avaloq\jdk\fmw_14.1.1.0.0_wls_lite_generic.jar" # Path to the downloaded WebLogic installer
$installDir = "C:\Oracle\Middleware" # Installation directory for WebLogic
$javaHome = "C:\Users\rhoum\Desktop\D\avaloq\jdk\jdk1.8.0_441" # Path to Java 8 installation
$responseFile = "C:\Users\rhoum\Downloads\weblogic_response.rsp" # Silent installation response file
$domainDir = "C:/Oracle/Middleware/user_projects/domains/base_domain"

# Step 1: Check if Java 8 is installed
Write-Host "Checking for Java 8 installation..."
if (-not (Test-Path $javaHome)) {
    Write-Host "Error: Java 8 not found at $javaHome. Please install Java 8 and update the JAVA_HOME path in the script."
    exit 1
}

# Step 2: Check if the installer exists
Write-Host "Checking for WebLogic installer..."
if (-not (Test-Path $installerPath)) {
    Write-Host "Error: WebLogic installer not found at $installerPath. Please download the installer and update the path."
    exit 1
}

# Step 3: Create a silent installation response file
Write-Host "Creating silent installation response file..."
$responseContent = @"
[ENGINE]
Response File Version=1.0.0.0.0
[GENERIC]
ORACLE_HOME=$installDir
INSTALL_TYPE=WebLogic Server
DECLINE_SECURITY_UPDATES=true
SECURITY_UPDATES_VIA_MYORACLESUPPORT=false
"@
try {
    Set-Content -Path $responseFile -Value $responseContent
    Write-Host "Silent installation response file created at $responseFile"
} catch {
    Write-Host "Error creating response file: $_"
    exit 1
}

# Step 4: Run the WebLogic installer in silent mode
Write-Host "Installing WebLogic silently..."
try {
    Push-Location (Split-Path $installerPath)
    $javaExecutable = Join-Path $javaHome "bin\java.exe" # Use the JDK's java executable
    Start-Process -FilePath $javaExecutable -ArgumentList "-jar", (Split-Path $installerPath -Leaf), "-silent", "-responseFile", $responseFile -NoNewWindow -Wait
    Write-Host "WebLogic installed successfully at $installDir"
} catch {
    Write-Host "Error installing WebLogic: $_"
    exit 1
} finally {
    Pop-Location
}

# Step 5: Create a WebLogic domain
Write-Host "Creating a WebLogic domain..."
$domainScript = @"
readTemplate('$installDir/wlserver/common/templates/wls/wls.jar')
cd('Servers/AdminServer')
set('ListenAddress','localhost')
set('ListenPort',7001)
cd('/')
cd('Security/base_domain/User/weblogic')
cmo.setPassword('password123')
setOption('OverwriteDomain','true')
writeDomain('$domainDir')
closeTemplate()
exit()
"@
$domainScriptPath = "$env:TEMP\create_domain.py"
try {
    Set-Content -Path $domainScriptPath -Value $domainScript
    Write-Host "Domain creation script created at $domainScriptPath"
    Push-Location "$installDir\oracle_common\common\bin"
    Start-Process -FilePath ".\config.cmd" -ArgumentList "-mode=silent", "-silent_script=$domainScriptPath" -NoNewWindow -Wait
    Write-Host "WebLogic domain created successfully at $domainDir"
} catch {
    Write-Host "Error creating WebLogic domain: $_"
    exit 1
} finally {
    Pop-Location
}

# Step 6: Start the WebLogic Admin Server
Write-Host "Starting WebLogic Admin Server..."
try {
    Push-Location "$domainDir\bin"
    Start-Process -FilePath ".\startWebLogic.cmd" -NoNewWindow
    Write-Host "WebLogic Admin Server started successfully. Access the console at http://localhost:7001/console"
} catch {
    Write-Host "Error starting WebLogic Admin Server: $_"
    exit 1
} finally {
    Pop-Location
}

Write-Host "WebLogic installation and setup completed successfully!"