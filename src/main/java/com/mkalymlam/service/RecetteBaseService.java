package com.mkalymlam.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import com.mkalymlam.entity.RecetteBase;
import com.mkalymlam.entity.RecetteBaseId;
import com.mkalymlam.repository.RecetteBaseRepository;

@Service
public class RecetteBaseService {

    private final RecetteBaseRepository repo;

    public RecetteBaseService(RecetteBaseRepository repo) {
        this.repo = repo;
    }

    public List<RecetteBase> findAll() {
        return repo.findAll();
    }

    public RecetteBase save(RecetteBase r) {
        return repo.save(r);
    }

    public RecetteBase findById(Long idProduit, Long idIngredient) {

        RecetteBaseId id = new RecetteBaseId(idProduit, idIngredient);

        return repo.findById(id)
                .orElseThrow(() ->
                        new RuntimeException("Recette introuvable."));
    }

    public void delete(Long idProduit, Long idIngredient) {
        repo.deleteById(new RecetteBaseId(idProduit, idIngredient));
    }

    public RecetteBase update(Long idProduit,Long idIngredient,RecetteBase recette) {

        RecetteBase ancienne = findById(idProduit, idIngredient);

        ancienne.setQuantiteRecette(recette.getQuantiteRecette());

        return repo.save(ancienne);
    }

    public List<String> importRecettesFromRows(List<String[]> data, String[] headers) {
        List<String> erreurs = new ArrayList<>();

        int idxIdProduit = findColumnIndex(headers, "idProduit");
        int idxIdIngredient = findColumnIndex(headers, "idIngredient");
        int idxQuantite = findColumnIndex(headers, "quantiteRecette");

        for (int i = 0; i < data.size(); i++) {
            String[] row = data.get(i);
            try {
                String idProduitStr = getCellValue(row, idxIdProduit);
                String idIngredientStr = getCellValue(row, idxIdIngredient);
                String quantiteStr = getCellValue(row, idxQuantite);

                if (idProduitStr.isEmpty()) {
                    erreurs.add("Ligne " + (i + 2) + " : idProduit manquant");
                    continue;
                }
                if (idIngredientStr.isEmpty()) {
                    erreurs.add("Ligne " + (i + 2) + " : idIngredient manquant");
                    continue;
                }
                if (quantiteStr.isEmpty()) {
                    erreurs.add("Ligne " + (i + 2) + " : quantiteRecette manquante");
                    continue;
                }

                RecetteBase recette = new RecetteBase();
                recette.setIdProduit(Long.parseLong(idProduitStr));
                recette.setIdIngredient(Long.parseLong(idIngredientStr));
                recette.setQuantiteRecette(Double.parseDouble(quantiteStr.replace(",", ".")));

                repo.save(recette);

            } catch (NumberFormatException e) {
                erreurs.add("Ligne " + (i + 2) + " : format numerique invalide");
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
}