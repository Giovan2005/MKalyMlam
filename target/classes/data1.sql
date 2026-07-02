INSERT INTO "produit" ("nomProduit", "prixBase") VALUES
('Sandwich poulet', 5000.00),
('Burger boeuf', 7000.00),
('Hot dog', 4000.00),
('Salade cesar', 5500.00),
('Pizza fromage', 8000.00);

INSERT INTO "ingredient" ("nomIngredient", "seuilAlerteQuantite", "uniteMesure") VALUES
('Pain burger', 10.00, 'piece'),
('Blanc de poulet', 5.00, 'kg'),
('Steak boeuf', 5.00, 'kg'),
('Salade verte', 3.00, 'kg'),
('Tomate', 5.00, 'kg'),
('Fromage râpé', 5.00, 'kg'),
('Saucisse', 5.00, 'kg'),
('Pâte à pizza', 10.00, 'piece'),
('Sauce tomate', 5.00, 'L');

INSERT INTO "recetteDeBase" ("idProduit", "idIngredient", "quantiteRecette") VALUES
(1, 2, 0.200),
(1, 4, 0.050),
(1, 5, 0.050),
(2, 1, 1.000),
(2, 3, 0.150),
(2, 6, 0.030),
(3, 1, 1.000),
(3, 7, 1.000),
(4, 4, 0.100),
(4, 5, 0.050),
(5, 8, 1.000),
(5, 9, 0.100),
(5, 6, 0.100);

INSERT INTO "itineraire" ("nomZone", "lieuExact", "heureDebutPrevue", "heureFinPrevue", "jourSemaine") VALUES
('Analakely', 'Devant la gare', '11:00:00', '14:00:00', 'LUNDI'),
('Ivandry', 'Pres du supermarché Leader Price', '17:00:00', '21:00:00', 'LUNDI'),
('Antanimena', 'Devant l université', '11:00:00', '14:00:00', 'MARDI'),
('Ankorondrano', 'Pres de Orange', '17:00:00', '21:00:00', 'MARDI'),
('Isotry', 'Marche d Isotry', '11:00:00', '15:00:00', 'MERCREDI'),
('Behoririka', 'Pres de la gare routière', '11:00:00', '14:00:00', 'JEUDI'),
('Anosy', 'Pres du lac Anosy', '17:00:00', '21:00:00', 'JEUDI'),
('Ambohijatovo', 'Devant la banque BNI', '11:00:00', '15:00:00', 'VENDREDI'),
('Antaninandro', 'Pres du marché', '17:00:00', '21:00:00', 'VENDREDI'),
('Ambodivona', 'Pres de Telma', '10:00:00', '14:00:00', 'SAMEDI');






======donnees============
INSERT INTO "utilisateur" ("nom", "prenom", "email", "motDePasse", "idRole", "salaireBaseFixe", "statutActif") VALUES
('Dubois', 'Pierre', 'pierre.dubois@foodtruck.fr', 'hashed_password', 1, 2800.00, true),
('Martin', 'Sophie', 'sophie.martin@foodtruck.fr', 'hashed_password', 2, 1950.00, true),
('Bernard', 'Lucas', 'lucas.bernard@foodtruck.fr', 'hashed_password', 3, 2100.00, true),
('Petit', 'Emma', 'emma.petit@foodtruck.fr', 'hashed_password', 2, 1950.00, false),
('Lefèvre', 'Thomas', 'thomas.lefevre@foodtruck.fr', 'hashed_password', 4, 1850.00, true),
('Moreau', 'Camille', 'camille.moreau@foodtruck.fr', 'hashed_password', 5, 1700.00, true);


-- Insérer quelques absences de test
INSERT INTO "absenceConge" ("idUtilisateur", "idTypeConge", "dateDebut", "dateFin", "idStatutValidation", "deductionSalaireAppliquee", "idRemplacant")
VALUES
(1, 1, '2026-08-01', '2026-08-10', 1, 150.00, 2),  -- Pierre Dubois (admin) en congé payé, en attente, remplacé par Sophie Martin
(2, 2, '2026-07-15', '2026-07-17', 2, 80.00, NULL), -- Sophie Martin maladie, validé
(3, 3, '2026-07-20', '2026-07-20', 3, 0.00, NULL);  -- Lucas Bernard absence injustifiée, refusé