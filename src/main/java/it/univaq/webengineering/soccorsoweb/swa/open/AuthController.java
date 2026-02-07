package it.univaq.webengineering.soccorsoweb.swa.open;

import it.univaq.webengineering.soccorsoweb.model.dto.request.LoginRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.request.UserRequest;
import it.univaq.webengineering.soccorsoweb.model.dto.response.UserResponse;
import it.univaq.webengineering.soccorsoweb.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/swa/open/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;

    }

    @PostMapping("/login")
    public ResponseEntity<UserResponse> login(@Valid @RequestBody LoginRequest loginRequest) {
        return ResponseEntity.ok(authService.login(loginRequest));
    }

    @PostMapping("/logout")
    public ResponseEntity<String> logout() {
        return ResponseEntity.ok(authService.logout());
    }

    @PostMapping("/sign-up")
    public ResponseEntity<UserResponse> signUp(@Valid @RequestBody UserRequest userRequest) {
        return ResponseEntity.ok(authService.signUp(userRequest));
    }
}
