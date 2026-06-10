package ma.ens.springbash.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.HashMap;
import java.util.Map;

@RestController
public class HomeController {

    @GetMapping("/")
    public Map<String, String> home() {
        Map<String, String> response = new HashMap<>();
        response.put("status", "OK");
        response.put("message", "Application Spring Boot - TP14");
        response.put("api", "/api/etudiants");
        response.put("h2-console", "/h2-console");
        return response;
    }
}