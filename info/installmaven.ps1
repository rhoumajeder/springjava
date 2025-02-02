# Step 1: Define variables
$mavenVersion = "3.9.6" # Replace with the desired Maven version
$mavenDownloadUrl = "https://downloads.apache.org/maven/maven-3/$mavenVersion/binaries/apache-maven-$mavenVersion-bin.zip"
$installDir = "C:\Program Files\apache-maven-$mavenVersion"
$tempZipFile = "$env:TEMP\apache-maven-$mavenVersion-bin.zip"

# Step 2: Create the installation directory
Write-Host "Creating installation directory at $installDir..."
if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir | Out-Null
}

# Step 3: Download Maven
Write-Host "Downloading Maven $mavenVersion..."
Invoke-WebRequest -Uri $mavenDownloadUrl -OutFile $tempZipFile

# Step 4: Extract the downloaded zip file
Write-Host "Extracting Maven to $installDir..."
Expand-Archive -Path $tempZipFile -DestinationPath $installDir -Force

# Step 5: Add Maven to PATH
$mavenBinPath = Join-Path $installDir "apache-maven-$mavenVersion\bin"
Write-Host "Adding Maven to PATH: $mavenBinPath..."
$currentPath = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::Machine)
if (-not $currentPath.Contains($mavenBinPath)) {
    [System.Environment]::SetEnvironmentVariable("PATH", "$currentPath;$mavenBinPath", [System.EnvironmentVariableTarget]::Machine)
    Write-Host "Maven added to PATH successfully."
} else {
    Write-Host "Maven is already in PATH."
}

# Step 6: Clean up temporary files
Write-Host "Cleaning up temporary files..."
Remove-Item -Path $tempZipFile -Force

# Step 7: Verify installation
Write-Host "Verifying Maven installation..."
try {
    $mvnVersion = mvn -v
    Write-Host "Maven installed successfully!"
    Write-Host $mvnVersion
} catch {
    Write-Host "Failed to verify Maven installation. Please check your PATH and try again."
}