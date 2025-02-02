# Define paths
$projectRoot = Get-Location
$parentPomPath = Join-Path $projectRoot "pom.xml"
$coreModulePath = Join-Path $projectRoot "module-core"
$simpleModulePath = Join-Path $projectRoot "module-simple"

# Step 1: Create the parent POM
Write-Host "Creating parent POM..."
Set-Content -Path $parentPomPath -Value @"
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.example</groupId>
    <artifactId>rje2-parent</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>pom</packaging>

    <modules>
        <module>module-core</module>
        <module>module-simple</module>
    </modules>
</project>
"@

# Step 2: Move existing code to module-core
Write-Host "Moving existing code to module-core..."
New-Item -ItemType Directory -Path $coreModulePath -Force
Move-Item -Path "$projectRoot/src" -Destination "$coreModulePath/src" -Force
Move-Item -Path "$projectRoot/target" -Destination "$coreModulePath/target" -Force

# Step 3: Create module-core POM
$corePomPath = Join-Path $coreModulePath "pom.xml"
Write-Host "Creating module-core POM..."
Set-Content -Path $corePomPath -Value @"
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>com.example</groupId>
        <artifactId>rje2-parent</artifactId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <artifactId>module-core</artifactId>
</project>
"@

# Step 4: Create module-simple directory and POM
Write-Host "Creating module-simple..."
New-Item -ItemType Directory -Path "$simpleModulePath/src/main/java" -Force
New-Item -ItemType Directory -Path "$simpleModulePath/src/main/resources" -Force
New-Item -ItemType Directory -Path "$simpleModulePath/src/test/java" -Force
New-Item -ItemType Directory -Path "$simpleModulePath/src/test/resources" -Force

$simplePomPath = Join-Path $simpleModulePath "pom.xml"
Write-Host "Creating module-simple POM..."
Set-Content -Path $simplePomPath -Value @"
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>com.example</groupId>
        <artifactId>rje2-parent</artifactId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <artifactId>module-simple</artifactId>
</project>
"@

Write-Host "Multi-module project setup complete!"