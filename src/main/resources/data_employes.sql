-- Initialisation des utilisateurs employes
-- Les roles sont resolus par libelle pour eviter de dependre des IDs fixes.

INSERT INTO "utilisateur" (
    "nom",
    "prenom",
    "email",
    "motDePasse",
    "idRole",
    "salaireBaseFixe",
    "statutActif"
)
VALUES
    (
        'Rakoto',
        'Jean',
        'jean.rakoto@example.com',
        'password123',
        (SELECT "idRole" FROM "role" WHERE "libelle" = 'CHAUFFEUR'),
        500000.00,
        TRUE
    ),
    (
        'Rabe',
        'Paul',
        'paul.rabe@example.com',
        'password123',
        (SELECT "idRole" FROM "role" WHERE "libelle" = 'CHAUFFEUR'),
        450000.00,
        TRUE
    ),
    (
        'Randria',
        'Marie',
        'marie.randria@example.com',
        'password123',
        (SELECT "idRole" FROM "role" WHERE "libelle" = 'VENDEUSE'),
        480000.00,
        TRUE
    ),
    (
        'Andria',
        'Tiana',
        'tiana.andria@example.com',
        'password123',
        (SELECT "idRole" FROM "role" WHERE "libelle" = 'CUISINIER'),
        520000.00,
        TRUE
    ),
    (
        'Ratsimba',
        'Lalao',
        'lalao.ratsimba@example.com',
        'password123',
        (SELECT "idRole" FROM "role" WHERE "libelle" = 'REMPLACANT'),
        470000.00,
        TRUE
    )
ON CONFLICT ("email") DO NOTHING;

-- Verification optionnelle
SELECT
    u."idUtilisateur",
    u."nom",
    u."prenom",
    u."email",
    r."libelle" AS "role",
    u."salaireBaseFixe",
    u."statutActif"
FROM "utilisateur" u
JOIN "role" r ON u."idRole" = r."idRole"
WHERE r."libelle" IN ('CHAUFFEUR', 'VENDEUSE', 'CUISINIER', 'REMPLACANT')
ORDER BY u."idUtilisateur";
