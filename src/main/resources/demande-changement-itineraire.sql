
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


CREATE TABLE "statutValidation" (
    "idStatutValidation" SERIAL PRIMARY KEY,
    "libelle" VARCHAR(50) NOT NULL
);

INSERT INTO "statutValidation" ("libelle") VALUES ('EN_ATTENTE'), ('VALIDE'), ('REFUSE');
