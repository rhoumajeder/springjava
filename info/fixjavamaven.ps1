# Step 1: Define variables
$jdkPath = "C:\Users\rhoum\Desktop\D\avaloq\jdk\OpenJDK8U-jdk_x64_windows_hotspot_8u442b06\jdk8u442-b06"

# Step 2: Set JAVA_HOME
Write-Host "Setting JAVA_HOME to $jdkPath..."
[System.Environment]::SetEnvironmentVariable("JAVA_HOME", $jdkPath, [System.EnvironmentVariableTarget]::Machine)

# Step 3: Add JDK bin directory to PATH
$javaBinPath = Join-Path $jdkPath "bin"
Write-Host "Adding JDK bin directory to PATH: $javaBinPath..."
$currentPath = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::Machine)
if (-not $currentPath.Contains($javaBinPath)) {
    [System.Environment]::SetEnvironmentVariable("PATH", "$currentPath;$javaBinPath", [System.EnvironmentVariableTarget]::Machine)
    Write-Host "JDK bin directory added to PATH successfully."
} else {
    Write-Host "JDK bin directory is already in PATH."
}

# Step 4: Refresh the environment variables in the current session
Write-Host "Refreshing environment variables in the current session..."
$env:JAVA_HOME = $jdkPath
$env:PATH = "$javaBinPath;$env:PATH"

# Step 5: Verify the setup
Write-Host "Verifying JDK setup..."
try {
    $javaVersion = java -version 2>&1
    Write-Host "Java version:"
    Write-Host $javaVersion

    $javacVersion = javac -version 2>&1
    Write-Host "Javac version:"
    Write-Host $javacVersion
} catch {
    Write-Host "Failed to verify JDK setup. Please check your configuration."
}

# Step 6: Verify Maven configuration
Write-Host "Verifying Maven configuration..."
try {
    $mvnVersion = mvn -v
    Write-Host "Maven configuration:"
    Write-Host $mvnVersion
} catch {
    Write-Host "Maven is not installed or not in PATH. Please install Maven and try again."
}