# Define paths
$certificatePath = Join-Path $PSScriptRoot "myapp.cer" # Path to the exported certificate
$storeLocation = "LocalMachine" # Store location (LocalMachine for system-wide trust)
$storeName = "Root" # Trusted Root Certification Authorities store

# Step 1: Check if the certificate file exists
Write-Host "Checking if the certificate file exists..."
if (-not (Test-Path $certificatePath)) {
    Write-Host "Error: Certificate file not found at $certificatePath."
    exit 1
}

# Step 2: Add the certificate to the Trusted Root Certification Authorities store
Write-Host "Adding certificate to the $storeLocation\$storeName store..."
try {
    # Import the certificate using CertUtil
    certutil -addstore -f $storeName $certificatePath

    Write-Host "Certificate successfully added to the $storeLocation\$storeName store."
} catch {
    Write-Host "Error adding certificate to the trusted store: $_"
    exit 1
}

# Step 3: Verify the certificate was added
Write-Host "Verifying the certificate was added to the trusted store..."
try {
    $certificates = Get-ChildItem -Path "Cert:\$storeLocation\$storeName" | Where-Object { $_.Subject -like "*CN=localhost*" }
    if ($certificates.Count -gt 0) {
        Write-Host "Certificate verified in the trusted store."
    } else {
        Write-Host "Warning: Certificate not found in the trusted store. Please check manually."
    }
} catch {
    Write-Host "Error verifying the certificate: $_"
}