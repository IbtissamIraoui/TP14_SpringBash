package ma.ens.springbash.model;

import jakarta.persistence.*;
import lombok.*;

/**
 * Entité JPA représentant un étudiant.
 * Stockée dans la base H2 en mémoire.
 */
@Entity
@Table(name = "etudiants")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Etudiant {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String nom;

    @Column(nullable = false)
    private String prenom;

    @Column(unique = true, nullable = false)
    private String email;

    private String filiere;
}
