CREATE OR REPLACE VIEW "view_Itineraire_SessionTruck_Depense" AS
SELECT
    i."idItineraire",
    i."nomZone",

    s."idSession",
    s."idTruck",
    s."dateSession",
    s."fondDeCaisseOuverture",
    s."fondDeCaisseCloture",
    s."chiffreAffaireTotal",

    COALESCE(d."montantDepenseTotal",0) AS "montantDepenseTotal"

FROM "itineraire" i

INNER JOIN "sessionTruck" s
    ON i."idItineraire" = s."idItineraire"

LEFT JOIN (
    SELECT
        "idSession",
        SUM("montantDepense") AS "montantDepenseTotal"
    FROM "depense"
    GROUP BY "idSession"
) d
    ON s."idSession" = d."idSession";


CREATE OR REPLACE VIEW "view_CA_Depense_Benefice_Mensuel_Session" AS

SELECT

v."idSession"

date_trunc('month', "dateSession") AS mois,

SUM("chiffreAffaireTotal") AS chiffre_affaire,

SUM("montantDepenseTotal") AS depenses,

SUM("chiffreAffaireTotal")
-
SUM("montantDepenseTotal")
AS benefice

FROM "view_Itineraire_SessionTruck_Depense" v

GROUP BY date_trunc('month', "dateSession")

ORDER BY date_trunc('month', "dateSession");