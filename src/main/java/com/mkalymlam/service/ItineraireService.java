package com.mkalymlam.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.mkalymlam.entity.Itineraire;
import com.mkalymlam.repository.ItineraireRepository;
import jakarta.persistence.criteria.Predicate;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;
@Service
public class ItineraireService {
    
    private final ItineraireRepository itineraireRepository;

    public ItineraireService(ItineraireRepository itineraireRepository) {
        this.itineraireRepository = itineraireRepository;
    }

    @Transactional
    public Itineraire save(Itineraire itineraire) {
        return itineraireRepository.save(itineraire);
    }

    public List<Itineraire> findAll() {
        return itineraireRepository.findAll();
    }

    public List<Itineraire> search(String nomZone, String jourSemaine, String lieuExact) {
        return itineraireRepository.findAll((root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (nomZone != null && !nomZone.isBlank()) {
                predicates.add(cb.like(cb.lower(root.get("nomZone")),
                                       "%" + nomZone.toLowerCase() + "%"));
            }
            if (jourSemaine != null && !jourSemaine.isBlank()) {
                predicates.add(cb.equal(root.get("jourSemaine"), jourSemaine));
            }
            if (lieuExact != null && !lieuExact.isBlank()) {
                predicates.add(cb.like(cb.lower(root.get("lieuExact")),
                                       "%" + lieuExact.toLowerCase() + "%"));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        });
    }

    public Itineraire find(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Id null");
        }
        if (!itineraireRepository.existsById(id)) {
            throw new IllegalArgumentException("Itineraire" + id + " does not exist");
        }
        return itineraireRepository.findById(id).orElse(null);
    }

    @Transactional
    public Itineraire update(Itineraire itineraire) {
        if (itineraire == null || itineraire.getId() == null) {
            throw new IllegalArgumentException(
                "Pas de itineraire");
        }
        if (!itineraireRepository.existsById(itineraire.getId())) {
            throw new IllegalArgumentException(
                "pas de l'" + itineraire.getId() + " dans la base ");
        }
        return itineraireRepository.save(itineraire);
    }

    public void delete(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Id null");
        }
        if (!itineraireRepository.existsById(id)) {
            throw new IllegalArgumentException("Itineraire" + id + " does not exist");
        }
        itineraireRepository.deleteById(id);
    }

    @Transactional
    public List<String> importItinerairesFromRows(List<String[]> data, String[] headers) {
        List<String> erreurs = new ArrayList<>();

        int idxNomZone = findColumnIndex(headers, "nomZone");
        int idxLieuExact = findColumnIndex(headers, "lieuExact");
        int idxHeureDebut = findColumnIndex(headers, "heureDebutPrevue");
        int idxHeureFin = findColumnIndex(headers, "heureFinPrevue");
        int idxJourSemaine = findColumnIndex(headers, "jourSemaine");

        for (int i = 0; i < data.size(); i++) {
            String[] row = data.get(i);
            try {
                String nomZone = getCellValue(row, idxNomZone);
                String lieuExact = getCellValue(row, idxLieuExact);
                String heureDebutStr = getCellValue(row, idxHeureDebut);
                String heureFinStr = getCellValue(row, idxHeureFin);
                String jourSemaine = getCellValue(row, idxJourSemaine);

                if (nomZone.isEmpty() && lieuExact.isEmpty()) {
                    erreurs.add("Ligne " + (i + 2) + " : nomZone ou lieuExact requis");
                    continue;
                }

                Itineraire itineraire = new Itineraire();
                itineraire.setNomZone(nomZone);
                itineraire.setLieuExact(lieuExact);
                itineraire.setJourSemaine(jourSemaine);

                if (!heureDebutStr.isEmpty()) {
                    itineraire.setHeureDebutPrevue(parseTime(heureDebutStr));
                }
                if (!heureFinStr.isEmpty()) {
                    itineraire.setHeureFinPrevue(parseTime(heureFinStr));
                }

                itineraireRepository.save(itineraire);

            } catch (Exception e) {
                erreurs.add("Ligne " + (i + 2) + " : " + e.getMessage());
            }
        }
        return erreurs;
    }

    private int findColumnIndex(String[] headers, String columnName) {
        for (int i = 0; i < headers.length; i++) {
            if (headers[i].trim().equalsIgnoreCase(columnName)) {
                return i;
            }
        }
        return -1;
    }

    private String getCellValue(String[] row, int index) {
        if (index < 0 || index >= row.length) return "";
        return row[index] != null ? row[index].trim() : "";
    }

    private Time parseTime(String timeStr) {
        String[] parts = timeStr.split(":");
        int h = Integer.parseInt(parts[0]);
        int m = parts.length > 1 ? Integer.parseInt(parts[1]) : 0;
        int s = parts.length > 2 ? Integer.parseInt(parts[2]) : 0;
        return Time.valueOf(String.format("%02d:%02d:%02d", h, m, s));
    }

    
}


