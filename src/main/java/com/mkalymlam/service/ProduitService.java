package com.mkalymlam.service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import com.mkalymlam.entity.Produit;
import com.mkalymlam.repository.ProduitRepository;

@Service
public class ProduitService {

    private final ProduitRepository repository;

    public ProduitService(ProduitRepository repository) {
        this.repository = repository;
    }

    public List<Produit> findAll() {
        return repository.findAll();
    }

    public Produit getById(Long id) {
        return repository.findById(id).orElse(null);
    }

    public Produit save(Produit produit) {
        return repository.save(produit);
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    public List<String> importProduitsFromRows(List<String[]> data, String[] headers) {
        List<String> erreurs = new ArrayList<>();

        int idxNomProduit = findColumnIndex(headers, "nomProduit");
        int idxPrixBase = findColumnIndex(headers, "prixBase");
        int idxEstNouveau = findColumnIndex(headers, "estNouveau");
        int idxDateCreation = findColumnIndex(headers, "dateCreation");

        for (int i = 0; i < data.size(); i++) {
            String[] row = data.get(i);
            try {
                String nomProduit = getCellValue(row, idxNomProduit);
                String prixBaseStr = getCellValue(row, idxPrixBase);
                String estNouveauStr = getCellValue(row, idxEstNouveau);
                String dateCreationStr = getCellValue(row, idxDateCreation);

                if (nomProduit.isEmpty()) {
                    erreurs.add("Ligne " + (i + 2) + " : nomProduit manquant");
                    continue;
                }
                if (prixBaseStr.isEmpty()) {
                    erreurs.add("Ligne " + (i + 2) + " : prixBase manquant");
                    continue;
                }

                Produit produit = new Produit();
                produit.setNomProduit(nomProduit);
                produit.setPrixBase(Double.parseDouble(prixBaseStr.replace(",", ".")));
                produit.setEstNouveau(!estNouveauStr.isEmpty()
                        ? Boolean.parseBoolean(estNouveauStr) : false);
                produit.setDateCreation(!dateCreationStr.isEmpty()
                        ? LocalDate.parse(dateCreationStr) : LocalDate.now());

                repository.save(produit);

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