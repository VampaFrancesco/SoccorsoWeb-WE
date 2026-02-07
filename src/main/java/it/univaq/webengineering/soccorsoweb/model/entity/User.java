package it.univaq.webengineering.soccorsoweb.model.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "user", indexes = {
        @Index(name = "idx_email", columnList = "email"),
        @Index(name = "idx_attivo", columnList = "attivo")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false, length = 100)
    private String nome;

    @Column(nullable = false, length = 100)
    private String cognome;

    @Column(name = "data_nascita")
    private LocalDate dataNascita;

    @Column(length = 20)
    private String telefono;

    private String indirizzo;

    @Builder.Default
    @Column(nullable = false)
    private Boolean attivo = true;

    @Builder.Default
    @Column(name = "first_attempt", nullable = false)
    private Boolean firstAttempt = true;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Relazione Many-to-Many con Role tramite tabella user_role
    @Builder.Default
    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "user_role", joinColumns = @JoinColumn(name = "user_id"), inverseJoinColumns = @JoinColumn(name = "role_id"))
    private Set<Role> roles = new HashSet<>();

    // Relazione con Patenti
    @Builder.Default
    @OneToMany(mappedBy = "utente", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<UtentePatente> patenti = new HashSet<>();

    // Relazione con Abilita
    @Builder.Default
    @OneToMany(mappedBy = "utente", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<UtenteAbilita> abilita = new HashSet<>();

    // Relazione con Missioni come operatore
    @Builder.Default
    @OneToMany(mappedBy = "operatore", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<MissioneOperatore> missioniComeOperatore = new HashSet<>();
}
