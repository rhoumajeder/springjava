# Define variables
$keystorePath = Join-Path $PSScriptRoot "rjespringboot3/src/main/resources/keystore.jks"
$keystorePassword = "changeit" # Change this to a secure password
$keyAlias = "myapp"

# Step 1: Check if keytool is available
Write-Host "Checking for keytool..."
if (-not (Get-Command keytool -ErrorAction SilentlyContinue)) {
    Write-Host "Error: 'keytool' is not available. Please ensure the JDK is installed and added to PATH."
    exit 1
}

# Step 2: Generate the keystore
Write-Host "Generating keystore at $keystorePath..."
try {
    keytool -genkeypair `
        -alias $keyAlias `
        -keyalg RSA `
        -keysize 2048 `
        -validity 365 `
        -keystore $keystorePath `
        -storepass $keystorePassword `
        -keypass $keystorePassword `
        -dname "CN=localhost, OU=IT, O=MyCompany, L=MyCity, ST=MyState, C=US"
    Write-Host "Keystore generated successfully at $keystorePath"
} catch {
    Write-Host "Error generating keystore: $_"
    exit 1
}