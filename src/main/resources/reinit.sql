-- Supprimer la table si elle existe
DROP TABLE IF EXISTS ingredient CASCADE;

-- Créer la table avec les colonnes camelCase
CREATE TABLE ingredient (
    idIngredient SERIAL PRIMARY KEY,
    nomIngredient VARCHAR(100) NOT NULL,
    seuilAlerteQuantite NUMERIC(10, 2) NOT NULL,
    uniteMesure VARCHAR(20) NOT NULL
);

-- Insérer des données de test
INSERT INTO ingredient (nomIngredient, seuilAlerteQuantite, uniteMesure) VALUES
('Farine de blé', 5.0, 'kg'),
('Sucre cristallisé', 3.0, 'kg'),
('Sel fin', 1.0, 'kg'),
('Beurre doux', 2.5, 'kg'),
('Œufs frais', 12.0, 'unité');



ALTER TABLE "ligneCommande"
ALTER COLUMN "prixUnitaireFacture" DROP NOT NULL;
