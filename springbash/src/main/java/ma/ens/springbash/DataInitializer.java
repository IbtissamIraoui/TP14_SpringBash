package ma.ens.springbash;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import ma.ens.springbash.model.Etudiant;
import ma.ens.springbash.repository.EtudiantRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

/**
 * Initialise la base H2 avec des données de test au démarrage.
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class DataInitializer implements CommandLineRunner {

    private final EtudiantRepository repository;

    @Override
    public void run(String... args) {
        log.info("=== Initialisation des données de test ===");

        repository.save(Etudiant.builder()
                .nom("Alami").prenom("Youssef")
                .email("y.alami@ens.ma").filiere("Informatique").build());

        repository.save(Etudiant.builder()
                .nom("Benali").prenom("Sara")
                .email("s.benali@ens.ma").filiere("Mathematiques").build());

        repository.save(Etudiant.builder()
                .nom("Cherkaoui").prenom("Amine")
                .email("a.cherkaoui@ens.ma").filiere("Informatique").build());

        repository.save(Etudiant.builder()
                .nom("Douiri").prenom("Fatima")
                .email("f.douiri@ens.ma").filiere("Physique").build());

        log.info("=== {} étudiants insérés ===", repository.count());
    }
}
