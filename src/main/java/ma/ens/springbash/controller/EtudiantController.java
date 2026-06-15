package ma.ens.springbash.controller;

import lombok.RequiredArgsConstructor;
import ma.ens.springbash.model.Etudiant;
import ma.ens.springbash.service.EtudiantService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/api/etudiants")
@RequiredArgsConstructor
public class EtudiantController {

    private final EtudiantService service;

    /** GET /api/etudiants → liste tous les étudiants */
    @GetMapping
    public List<Etudiant> getAll() {
        return service.findAll();
    }

    /** GET /api/etudiants/{id} → un étudiant par id */
    @GetMapping("/{id}")
    public ResponseEntity<Etudiant> getById(@PathVariable Long id) {
        return service.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /** GET /api/etudiants/filiere/{filiere} → filtre par filière */
    @GetMapping("/filiere/{filiere}")
    public List<Etudiant> getByFiliere(@PathVariable String filiere) {
        return service.findByFiliere(filiere);
    }

    /** POST /api/etudiants → créer un étudiant */
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Etudiant create(@RequestBody Etudiant etudiant) {
        return service.save(etudiant);
    }

    /** PUT /api/etudiants/{id} → mettre à jour */
    @PutMapping("/{id}")
    public ResponseEntity<Etudiant> update(@PathVariable Long id,
                                           @RequestBody Etudiant etudiant) {
        return service.findById(id).map(existing -> {
            etudiant.setId(id);
            return ResponseEntity.ok(service.save(etudiant));
        }).orElse(ResponseEntity.notFound().build());
    }

    /** DELETE /api/etudiants/{id} → supprimer */
    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable Long id) {
        service.deleteById(id);
    }
}
