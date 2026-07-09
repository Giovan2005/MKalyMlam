CREATE TABLE IF NOT EXISTS "pointDeVente" (
    "idPointDeVente" SERIAL PRIMARY KEY,
    "nom" VARCHAR(100) NOT NULL,
    "adresse" TEXT NOT NULL,
    "description" TEXT,
    "estActif" BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS "itineraireArret" (
    "idArret" SERIAL PRIMARY KEY,
    "idItineraire" INT NOT NULL,
    "idPointDeVente" INT NOT NULL,
    "ordre" INT NOT NULL,
    FOREIGN KEY ("idItineraire") REFERENCES "itineraire"("idItineraire"),
    FOREIGN KEY ("idPointDeVente") REFERENCES "pointDeVente"("idPointDeVente"),
    UNIQUE ("idItineraire", "ordre")
);

-- Insertion de points de vente de test
INSERT INTO "pointDeVente" ("nom", "adresse", "description") VALUES
('Marché d''Analakely', 'Analakely, Antananarivo 101', 'Marché central'),
('Station Jovenna Ankorondrano', 'Ankorondrano, Antananarivo 101', 'Station-service avec parking'),
('École Primaire Ambohimanarina', 'Ambohimanarina, Antananarivo 101', 'Devant l''école'),
('Hôpital Joseph Ravoahangy', 'Ampefiloha, Antananarivo 101', 'Entrée principale de l''hôpital'),
('Lycée Andohalo', 'Andohalo, Antananarivo 101', 'Arrêt devant le lycée'),
('Place de l''Indépendance', 'Antaninarenina, Antananarivo 101', 'Place centrale de la ville');
