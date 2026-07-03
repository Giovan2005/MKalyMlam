package com.mkalymlam.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import jakarta.transaction.Transactional;

// import com.mkalymlam.entity.Ingredient;
// import com.mkalymlam.repository.IngredientRepository;


@Service
@Transactional
public class StatistiqueService {

    private final JdbcTemplate jdbcTemplate;

    public StatistiqueService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private List<Map<String,Object>> executeStatQuery(String sql,Object... params){

    return jdbcTemplate.queryForList(sql,params);

}

    public Double getChiffreAffaireGlobal() {

        String sql = """
            SELECT COALESCE(SUM("montantTotal"),0)
            FROM "commande"
            """;

        return jdbcTemplate.queryForObject(sql, Double.class);
    }


    public Double getChiffreAffaireByIdSession(Long idSession) {

        String sql = """
            SELECT COALESCE(SUM("montantTotal"),0)
            FROM "commande" where commande.idSession = ?
            """;

        return jdbcTemplate.queryForObject(sql, Double.class, idSession);
    }

    public Double getChiffreAffaireByZone(String zone) {
        String sql="""
            SELECT
            COALESCE(SUM("chiffreAffaireTotal"),0)
            FROM "view_Itineraire_SessionTruck_Depense"
            WHERE "nomZone"=?
            """;

        return jdbcTemplate.queryForObject(
                sql,
                Double.class,
                zone
        );
    }


    public Double getBeneficeByZone(String zone) {
        String sql="""
            SELECT
            COALESCE(SUM("chiffreAffaireTotal"),0)
            -
            COALESCE(SUM("montantDepenseTotal"),0)
            FROM "view_Itineraire_SessionTruck_Depense"
            WHERE "nomZone"=?
            """;

        return jdbcTemplate.queryForObject(
                sql,
                Double.class,
                zone
        );
    }


    public Double getChiffreAffaireByIdSessionHebdomadaire(Long idSession) {

        String sql = """
            SELECT COALESCE(SUM("montantTotal"),0)
            FROM "commande"
            WHERE "idSession" = ?
            AND "dateHeureCreation"
            >= CURRENT_DATE - INTERVAL '7 days';
            """;

        return jdbcTemplate.queryForObject(sql, Double.class, idSession);
    }


    public Double getChiffreAffaireByIdSessionDates(Long idSession, LocalDateTime date1, LocalDateTime date2) {

        String sql = """
            SELECT COALESCE(SUM("montantTotal"),0)
            FROM "commande" where commande.idSession = ?
            and "dateHeureCreation" >= ? and "dateHeureCreation" <= ?
            """;

        return jdbcTemplate.queryForObject(sql, Double.class, idSession, date1, date2);
    }

    public Double getChiffreAffaireByIdSessionMensuel(Long idSession) {

        String sql = """
            SELECT * from view_CA_Depense_Benefice_Mensuel
            where "idSession" = ?
            """;

        return jdbcTemplate.queryForObject(sql, Double.class, idSession);
    }

    public Double getBeneficeByIdItineraire(Long idItineraire){

        String sql="""
            SELECT
            COALESCE(SUM("chiffreAffaireTotal"),0)
            -
            COALESCE(SUM("montantDepenseTotal"),0)
            FROM "view_Itineraire_SessionTruck_Depense"
            WHERE "idItineraire"=?
            """;

        return jdbcTemplate.queryForObject(
                sql,
                Double.class,
                idItineraire
        );
    }

    public Double getBeneficeTotal(){

        String sql="""
            SELECT COALESCE(SUM("montantDepense"),0)
            FROM "depense"
            """;

        Double depense=jdbcTemplate.queryForObject(sql,Double.class);

        return getChiffreAffaireGlobal()-depense;
    }


    public List<Map<String, Object>> getDonneesGraphique() {
        String sql = """
                    SELECT
                        COALESCE(rev."date", dep."date") AS "periode",
                        COALESCE(rev."chiffreAffaire", 0) AS "chiffreAffaire",
                        COALESCE(rev."chiffreAffaire", 0) - COALESCE(dep."montantDepense", 0) AS "benefice"
                    FROM (
                        SELECT "dateSession" AS "date", SUM("chiffreAffaireTotal") AS "chiffreAffaire"
                        FROM "sessionTruck"
                        GROUP BY "dateSession"
                    ) rev
                    FULL JOIN (
                        SELECT "dateDepense" AS "date", SUM("montantDepense") AS "montantDepense"
                        FROM "depense"
                        GROUP BY "dateDepense"
                    ) dep ON dep."date" = rev."date"
                    ORDER BY "periode"
                """;
        return executeStatQuery(sql);
    }

    public List<Map<String, Object>> getChiffreAffaireParJour() {
        String sql = """
                    SELECT "dateSession" AS "periode", SUM("chiffreAffaireTotal") AS "chiffreAffaire"
                    FROM "sessionTruck"
                    GROUP BY "dateSession"
                    ORDER BY "dateSession"
                """;
        return executeStatQuery(sql);
    }

    public List<Map<String, Object>> getChiffreAffaireParSemaine() {
        String sql = """
                    SELECT date_trunc('week', "dateSession")::date AS "periode", SUM("chiffreAffaireTotal") AS "chiffreAffaire"
                    FROM "sessionTruck"
                    GROUP BY date_trunc('week', "dateSession")
                    ORDER BY "periode"
                """;
        return executeStatQuery(sql);
    }

    public List<Map<String, Object>> getChiffreAffaireParMois() {
        String sql = """
                    SELECT date_trunc('month', "dateSession")::date AS "periode", SUM("chiffreAffaireTotal") AS "chiffreAffaire"
                    FROM "sessionTruck"
                    GROUP BY date_trunc('month', "dateSession")
                    ORDER BY "periode"
                """;
        return executeStatQuery(sql);
    }

    public List<Map<String, Object>> getBeneficeParJour() {
        String sql = """
                    SELECT COALESCE(rev."date", dep."date") AS "periode",
                        COALESCE(rev."chiffreAffaire", 0) - COALESCE(dep."montantDepense", 0) AS "benefice"
                    FROM (
                        SELECT "dateSession" AS "date", SUM("chiffreAffaireTotal") AS "chiffreAffaire"
                        FROM "sessionTruck"
                        GROUP BY "dateSession"
                    ) rev
                    FULL JOIN (
                        SELECT "dateDepense" AS "date", SUM("montantDepense") AS "montantDepense"
                        FROM "depense"
                        GROUP BY "dateDepense"
                    ) dep ON dep."date" = rev."date"
                    ORDER BY "periode"
                """;
        return executeStatQuery(sql);
    }

    public List<Map<String, Object>> getBeneficeParSemaine() {
        String sql = """
                    SELECT COALESCE(rev."periode", dep."periode") AS "periode",
                        COALESCE(rev."chiffreAffaire", 0) - COALESCE(dep."montantDepense", 0) AS "benefice"
                    FROM (
                        SELECT date_trunc('week', "dateSession")::date AS "periode", SUM("chiffreAffaireTotal") AS "chiffreAffaire"
                        FROM "sessionTruck"
                        GROUP BY date_trunc('week', "dateSession")
                    ) rev
                    FULL JOIN (
                        SELECT date_trunc('week', "dateDepense")::date AS "periode", SUM("montantDepense") AS "montantDepense"
                        FROM "depense"
                        GROUP BY date_trunc('week', "dateDepense")
                    ) dep ON dep."periode" = rev."periode"
                    ORDER BY "periode"
                """;
        return executeStatQuery(sql);
    }

    public List<Map<String, Object>> getBeneficeParMois() {
        String sql = """
                    SELECT COALESCE(rev."periode", dep."periode") AS "periode",
                        COALESCE(rev."chiffreAffaire", 0) - COALESCE(dep."montantDepense", 0) AS "benefice"
                    FROM (
                        SELECT date_trunc('month', "dateSession")::date AS "periode", SUM("chiffreAffaireTotal") AS "chiffreAffaire"
                        FROM "sessionTruck"
                        GROUP BY date_trunc('month', "dateSession")
                    ) rev
                    FULL JOIN (
                        SELECT date_trunc('month', "dateDepense")::date AS "periode", SUM("montantDepense") AS "montantDepense"
                        FROM "depense"
                        GROUP BY date_trunc('month', "dateDepense")
                    ) dep ON dep."periode" = rev."periode"
                    ORDER BY "periode"
                """;
        return executeStatQuery(sql);
    }

    public List<Map<String, Object>> getBeneficeParItineraireParJour(Long idItineraire) {
        String sql = """
                    SELECT st."dateSession" AS "periode",
                        COALESCE(SUM(st."chiffreAffaireTotal"), 0) - COALESCE(SUM(d."montantDepense"), 0) AS "benefice"
                    FROM "sessionTruck" st
                    LEFT JOIN "depense" d ON d."idSession" = st."idSession"
                    WHERE st."idItineraire" = ?
                    GROUP BY st."dateSession"
                    ORDER BY st."dateSession"
                """;
        return executeStatQuery(sql, idItineraire);
    }

    public List<Map<String, Object>> getBeneficeParItineraireParSemaine(Long idItineraire) {
        String sql = """
                    SELECT date_trunc('week', st."dateSession")::date AS "periode",
                        COALESCE(SUM(st."chiffreAffaireTotal"), 0) - COALESCE(SUM(d."montantDepense"), 0) AS "benefice"
                    FROM "sessionTruck" st
                    LEFT JOIN "depense" d ON d."idSession" = st."idSession"
                    WHERE st."idItineraire" = ?
                    GROUP BY date_trunc('week', st."dateSession")
                    ORDER BY "periode"
                """;
        return executeStatQuery(sql, idItineraire);
    }

    public List<Map<String, Object>> getBeneficeParItineraireParMois(Long idItineraire) {
        String sql = """
                    SELECT date_trunc('month', st."dateSession")::date AS "periode",
                        COALESCE(SUM(st."chiffreAffaireTotal"), 0) - COALESCE(SUM(d."montantDepense"), 0) AS "benefice"
                    FROM "sessionTruck" st
                    LEFT JOIN "depense" d ON d."idSession" = st."idSession"
                    WHERE st."idItineraire" = ?
                    GROUP BY date_trunc('month', st."dateSession")
                    ORDER BY "periode"
                """;
        return executeStatQuery(sql, idItineraire);
    }

    // =========================================================================
    // AJOUTS - nécessaires pour que StatistiqueController compile (il appelait
    // déjà ces signatures avec dateDebut/dateFin) et pour le filtre par zone.
    // Aucune méthode existante ci-dessus n'a été modifiée.
    // =========================================================================

    /**
     * Chiffre d'affaires global, filtrable par plage de dates (bornes incluses).
     * dateDebut/dateFin peuvent être null (= pas de borne de ce côté).
     */
    public Double getChiffreAffaireGlobal(LocalDate dateDebut, LocalDate dateFin) {
        StringBuilder sql = new StringBuilder("""
            SELECT COALESCE(SUM("montantTotal"),0)
            FROM "commande"
            WHERE 1=1
            """);
        List<Object> params = new ArrayList<>();
        if (dateDebut != null) {
            sql.append(" AND \"dateHeureCreation\" >= ?");
            params.add(dateDebut.atStartOfDay());
        }
        if (dateFin != null) {
            sql.append(" AND \"dateHeureCreation\" < ?");
            params.add(dateFin.plusDays(1).atStartOfDay());
        }
        return jdbcTemplate.queryForObject(sql.toString(), Double.class, params.toArray());
    }

    /**
     * Bénéfice total, filtrable par plage de dates (bornes incluses).
     */
    public Double getBeneficeTotal(LocalDate dateDebut, LocalDate dateFin) {
        StringBuilder sql = new StringBuilder("""
            SELECT COALESCE(SUM("montantDepense"),0)
            FROM "depense"
            WHERE 1=1
            """);
        List<Object> params = new ArrayList<>();
        if (dateDebut != null) {
            sql.append(" AND \"dateDepense\" >= ?");
            params.add(dateDebut);
        }
        if (dateFin != null) {
            sql.append(" AND \"dateDepense\" < ?");
            params.add(dateFin.plusDays(1));
        }
        Double depense = jdbcTemplate.queryForObject(sql.toString(), Double.class, params.toArray());
        return getChiffreAffaireGlobal(dateDebut, dateFin) - depense;
    }

    /**
     * Données du graphique, filtrables par plage de dates (bornes incluses).
     * Même logique que getDonneesGraphique() mais avec un WHERE conditionnel
     * sur "dateSession" et "dateDepense".
     */
    public List<Map<String, Object>> getDonneesGraphique(LocalDate dateDebut, LocalDate dateFin) {
        StringBuilder sql = new StringBuilder("""
                    SELECT
                        COALESCE(rev."date", dep."date") AS "periode",
                        COALESCE(rev."chiffreAffaire", 0) AS "chiffreAffaire",
                        COALESCE(rev."chiffreAffaire", 0) - COALESCE(dep."montantDepense", 0) AS "benefice"
                    FROM (
                        SELECT "dateSession" AS "date", SUM("chiffreAffaireTotal") AS "chiffreAffaire"
                        FROM "sessionTruck"
                        WHERE 1=1
                """);
        List<Object> params = new ArrayList<>();
        if (dateDebut != null) {
            sql.append(" AND \"dateSession\" >= ?");
            params.add(dateDebut);
        }
        if (dateFin != null) {
            sql.append(" AND \"dateSession\" < ?");
            params.add(dateFin.plusDays(1));
        }
        sql.append("""
                        GROUP BY "dateSession"
                    ) rev
                    FULL JOIN (
                        SELECT "dateDepense" AS "date", SUM("montantDepense") AS "montantDepense"
                        FROM "depense"
                        WHERE 1=1
                """);
        if (dateDebut != null) {
            sql.append(" AND \"dateDepense\" >= ?");
            params.add(dateDebut);
        }
        if (dateFin != null) {
            sql.append(" AND \"dateDepense\" < ?");
            params.add(dateFin.plusDays(1));
        }
        sql.append("""
                        GROUP BY "dateDepense"
                    ) dep ON dep."date" = rev."date"
                    ORDER BY "periode"
                """);
        return executeStatQuery(sql.toString(), params.toArray());
    }

    /**
     * Liste des zones distinctes (table "itineraire"), pour peupler le filtre zone.
     */
    public List<String> getZones() {
        String sql = """
            SELECT DISTINCT "nomZone"
            FROM "itineraire"
            WHERE "nomZone" IS NOT NULL
            ORDER BY "nomZone"
            """;
        return jdbcTemplate.queryForList(sql, String.class);
    }

    /**
     * Chiffre d'affaires groupé par zone, en une seule requête :
     * SessionTruck -> Itineraire (nomZone) -> Commande (montantTotal).
     * dateDebut/dateFin (optionnels) filtrent sur "sessionTruck"."dateSession".
     */
    public List<Map<String, Object>> getChiffreAffaireParZoneGroupe(LocalDate dateDebut, LocalDate dateFin) {
        StringBuilder sql = new StringBuilder("""
            SELECT i."nomZone" AS "zone", COALESCE(SUM(c."montantTotal"),0) AS "chiffreAffaire"
            FROM "sessionTruck" st
            JOIN "itineraire" i ON i."idItineraire" = st."idItineraire"
            LEFT JOIN "commande" c ON c."idSession" = st."idSession"
            WHERE 1=1
            """);
        List<Object> params = new ArrayList<>();
        if (dateDebut != null) {
            sql.append(" AND st.\"dateSession\" >= ?");
            params.add(dateDebut);
        }
        if (dateFin != null) {
            sql.append(" AND st.\"dateSession\" < ?");
            params.add(dateFin.plusDays(1));
        }
        sql.append("""
            GROUP BY i."nomZone"
            ORDER BY i."nomZone"
            """);
        return executeStatQuery(sql.toString(), params.toArray());
    }

    /**
     * Bénéfice groupé par zone : CA par zone (via Commande) moins les dépenses
     * par zone (via Depense), chacun agrégé séparément avant jointure pour
     * éviter un produit cartésien entre les deux jointures one-to-many.
     */
    public List<Map<String, Object>> getBeneficeParZoneGroupe(LocalDate dateDebut, LocalDate dateFin) {
        StringBuilder revSql = new StringBuilder("""
            SELECT i."nomZone" AS "zone", SUM(c."montantTotal") AS "ca"
            FROM "sessionTruck" st
            JOIN "itineraire" i ON i."idItineraire" = st."idItineraire"
            JOIN "commande" c ON c."idSession" = st."idSession"
            WHERE 1=1
            """);
        List<Object> revParams = new ArrayList<>();
        if (dateDebut != null) {
            revSql.append(" AND st.\"dateSession\" >= ?");
            revParams.add(dateDebut);
        }
        if (dateFin != null) {
            revSql.append(" AND st.\"dateSession\" < ?");
            revParams.add(dateFin.plusDays(1));
        }
        revSql.append(" GROUP BY i.\"nomZone\"");

        StringBuilder depSql = new StringBuilder("""
            SELECT i."nomZone" AS "zone", SUM(d."montantDepense") AS "depense"
            FROM "sessionTruck" st
            JOIN "itineraire" i ON i."idItineraire" = st."idItineraire"
            JOIN "depense" d ON d."idSession" = st."idSession"
            WHERE 1=1
            """);
        List<Object> depParams = new ArrayList<>();
        if (dateDebut != null) {
            depSql.append(" AND st.\"dateSession\" >= ?");
            depParams.add(dateDebut);
        }
        if (dateFin != null) {
            depSql.append(" AND st.\"dateSession\" < ?");
            depParams.add(dateFin.plusDays(1));
        }
        depSql.append(" GROUP BY i.\"nomZone\"");

        String sql = """
            SELECT COALESCE(rev."zone", dep."zone") AS "zone",
                COALESCE(rev."ca", 0) - COALESCE(dep."depense", 0) AS "benefice"
            FROM (%s) rev
            FULL JOIN (%s) dep ON dep."zone" = rev."zone"
            ORDER BY "zone"
            """.formatted(revSql, depSql);

        List<Object> params = new ArrayList<>();
        params.addAll(revParams);
        params.addAll(depParams);
        return executeStatQuery(sql, params.toArray());
    }

}