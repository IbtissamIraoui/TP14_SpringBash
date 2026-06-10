package ma.ens.springbash.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import ma.ens.springbash.model.Etudiant;
import ma.ens.springbash.repository.EtudiantRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class EtudiantService {

    private final EtudiantRepository repository;

    public List<Etudiant> findAll() {
        log.info("Récupération de tous les étudiants");
        return repository.findAll();
    }

    public Optional<Etudiant> findById(Long id) {
        return repository.findById(id);
    }

    public Etudiant save(Etudiant etudiant) {
        log.info("Sauvegarde étudiant : {}", etudiant.getEmail());
        return repository.save(etudiant);
    }

    public void deleteById(Long id) {
        log.info("Suppression étudiant id={}", id);
        repository.deleteById(id);
    }

    public List<Etudiant> findByFiliere(String filiere) {
        return repository.findByFiliere(filiere);
    }
}
