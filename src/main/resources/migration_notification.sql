-- ==============================================================================
-- Migration : Sous-module Gestion des notifications (Relation client)
-- Peut etre execute sur une base existante (utilise CREATE TABLE IF NOT EXISTS
-- et ajoute les colonnes manquantes via ALTER TABLE ... IF NOT EXISTS)
-- ==============================================================================

-- Cree les tables si elles n'existent pas encore (cas d'une base neuve)
CREATE TABLE IF NOT EXISTS "typeNotification" (
    "idTypeNotification" SERIAL PRIMARY KEY,
    "libelle" VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS "notificationPlateforme" (
    "idNotification" SERIAL PRIMARY KEY,
    "idTypeNotification" INT NOT NULL,
    "titre" VARCHAR(150) NOT NULL,
    "message" TEXT NOT NULL,
    "idProduitLie" INT,
    "idSessionLiee" INT,
    "dateHeureEnvoi" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY ("idTypeNotification") REFERENCES "typeNotification"("idTypeNotification"),
    FOREIGN KEY ("idProduitLie") REFERENCES "produit"("idProduit"),
    FOREIGN KEY ("idSessionLiee") REFERENCES "sessionTruck"("idSession")
);

-- Ajoute les colonnes necessaires au module (auteur de la notification + date de
-- derniere modification pour la fonctionnalite 6.3.5) si elles n'existent pas deja
ALTER TABLE "notificationPlateforme" ADD COLUMN IF NOT EXISTS "idAuteur" INT;
ALTER TABLE "notificationPlateforme" ADD COLUMN IF NOT EXISTS "dateModification" TIMESTAMP;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE constraint_name = 'notificationplateforme_idauteur_fkey'
    ) THEN
        ALTER TABLE "notificationPlateforme"
            ADD CONSTRAINT notificationplateforme_idauteur_fkey
            FOREIGN KEY ("idAuteur") REFERENCES "utilisateur"("idUtilisateur");
    END IF;
END $$;

-- Types de notification necessaires au module (n'insere que ceux qui manquent)
INSERT INTO "typeNotification" ("libelle")
SELECT v.libelle FROM (VALUES ('GENERALE'), ('BOOST_NOUVEAU_PRODUIT'), ('ARRIVEE_POINT_DE_VENTE')) AS v(libelle)
WHERE NOT EXISTS (
    SELECT 1 FROM "typeNotification" t WHERE t."libelle" = v.libelle
);
