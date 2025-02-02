# Define paths
$projectRoot = Get-Location
$parentPomPath = Join-Path $projectRoot "pom.xml"
$springBootModule = "rjespringboot4"
$springBootModulePath = Join-Path $projectRoot $springBootModule

# Step 1: Update Parent POM to include the new module
Write-Host "Updating parent POM to include $springBootModule..."
[xml]$parentPomXml = Get-Content $parentPomPath

# Add the new module
$newModule = $parentPomXml.CreateElement("module", $parentPomXml.DocumentElement.NamespaceURI)
$newModule.InnerText = $springBootModule
$parentPomXml.project.modules.AppendChild($newModule) | Out-Null

# Save the updated parent POM
$parentPomXml.Save($parentPomPath)

# Step 2: Create the Spring Boot module directory and structure
Write-Host "Creating $springBootModule directory and structure..."
New-Item -ItemType Directory -Path "$springBootModulePath/src/main/java" -Force
New-Item -ItemType Directory -Path "$springBootModulePath/src/main/resources" -Force
New-Item -ItemType Directory -Path "$springBootModulePath/src/test/java" -Force
New-Item -ItemType Directory -Path "$springBootModulePath/src/test/resources" -Force

# Step 3: Create the Spring Boot module's POM file
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

# Step 4: Create a basic Spring Boot application class
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

# Step 5: Create a simple REST controller
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