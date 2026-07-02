-- Voir les doublons
SELECT libelle, COUNT(*) 
FROM "statutDisponibilite" 
GROUP BY libelle 
HAVING COUNT(*) > 1;

-- Garder seulement le premier de chaque libelle (supprimer les doublons)
DELETE FROM "statutDisponibilite" 
WHERE "idStatutDisponibilite" NOT IN (
    SELECT MIN("idStatutDisponibilite") 
    FROM "statutDisponibilite" 
    GROUP BY libelle
);