-- ==============================================================================
-- ANNULATION DU SEED DE TEST (seed_statistiques.sql)
-- ==============================================================================
-- Remet "truck", "sessionTruck", "commande" et "depense" à zéro (ces 4 tables
-- étaient vides avant le seed). CASCADE supprime aussi les lignes des tables
-- qui les référencent (equipeSession, ligneCommande, factureRecu, etc.) —
-- normalement vides également puisqu'elles dépendent de ces 4-là.
--
-- À exécuter avec :
--   psql -U postgres -d foodTruckDb -f annuler_seed_statistiques.sql
-- ==============================================================================
 
TRUNCATE TABLE "depense" RESTART IDENTITY CASCADE;
TRUNCATE TABLE "commande" RESTART IDENTITY CASCADE;
TRUNCATE TABLE "sessionTruck" RESTART IDENTITY CASCADE;
TRUNCATE TABLE "truck" RESTART IDENTITY CASCADE;
 
-- Vérification : tout doit revenir à 0
SELECT
    (SELECT COUNT(*) FROM "sessionTruck") AS nb_sessions,
    (SELECT COUNT(*) FROM "commande") AS nb_commandes,
    (SELECT COUNT(*) FROM "depense") AS nb_depenses,
    (SELECT COUNT(*) FROM "truck") AS nb_trucks;
 