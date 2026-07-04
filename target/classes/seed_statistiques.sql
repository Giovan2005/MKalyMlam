-- ==============================================================================
-- SEED DE TEST v2 - sessionTruck / commande / depense
-- ==============================================================================
-- Différence avec la v1 : chaque itinéraire a déjà un "jourSemaine" en base
-- (LUNDI, MARDI, ...). La v1 ignorait ce champ et mettait toutes les sessions
-- d'une même semaine sur le même jour calendaire, ce qui rendait les vues
-- Journalier et Hebdomadaire visuellement identiques. Ici, chaque session est
-- placée sur le VRAI jour de la semaine de son itinéraire → les données sont
-- réparties sur Lundi à Samedi, donc jour/semaine/mois donnent des résultats
-- visiblement différents.
--
-- Ce script est désormais IDEMPOTENT : il supprime d'abord toute donnée liée
-- au truck 'TRK-001' avant de la recréer, donc le relancer plusieurs fois ne
-- duplique plus rien (contrairement à la v1).
--
-- Recommandé : lancez-le avec ON_ERROR_STOP pour qu'il s'arrête net à la
-- moindre erreur au lieu de continuer partiellement :
--   sudo -u postgres psql -v ON_ERROR_STOP=1 -d foodTruckDb -f seed_statistiques.sql
-- ==============================================================================

SELECT setseed(0.42); -- résultats reproductibles à chaque exécution

-- 0. Nettoyage préalable (rend le script rejouable sans dupliquer les données)
DELETE FROM "commande"
WHERE "idSession" IN (
    SELECT "idSession" FROM "sessionTruck"
    WHERE "idTruck" IN (SELECT "idTruck" FROM "truck" WHERE "immatriculation" = 'TRK-001')
);
DELETE FROM "depense"
WHERE "idSession" IN (
    SELECT "idSession" FROM "sessionTruck"
    WHERE "idTruck" IN (SELECT "idTruck" FROM "truck" WHERE "immatriculation" = 'TRK-001')
);
DELETE FROM "sessionTruck"
WHERE "idTruck" IN (SELECT "idTruck" FROM "truck" WHERE "immatriculation" = 'TRK-001');
DELETE FROM "truck" WHERE "immatriculation" = 'TRK-001';

-- 1. Un truck (nécessaire : sessionTruck.idTruck est NOT NULL)
INSERT INTO "truck" ("immatriculation", "idStatutDisponibilite")
VALUES ('TRK-001', 1); -- 1 = DISPONIBLE

-- 2. Une session par itinéraire, chaque semaine sur les 10 dernières semaines,
--    placée sur le jour de la semaine réellement associé à l'itinéraire
--    (colonne "jourSemaine" déjà présente dans data1.sql).
INSERT INTO "sessionTruck" ("idTruck", "idItineraire", "dateSession", "fondDeCaisseOuverture", "idStatutSession")
SELECT
    1,
    i."idItineraire",
    (date_trunc('week', w)::date + (jours.num - 1)) AS "dateSession",
    50000,
    2 -- CLOTUREE
FROM "itineraire" i
JOIN (
    SELECT 'LUNDI' AS libelle, 1 AS num
    UNION ALL SELECT 'MARDI', 2
    UNION ALL SELECT 'MERCREDI', 3
    UNION ALL SELECT 'JEUDI', 4
    UNION ALL SELECT 'VENDREDI', 5
    UNION ALL SELECT 'SAMEDI', 6
    UNION ALL SELECT 'DIMANCHE', 7
) jours ON jours.libelle = i."jourSemaine"
CROSS JOIN generate_series(CURRENT_DATE - INTERVAL '70 days', CURRENT_DATE - INTERVAL '1 day', INTERVAL '7 days') AS w
WHERE (date_trunc('week', w)::date + (jours.num - 1)) <= CURRENT_DATE - INTERVAL '1 day';

-- 3. Entre 2 et 5 commandes par session, montants entre 3 000 et 25 000 Ar,
--    réparties dans la journée (entre 10h et 20h)
INSERT INTO "commande" ("idSession", "idTypeCommande", "dateHeureCreation", "montantTotal", "idStatutCommande", "idTypeTarification")
SELECT
    st."idSession",
    1, -- SUR_PLACE
    st."dateSession" + (10 + random() * 10) * INTERVAL '1 hour',
    (3000 + random() * 22000)::numeric(12, 2),
    4, -- LIVREE
    1  -- HEURE_NORMALE
FROM "sessionTruck" st
JOIN "truck" t ON t."idTruck" = st."idTruck" AND t."immatriculation" = 'TRK-001'
CROSS JOIN LATERAL generate_series(1, (2 + floor(random() * 4))::int) AS g(n);

-- 4. Une dépense (carburant) par session, entre 5 000 et 15 000 Ar
INSERT INTO "depense" ("idSession", "idTypeDepense", "montantDepense", "raisonDetaillee", "dateDepense", "idStatutValidationAdmin")
SELECT
    st."idSession",
    2, -- CARBURANT
    (5000 + random() * 10000)::numeric(10, 2),
    'Carburant pour la session',
    st."dateSession",
    2 -- VALIDE_ADMIN
FROM "sessionTruck" st
JOIN "truck" t ON t."idTruck" = st."idTruck" AND t."immatriculation" = 'TRK-001';

-- 5. Synchronise chiffreAffaireTotal / fondDeCaisseCloture / commissionTotaleEquipe
--    avec les commandes réellement créées.
UPDATE "sessionTruck" st
SET
    "chiffreAffaireTotal" = ca.total,
    "fondDeCaisseCloture" = st."fondDeCaisseOuverture" + ca.total,
    "commissionTotaleEquipe" = ROUND(ca.total * 0.05, 2)
FROM (
    SELECT "idSession", COALESCE(SUM("montantTotal"), 0) AS total
    FROM "commande"
    GROUP BY "idSession"
) ca
WHERE ca."idSession" = st."idSession";

-- Résumé + répartition par jour de la semaine, pour vérifier visuellement
-- que les sessions sont bien étalées sur plusieurs jours différents.
SELECT
    (SELECT COUNT(*) FROM "sessionTruck") AS nb_sessions,
    (SELECT COUNT(*) FROM "commande") AS nb_commandes,
    (SELECT COUNT(*) FROM "depense") AS nb_depenses,
    (SELECT COALESCE(SUM("montantTotal"), 0) FROM "commande") AS ca_total;

SELECT to_char("dateSession", 'ID') AS jour_iso, i."jourSemaine", COUNT(*) AS nb_sessions
FROM "sessionTruck" st
JOIN "itineraire" i ON i."idItineraire" = st."idItineraire"
GROUP BY 1, 2
ORDER BY 1;