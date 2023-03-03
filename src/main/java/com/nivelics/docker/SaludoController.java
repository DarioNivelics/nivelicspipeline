package com.nivelics.docker;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SaludoController {

    @GetMapping("/saludo")
    public String saludar() {
        return "<h1>Hello World</h1>";
    }
    @GetMapping("/")
    public String ShowIndex() {
        return "<h1>Index  Jose Luis </h1>";
    }

    @PostMapping("/datos")
    public Persona presentar() {

        Persona p = new Persona();
        p.setNombre("Dario");
        p.setApellido("Lopez");
        return p;
    }
}
