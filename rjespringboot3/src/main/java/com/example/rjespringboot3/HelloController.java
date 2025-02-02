package com.example.rjespringboot3.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    // Inject the 'app.greeting' property from application.yml
    @Value("${app.greeting}")
    private String greeting;

    @GetMapping("/hello")
    public String sayHello() {
        // Return the value of the 'greeting' variable
        return greeting;
    }
}
