# Define paths
$projectRoot = Get-Location
$parentPomPath = Join-Path $projectRoot "pom.xml"
$springBootModule = "rjespringboot4"
$springBootModulePath = Join-Path $projectRoot $springBootModule

# Step 1: Update Parent POM to include Spring Boot dependency management and plugin management
Write-Host "Updating parent POM to include Spring Boot dependency management and plugin management..."
[xml]$parentPomXml = Get-Content $parentPomPath

# Add <dependencyManagement> if it doesn't exist
$dependencyManagementNode = $parentPomXml.project.dependencyManagement
if (-not $dependencyManagementNode) {
    $dependencyManagementNode = $parentPomXml.CreateElement("dependencyManagement", $parentPomXml.DocumentElement.NamespaceURI)
    $parentPomXml.project.AppendChild($dependencyManagementNode) | Out-Null
}

# Add Spring Boot BOM to <dependencyManagement>
$bomDependency = $parentPomXml.CreateElement("dependency", $parentPomXml.DocumentElement.NamespaceURI)
$bomGroupId = $parentPomXml.CreateElement("groupId", $parentPomXml.DocumentElement.NamespaceURI)
$bomGroupId.InnerText = "org.springframework.boot"
$bomArtifactId = $parentPomXml.CreateElement("artifactId", $parentPomXml.DocumentElement.NamespaceURI)
$bomArtifactId.InnerText = "spring-boot-dependencies"
$bomVersion = $parentPomXml.CreateElement("version", $parentPomXml.DocumentElement.NamespaceURI)
$bomVersion.InnerText = "3.1.4" # Use the latest version
$bomType = $parentPomXml.CreateElement("type", $parentPomXml.DocumentElement.NamespaceURI)
$bomType.InnerText = "pom"
$bomScope = $parentPomXml.CreateElement("scope", $parentPomXml.DocumentElement.NamespaceURI)
$bomScope.InnerText = "import"

$bomDependency.AppendChild($bomGroupId) | Out-Null
$bomDependency.AppendChild($bomArtifactId) | Out-Null
$bomDependency.AppendChild($bomVersion) | Out-Null
$bomDependency.AppendChild($bomType) | Out-Null
$bomDependency.AppendChild($bomScope) | Out-Null

$dependencyManagementNode.AppendChild($bomDependency) | Out-Null

# Add <build><pluginManagement> if it doesn't exist
$buildNode = $parentPomXml.project.build
if (-not $buildNode) {
    $buildNode = $parentPomXml.CreateElement("build", $parentPomXml.DocumentElement.NamespaceURI)
    $parentPomXml.project.AppendChild($buildNode) | Out-Null
}

$pluginManagementNode = $buildNode.pluginManagement
if (-not $pluginManagementNode) {
    $pluginManagementNode = $parentPomXml.CreateElement("pluginManagement", $parentPomXml.DocumentElement.NamespaceURI)
    $buildNode.AppendChild($pluginManagementNode) | Out-Null
}

# Add Spring Boot Maven Plugin to <pluginManagement>
$plugin = $parentPomXml.CreateElement("plugin", $parentPomXml.DocumentElement.NamespaceURI)
$pluginGroupId = $parentPomXml.CreateElement("groupId", $parentPomXml.DocumentElement.NamespaceURI)
$pluginGroupId.InnerText = "org.springframework.boot"
$pluginArtifactId = $parentPomXml.CreateElement("artifactId", $parentPomXml.DocumentElement.NamespaceURI)
$pluginArtifactId.InnerText = "spring-boot-maven-plugin"
$pluginVersion = $parentPomXml.CreateElement("version", $parentPomXml.DocumentElement.NamespaceURI)
$pluginVersion.InnerText = "3.1.4" # Use the same version as above

$plugin.AppendChild($pluginGroupId) | Out-Null
$plugin.AppendChild($pluginArtifactId) | Out-Null
$plugin.AppendChild($pluginVersion) | Out-Null

$pluginsNode = $pluginManagementNode.plugins
if (-not $pluginsNode) {
    $pluginsNode = $parentPomXml.CreateElement("plugins", $parentPomXml.DocumentElement.NamespaceURI)
    $pluginManagementNode.AppendChild($pluginsNode) | Out-Null
}

$pluginsNode.AppendChild($plugin) | Out-Null

# Save the updated parent POM
$parentPomXml.Save($parentPomPath)

# Step 2: Update Parent POM to include the new module
Write-Host "Updating parent POM to include $springBootModule..."
$modulesNode = $parentPomXml.project.modules

# Check if <modules> exists; create it if not
if (-not $modulesNode) {
    $modulesNode = $parentPomXml.CreateElement("modules", $parentPomXml.DocumentElement.NamespaceURI)
    $parentPomXml.project.AppendChild($modulesNode) | Out-Null
}

# Add the new module
$newModule = $parentPomXml.CreateElement("module", $parentPomXml.DocumentElement.NamespaceURI)
$newModule.InnerText = $springBootModule
$modulesNode.AppendChild($newModule) | Out-Null

# Save the updated parent POM
$parentPomXml.Save($parentPomPath)

# Step 3: Create the Spring Boot module directory and structure
Write-Host "Creating $springBootModule directory and structure..."
New-Item -ItemType Directory -Path "$springBootModulePath/src/main/java" -Force
New-Item -ItemType Directory -Path "$springBootModulePath/src/main/resources" -Force
New-Item -ItemType Directory -Path "$springBootModulePath/src/test/java" -Force
New-Item -ItemType Directory -Path "$springBootModulePath/src/test/resources" -Force

# Step 4: Create the Spring Boot module's POM file
Write-Host "Creating $springBootModule POM..."
$springBootPomPath = Join-Path $springBootModulePath "pom.xml"
Set-Content -Path $springBootPomPath -Value @"
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>com.example</groupId>
        <artifactId>rje2-parent</artifactId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <artifactId>$springBootModule</artifactId>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
"@

# Step 5: Create a basic Spring Boot application class
Write-Host "Creating Spring Boot application class..."
$appPackagePath = "$springBootModulePath/src/main/java/com/example/$springBootModule"
New-Item -ItemType Directory -Path $appPackagePath -Force

$appClassPath = Join-Path $appPackagePath "DemoApplication.java"
Set-Content -Path $appClassPath -Value @"
package com.example.$springBootModule;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DemoApplication {
    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }
}
"@

# Step 6: Create a simple REST controller
$controllerPath = Join-Path $appPackagePath "HelloController.java"
Set-Content -Path $controllerPath -Value @"
package com.example.$springBootModule.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    @GetMapping("/hello")
    public String sayHello() {
        return "Hello from $springBootModule!";
    }
}
"@

Write-Host "Spring Boot module '$springBootModule' created successfully!"