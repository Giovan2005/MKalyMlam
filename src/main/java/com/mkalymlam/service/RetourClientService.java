package com.mkalymlam.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.mkalymlam.entity.ClassificationSentiment;
import com.mkalymlam.entity.ClassificationSentimentLookup;
import com.mkalymlam.entity.RetourClient;
import com.mkalymlam.entity.TypeRetour;
import com.mkalymlam.entity.TypeRetourLookup;
import com.mkalymlam.repository.ClassificationSentimentLookupRepository;
import com.mkalymlam.repository.RetourClientRepository;
import com.mkalymlam.repository.TypeRetourLookupRepository;

import jakarta.annotation.PostConstruct;

@Service
public class RetourClientService {

    private final RetourClientRepository repository;
    private final TypeRetourLookupRepository typeRetourRepository;
    private final ClassificationSentimentLookupRepository classificationSentimentRepository;

    public RetourClientService(RetourClientRepository repository,
                                TypeRetourLookupRepository typeRetourRepository,
                                ClassificationSentimentLookupRepository classificationSentimentRepository) {
        this.repository = repository;
        this.typeRetourRepository = typeRetourRepository;
        this.classificationSentimentRepository = classificationSentimentRepository;
    }

    @PostConstruct
    public void initLookupTables() {
        if (typeRetourRepository.count() == 0) {
            for (TypeRetour t : TypeRetour.values()) {
                typeRetourRepository.save(new TypeRetourLookup(t.name()));
            }
        }
        if (classificationSentimentRepository.count() == 0) {
            for (ClassificationSentiment c : ClassificationSentiment.values()) {
                classificationSentimentRepository.save(new ClassificationSentimentLookup(c.name()));
            }
        }
    }

    @Transactional
    public RetourClient save(RetourClient retour) {
        retour.setDateSoumission(LocalDateTime.now());

        if (retour.getTypeRetour() != null) {
            Long id = typeRetourRepository.findByLibelle(retour.getTypeRetour().name())
                    .stream().findFirst()
                    .orElseGet(() -> typeRetourRepository.save(new TypeRetourLookup(retour.getTypeRetour().name())))
                    .getId();
            retour.setIdTypeRetour(id);
        }

        classerSentiment(retour);

        if (retour.getClassificationSentiment() != null) {
            Long id = classificationSentimentRepository.findByLibelle(retour.getClassificationSentiment().name())
                    .stream().findFirst()
                    .orElseGet(() -> classificationSentimentRepository.save(new ClassificationSentimentLookup(retour.getClassificationSentiment().name())))
                    .getId();
            retour.setIdClassificationSentiment(id);
        }

        RetourClient saved = repository.save(retour);
        chargerEnums(saved);
        detecterPopulaire(saved);
        return saved;
    }

    private void classerSentiment(RetourClient retour) {
        Integer note = retour.getNoteSur10();
        ClassificationSentiment sentiment;
        if (note == null) {
            sentiment = ClassificationSentiment.NEUTRE;
        } else if (note >= 7) {
            sentiment = ClassificationSentiment.POSITIF;
        } else if (note >= 4) {
            sentiment = ClassificationSentiment.NEUTRE;
        } else {
            sentiment = ClassificationSentiment.NEGATIF;
        }
        retour.setClassificationSentiment(sentiment);
    }

    private void detecterPopulaire(RetourClient retour) {
        String texte = retour.getContenuTexte();
        if (texte == null || texte.isBlank()) return;

        List<RetourClient> similaires = repository.findByContenuTexteIgnoreCase(texte.trim());
        if (similaires.size() >= 2) {
            for (RetourClient r : similaires) {
                if (!Boolean.TRUE.equals(r.getEstPopulaire())) {
                    r.setEstPopulaire(true);
                    repository.save(r);
                }
            }
        }
    }

    public List<RetourClient> findAll() {
        return repository.findAll().stream()
                .peek(this::chargerEnums)
                .collect(Collectors.toList());
    }

    public List<RetourClient> findBySentiment(ClassificationSentiment sentiment) {
        List<Long> ids = classificationSentimentRepository.findByLibelle(sentiment.name())
                .stream().map(ClassificationSentimentLookup::getId)
                .collect(Collectors.toList());
        return repository.findAll().stream()
                .filter(r -> r.getIdClassificationSentiment() != null && ids.contains(r.getIdClassificationSentiment()))
                .peek(this::chargerEnums)
                .collect(Collectors.toList());
    }

    public List<RetourClient> findPopulaires() {
        return repository.findByEstPopulaireTrue().stream()
                .peek(this::chargerEnums)
                .collect(Collectors.toList());
    }

    public List<RetourClient> findAvis() {
        Long id = typeRetourRepository.findByLibelle(TypeRetour.REMARQUE_AVIS.name())
                .stream().findFirst().map(TypeRetourLookup::getId).orElse(null);
        if (id == null) return List.of();
        return repository.findByIdTypeRetour(id).stream()
                .peek(this::chargerEnums)
                .collect(Collectors.toList());
    }

    public List<RetourClient> findDemandes() {
        Long id = typeRetourRepository.findByLibelle(TypeRetour.DEMANDE_PRODUIT.name())
                .stream().findFirst().map(TypeRetourLookup::getId).orElse(null);
        if (id == null) return List.of();
        return repository.findByIdTypeRetour(id).stream()
                .peek(this::chargerEnums)
                .collect(Collectors.toList());
    }

    private void chargerEnums(RetourClient r) {
        if (r.getIdTypeRetour() != null) {
            typeRetourRepository.findById(r.getIdTypeRetour())
                    .ifPresent(l -> r.setTypeRetour(TypeRetour.valueOf(l.getLibelle())));
        }
        if (r.getIdClassificationSentiment() != null) {
            classificationSentimentRepository.findById(r.getIdClassificationSentiment())
                    .ifPresent(l -> r.setClassificationSentiment(ClassificationSentiment.valueOf(l.getLibelle())));
        }
    }
}
