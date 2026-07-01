drop database "foodTruckDb";

CREATE DATABASE "foodTruckDb";
\c "foodTruckDb";


-- Module 1
CREATE TABLE "role" (
    "idRole" SERIAL PRIMARY KEY,
    "libelle" VARCHAR(50) NOT NULL
);

CREATE TABLE "typeConge" (
    "idTypeConge" SERIAL PRIMARY KEY,
    "libelle" VARCHAR(50) NOT NULL
);

CREATE TABLE "statutValidation" (
    "idStatutValidation" SERIAL PRIMARY KEY,
    "libelle" VARCHAR(50) NOT NULL
);

-- Module 2
CREATE TABLE "statutDisponibilite" (
    "idStatutDisponibilite" SERIAL PRIMARY KEY,
    "libelle" VARCHAR(50) NOT NULL
);

CREATE TABLE "statutSession" (
    "idStatutSession" SERIAL PRIMARY KEY,
    "libelle" VARCHAR(50) NOT NULL
);

-- Module 3
CREATE TABLE "typeEquipement" (
    "idTypeEquipement" SERIAL PRIMARY KEY,
    "libelle" VARCHAR(50) NOT NULL
);

CREATE TABLE "statutAlerte" (
    "idStatutAlerte" SERIAL PRIMARY KEY,
    "libelle" VARCHAR(50) NOT NULL
);

CREATE TABLE "methodeComptable" (
    "idMethodeComptable" SERIAL PRIMARY KEY,
    "libelle" VARCHAR(50) NOT NULL
);

CREATE TABLE "typeItem" (
    "idTypeItem" SERIAL PRIMARY KEY,
    "libelle" VARCHAR(50) NOT NULL
);

-- Module 4
CREATE TABLE "typeCommande" (
    "idTypeCommande" SERIAL PRIMARY KEY,
    "libelle" VARCHAR(50) NOT NULL
);

CREATE TABLE "statutCommande" (
    "idStatutCommande" SERIAL PRIMARY KEY,
    "libelle" VARCHAR(50) NOT NULL
);

CREATE TABLE "typeTarification" (
    "idTypeTarification" SERIAL PRIMARY KEY,
    "libelle" VARCHAR(50) NOT NULL
);

CREATE TABLE "actionCommande" (
    "idActionCommande" SERIAL PRIMARY KEY,
    "libelle" VARCHAR(50) NOT NULL
);

CREATE TABLE "modePaiement" (
    "idModePaiement" SERIAL PRIMARY KEY,
    "libelle" VARCHAR(50) NOT NULL
);

-- Module 5
CREATE TABLE "typeDepense" (
    "idTypeDepense" SERIAL PRIMARY KEY,
    "libelle" VARCHAR(50) NOT NULL
);

CREATE TABLE "statutValidationAdmin" (
    "idStatutValidationAdmin" SERIAL PRIMARY KEY,
    "libelle" VARCHAR(50) NOT NULL
);

-- Module 6
CREATE TABLE "typeRetour" (
    "idTypeRetour" SERIAL PRIMARY KEY,
    "libelle" VARCHAR(50) NOT NULL
);

CREATE TABLE "classificationSentiment" (
    "idClassificationSentiment" SERIAL PRIMARY KEY,
    "libelle" VARCHAR(50) NOT NULL
);

CREATE TABLE "statutDemandeAchat" (
    "idStatutDemandeAchat" SERIAL PRIMARY KEY,
    "libelle" VARCHAR(50) NOT NULL
);

CREATE TABLE "typeNotification" (
    "idTypeNotification" SERIAL PRIMARY KEY,
    "libelle" VARCHAR(50) NOT NULL
);

-- CREATE TABLE "zone" (
--     "idZone" SERIAL PRIMARY KEY,
--     "libelle" VARCHAR(50) NOT NULL
-- );


-- ==============================================================================
-- MODULE 1 : Utilisateurs, Ressources Humaines & Paie
-- ==============================================================================

CREATE TABLE "utilisateur" (
    "idUtilisateur" SERIAL PRIMARY KEY,
    "nom" VARCHAR(100) NOT NULL,
    "prenom" VARCHAR(100),
    "email" VARCHAR(150) UNIQUE NOT NULL,
    "motDePasse" VARCHAR(255) NOT NULL,
    "idRole" INT NOT NULL,
    "salaireBaseFixe" NUMERIC(12, 2),
    "statutActif" BOOLEAN DEFAULT TRUE,
    FOREIGN KEY ("idRole") REFERENCES "role"("idRole")
);

CREATE TABLE "absenceConge" (
    "idAbsence" SERIAL PRIMARY KEY,
    "idUtilisateur" INT NOT NULL,
    "idTypeConge" INT NOT NULL,
    "dateDebut" DATE NOT NULL,
    "dateFin" DATE NOT NULL,
    "idStatutValidation" INT NOT NULL,
    "deductionSalaireAppliquee" NUMERIC(10, 2) DEFAULT 0,
    "idRemplacant" INT,
    FOREIGN KEY ("idUtilisateur") REFERENCES "utilisateur"("idUtilisateur"),
    FOREIGN KEY ("idTypeConge") REFERENCES "typeConge"("idTypeConge"),
    FOREIGN KEY ("idStatutValidation") REFERENCES "statutValidation"("idStatutValidation"),
    FOREIGN KEY ("idRemplacant") REFERENCES "utilisateur"("idUtilisateur")
);

CREATE TABLE "fichePaie" (
    "idFiche" SERIAL PRIMARY KEY,
    "idUtilisateur" INT NOT NULL,
    "moisAnnee" VARCHAR(7) NOT NULL,
    "montantFixeBrut" NUMERIC(12, 2) NOT NULL,
    "totalCommissions" NUMERIC(10, 2) DEFAULT 0,
    "totalHeuresSupp" NUMERIC(10, 2) DEFAULT 0,
    "totalDeductionsAbsences" NUMERIC(10, 2) DEFAULT 0,
    "montantNetVerse" NUMERIC(12, 2) NOT NULL,
    "datePaiement" DATE,
    FOREIGN KEY ("idUtilisateur") REFERENCES "utilisateur"("idUtilisateur")
);

CREATE TABLE "historiqueSalaire" (
    "idHistorique" SERIAL PRIMARY KEY,
    "idUtilisateur" INT NOT NULL,
    "salaireBase" NUMERIC(12, 2) NOT NULL,
    "dateDebut" DATE NOT NULL,
    "dateFin" DATE,
    FOREIGN KEY ("idUtilisateur") REFERENCES "utilisateur"("idUtilisateur")
);


-- ==============================================================================
-- MODULE 2 : Planification, Sessions de Terrain & Véhicule
-- ==============================================================================

CREATE TABLE "truck" (
    "idTruck" SERIAL PRIMARY KEY,
    "immatriculation" VARCHAR(20) NOT NULL UNIQUE,
    "idStatutDisponibilite" INT NOT NULL,
    FOREIGN KEY ("idStatutDisponibilite") REFERENCES "statutDisponibilite"("idStatutDisponibilite")
);

CREATE TABLE "historiqueMaintenance" (
    "idHistoriqueMaintenance" SERIAL PRIMARY KEY,
    "idTruck" INT NOT NULL,
    "dateDebut" DATE NOT NULL,
    "dateFin" DATE,
    "description" TEXT,
    FOREIGN KEY ("idTruck") REFERENCES "truck"("idTruck")
);

CREATE TABLE "historiqueStatus" (
    "idHistoriqueStatus" SERIAL PRIMARY KEY,
    "idTruck" INT NOT NULL,
    "idStatutDisponibilite" INT NOT NULL,
    "dateChangement" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY ("idTruck") REFERENCES "truck"("idTruck"),
    FOREIGN KEY ("idStatutDisponibilite") REFERENCES "statutDisponibilite"("idStatutDisponibilite")
);

CREATE TABLE "itineraire" (
    "idItineraire" SERIAL PRIMARY KEY,
    "nomZone" VARCHAR(100) NOT NULL,
    "lieuExact" TEXT NOT NULL,
    "heureDebutPrevue" TIME NOT NULL,
    "heureFinPrevue" TIME NOT NULL,
    "jourSemaine" VARCHAR(20) NOT NULL
);

-- CREATE TABLE "itineraire" (
--     "idItineraire" SERIAL PRIMARY KEY,
--     "idZone" INT,
--     "lieuExact" TEXT NOT NULL,
--     "heureDebutPrevue" TIME NOT NULL,
--     "heureFinPrevue" TIME NOT NULL,
--     "jourSemaine" VARCHAR(20) NOT NULL
--     -- FOREIGN KEY ("idZone") REFERENCES "zone"("idZone"),

-- );

CREATE TABLE "sessionTruck" (
    "idSession" SERIAL PRIMARY KEY,
    "idTruck" INT NOT NULL,
    "idItineraire" INT NOT NULL,
    "dateSession" DATE NOT NULL,
    "fondDeCaisseOuverture" NUMERIC(10, 2),
    "fondDeCaisseCloture" NUMERIC(10, 2),
    "chiffreAffaireTotal" NUMERIC(12, 2) DEFAULT 0,
    "commissionTotaleEquipe" NUMERIC(10, 2) DEFAULT 0,
    "idStatutSession" INT NOT NULL,
    FOREIGN KEY ("idTruck") REFERENCES "truck"("idTruck"),
    FOREIGN KEY ("idItineraire") REFERENCES "itineraire"("idItineraire"),
    FOREIGN KEY ("idStatutSession") REFERENCES "statutSession"("idStatutSession")
);

CREATE TABLE "equipeSession" (
    "idSession" INT NOT NULL,
    "idUtilisateur" INT NOT NULL,
    "idRoleDuJour" INT NOT NULL,
    "salaireJournalierRemplacant" NUMERIC(10, 2),
    PRIMARY KEY ("idSession", "idUtilisateur"),
    FOREIGN KEY ("idSession") REFERENCES "sessionTruck"("idSession"),
    FOREIGN KEY ("idUtilisateur") REFERENCES "utilisateur"("idUtilisateur"),
    FOREIGN KEY ("idRoleDuJour") REFERENCES "role"("idRole")
);

CREATE TABLE "demandeChangementItineraire" (
    "idDemande" SERIAL PRIMARY KEY,
    "idSession" INT NOT NULL,
    "idDemandeur" INT NOT NULL,
    "raison" TEXT NOT NULL,
    "idItinerairePropose" INT,
    "autreLieuPrecise" TEXT,
    "dateHeureDemande" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "idStatutValidation" INT NOT NULL,
    FOREIGN KEY ("idSession") REFERENCES "sessionTruck"("idSession"),
    FOREIGN KEY ("idDemandeur") REFERENCES "utilisateur"("idUtilisateur"),
    FOREIGN KEY ("idItinerairePropose") REFERENCES "itineraire"("idItineraire"),
    FOREIGN KEY ("idStatutValidation") REFERENCES "statutValidation"("idStatutValidation")
);


-- ==============================================================================
-- MODULE 3 : Stocks, Lots & Inventaires
-- ==============================================================================

CREATE TABLE "ingredient" (
    "idIngredient" SERIAL PRIMARY KEY,
    "nomIngredient" VARCHAR(100) NOT NULL,
    "seuilAlerteQuantite" NUMERIC(10, 2) NOT NULL,
    "uniteMesure" VARCHAR(20) NOT NULL
);

CREATE TABLE "lotIngredient" (
    "idLot" SERIAL PRIMARY KEY,
    "idIngredient" INT NOT NULL,
    "dateReception" DATE NOT NULL,
    "datePeremption" DATE NOT NULL,
    "quantiteInitiale" NUMERIC(10, 2) NOT NULL,
    "quantiteRestante" NUMERIC(10, 2) NOT NULL,
    "prixAchatUnitaire" NUMERIC(10, 2) NOT NULL,
    FOREIGN KEY ("idIngredient") REFERENCES "ingredient"("idIngredient")
);

CREATE TABLE "equipement" (
    "idEquipement" SERIAL PRIMARY KEY,
    "nomEquipement" VARCHAR(100) NOT NULL,
    "idTypeEquipement" INT NOT NULL,
    "idMethodeComptable" INT NOT NULL,
    "quantiteStock" INT NOT NULL,
    "valeurCump" NUMERIC(10, 2),
    "tauxFahasimbana" NUMERIC(5, 2),
    "idStatutAlerte" INT NOT NULL,
    FOREIGN KEY ("idTypeEquipement") REFERENCES "typeEquipement"("idTypeEquipement"),
    FOREIGN KEY ("idMethodeComptable") REFERENCES "methodeComptable"("idMethodeComptable"),
    FOREIGN KEY ("idStatutAlerte") REFERENCES "statutAlerte"("idStatutAlerte")
);

CREATE TABLE "inventaireJournalier" (
    "idInventaire" SERIAL PRIMARY KEY,
    "idSession" INT NOT NULL,
    "dateInventaire" DATE NOT NULL,
    "idTypeItem" INT NOT NULL,
    "idItem" INT NOT NULL, -- ID polymorphique (Ingredient ou Equipement)
    "quantitePhysiqueConstatee" NUMERIC(10, 2) NOT NULL,
    "quantiteTheoriqueSysteme" NUMERIC(10, 2) NOT NULL,
    "ecartInventaire" NUMERIC(10, 2) NOT NULL,
    FOREIGN KEY ("idSession") REFERENCES "sessionTruck"("idSession"),
    FOREIGN KEY ("idTypeItem") REFERENCES "typeItem"("idTypeItem")
);


-- ==============================================================================
-- MODULE 4 : Menu, Commandes Personnalisées & Factures
-- ==============================================================================

CREATE TABLE "produit" (
    "idProduit" SERIAL PRIMARY KEY,
    "nomProduit" VARCHAR(100) NOT NULL,
    "prixBase" NUMERIC(10, 2) NOT NULL,
    "estNouveau" BOOLEAN DEFAULT FALSE,
    "dateCreation" DATE DEFAULT CURRENT_DATE
);

CREATE TABLE "recetteDeBase" (

    "idProduit" INT NOT NULL,
    "idIngredient" INT NOT NULL,
    "quantiteRecette" NUMERIC(10, 2) NOT NULL,
    PRIMARY KEY ("idProduit", "idIngredient"),
    FOREIGN KEY ("idProduit") REFERENCES "produit"("idProduit"),
    FOREIGN KEY ("idIngredient") REFERENCES "ingredient"("idIngredient")
);

-- CREATE TABLE "commande" (
--     "idCommande" SERIAL PRIMARY KEY,
--     "idSession" INT NOT NULL,
--     "idVendeuse" INT,
--     "idTypeCommande" INT NOT NULL,
--     "dateHeureCreation" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--     "heureRecuperationPrevue" TIME,
--     "lieuRecuperationPrevu" VARCHAR(150),
--     "montantTotal" NUMERIC(12, 2) NOT NULL,
--     "idStatutCommande" INT NOT NULL,
--     "idTypeTarification" INT NOT NULL,
--     FOREIGN KEY ("idSession") REFERENCES "sessionTruck"("idSession"),
--     FOREIGN KEY ("idVendeuse") REFERENCES "utilisateur"("idUtilisateur"),
--     FOREIGN KEY ("idTypeCommande") REFERENCES "typeCommande"("idTypeCommande"),
--     FOREIGN KEY ("idStatutCommande") REFERENCES "statutCommande"("idStatutCommande"),
--     FOREIGN KEY ("idTypeTarification") REFERENCES "typeTarification"("idTypeTarification")
-- );

CREATE TABLE "commande" (
    "idCommande" SERIAL PRIMARY KEY,
    "idSession" INT,
    "idVendeuse" INT,
    "idTypeCommande" INT,
    "dateHeureCreation" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "heureRecuperationPrevue" TIME,
    "lieuRecuperationPrevu" VARCHAR(150),
    "montantTotal" NUMERIC(12, 2),
    "idStatutCommande" INT,
    "idTypeTarification" INT,
    FOREIGN KEY ("idSession") REFERENCES "sessionTruck"("idSession"),
    FOREIGN KEY ("idVendeuse") REFERENCES "utilisateur"("idUtilisateur"),
    FOREIGN KEY ("idTypeCommande") REFERENCES "typeCommande"("idTypeCommande"),
    FOREIGN KEY ("idStatutCommande") REFERENCES "statutCommande"("idStatutCommande"),
    FOREIGN KEY ("idTypeTarification") REFERENCES "typeTarification"("idTypeTarification")
);

CREATE TABLE "ligneCommande" (
    "idLigne" SERIAL PRIMARY KEY,
    "idCommande" INT NOT NULL,
    "idProduit" INT NOT NULL,
    "quantite" INT NOT NULL,
    "prixUnitaireFacture" NUMERIC(10, 2) NOT NULL,
    FOREIGN KEY ("idCommande") REFERENCES "commande"("idCommande"),
    FOREIGN KEY ("idProduit") REFERENCES "produit"("idProduit")
);

-- ALTER TABLE "ligneCommande"
-- ALTER COLUMN "prixUnitaireFacture" DROP NOT NULL;

CREATE TABLE "personnalisationCommande" (
    "idPersonnalisation" SERIAL PRIMARY KEY,
    "idLigne" INT NOT NULL,
    "idIngredient" INT NOT NULL,
    "idActionCommande" INT NOT NULL,
    "quantiteAjustee" NUMERIC(10, 2),
    FOREIGN KEY ("idLigne") REFERENCES "ligneCommande"("idLigne"),
    FOREIGN KEY ("idIngredient") REFERENCES "ingredient"("idIngredient"),
    FOREIGN KEY ("idActionCommande") REFERENCES "actionCommande"("idActionCommande")
);

CREATE TABLE "factureRecu" (
    "idFacture" SERIAL PRIMARY KEY,
    "idCommande" INT NOT NULL,
    "referenceFacture" VARCHAR(50) UNIQUE NOT NULL,
    "dateFacturation" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "idModePaiement" INT NOT NULL,
    "detailsTaxesBrut" NUMERIC(10, 2),
    FOREIGN KEY ("idCommande") REFERENCES "commande"("idCommande"),
    FOREIGN KEY ("idModePaiement") REFERENCES "modePaiement"("idModePaiement")
);


-- ==============================================================================
-- MODULE 5 : Dépenses & Imprévus
-- ==============================================================================

CREATE TABLE "depense" (
    "idDepense" SERIAL PRIMARY KEY,
    "idSession" INT,
    "idTypeDepense" INT NOT NULL,
    "montantDepense" NUMERIC(10, 2) NOT NULL,
    "raisonDetaillee" TEXT NOT NULL,
    "dateDepense" DATE NOT NULL,
    "idStatutValidationAdmin" INT NOT NULL,
    "commentaireAdminRetour" TEXT,
    FOREIGN KEY ("idSession") REFERENCES "sessionTruck"("idSession"),
    FOREIGN KEY ("idTypeDepense") REFERENCES "typeDepense"("idTypeDepense"),
    FOREIGN KEY ("idStatutValidationAdmin") REFERENCES "statutValidationAdmin"("idStatutValidationAdmin")
);


-- ==============================================================================
-- MODULE 6 : Satisfaction Client, Avis & Boost
-- ==============================================================================

CREATE TABLE "retourClient" (
    "idRetour" SERIAL PRIMARY KEY,
    "idTypeRetour" INT NOT NULL,
    "noteSur10" INT CHECK ("noteSur10" >= 0 AND "noteSur10" <= 10),
    "contenuTexte" TEXT NOT NULL,
    "idClassificationSentiment" INT NOT NULL,
    "estPopulaire" BOOLEAN DEFAULT FALSE,
    "dateSoumission" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY ("idTypeRetour") REFERENCES "typeRetour"("idTypeRetour"),
    FOREIGN KEY ("idClassificationSentiment") REFERENCES "classificationSentiment"("idClassificationSentiment")
);

CREATE TABLE "actionAmelioration" (
    "idAction" SERIAL PRIMARY KEY,
    "idRetourOrigine" INT NOT NULL,
    "idAuteurAdmin" INT NOT NULL,
    "instructionEmployes" TEXT NOT NULL,
    "idStatutDemandeAchat" INT NOT NULL,
    FOREIGN KEY ("idRetourOrigine") REFERENCES "retourClient"("idRetour"),
    FOREIGN KEY ("idAuteurAdmin") REFERENCES "utilisateur"("idUtilisateur"),
    FOREIGN KEY ("idStatutDemandeAchat") REFERENCES "statutDemandeAchat"("idStatutDemandeAchat")
);

CREATE TABLE "notificationPlateforme" (
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