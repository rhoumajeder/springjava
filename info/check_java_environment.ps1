Write-Host "Checking Java environment..."

# Check Java version
Write-Host "`nJava version:"
try {
    java -version 2>&1 | Write-Host
} catch {
    Write-Host "Error: 'java' command not found. Please install Java and add it to PATH."
}

# Check Java compiler version
Write-Host "`nJava compiler (javac) version:"
try {
    javac -version 2>&1 | Write-Host
} catch {
    Write-Host "Error: 'javac' command not found. Please install a JDK and add its bin directory to PATH."
}

# Check location of 'java' executable
Write-Host "`nLocation of 'java' executable:"
try {
    where java 2>&1 | Write-Host
} catch {
    Write-Host "Error: Unable to locate 'java'. Please ensure Java is installed and added to PATH."
}

# Check location of 'javac' executable
Write-Host "`nLocation of 'javac' executable:"
try {
    where javac 2>&1 | Write-Host
} catch {
    Write-Host "Error: Unable to locate 'javac'. Please ensure a JDK is installed and its bin directory is added to PATH."
}

# Check JAVA_HOME
Write-Host "`nJAVA_HOME environment variable:"
if ($env:JAVA_HOME) {
    Write-Host $env:JAVA_HOME
} else {
    Write-Host "JAVA_HOME is not set. Please set it to the root directory of your JDK installation."
}

# Check Maven's Java configuration
Write-Host "`nMaven's Java configuration:"
try {
    mvn -v 2>&1 | Write-Host
} catch {
    Write-Host "Error: Maven is not installed or not in PATH. Please install Maven and try again."
}