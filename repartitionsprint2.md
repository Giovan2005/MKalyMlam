# REMARQUES : CHAQUE STATISTIQUES (/ LISTES / FACTURES .... ) DOIT POUVOIR ETRE EXPORTE EN CSV,PDF( PAS ENCORE D'IMPORT); EN CAS DE QUESTION , POSEZ VOS QUESTIONS AU CP(ZA MO ZANY LE IZY)

---

# Tâches à accomplir

## Gestion de l'équipe par session (Qui travaille aujourd'hui ?)

> **Assigné à : Loïc**

### Entités concernées

* `Equipe_Session`

### Fonctionnalités à implémenter

Permettre de définir, pour chaque journée de travail, quels employés sont présents et dans quel rôle :

* Associer un ou plusieurs employés à une session du jour
* Définir le rôle de chaque employé pour cette journée (`VENDEUSE`, `CUISINIER`, `CHAUFFEUR`)
* Gérer le cas d'un remplaçant : si l'employé du jour est un `REMPLACANT`, appliquer un salaire journalier spécifique
* Consulter la liste des employés affectés à une session donnée

### Règle métier importante

Si l'utilisateur affecté à la session a le rôle `REMPLACANT` dans sa fiche employé, le champ `salaire_journalier_remplacant` doit être obligatoirement renseigné pour cette session.

---

## Fichiers à créer

### EquipeSession

* `EquipeSession.java`
* `EquipeSessionRepository.java`
* `EquipeSessionService.java`
* `EquipeSessionController.java`

---

## Structure de l'entité

### Clé primaire composite

* `id_session` → clé étrangère vers `SessionTruck`
* `id_utilisateur` → clé étrangère vers `Utilisateur`

### Champs supplémentaires

* `role_du_jour` → enum (`VENDEUSE`, `CUISINIER`, `CHAUFFEUR`)
* `salaire_journalier_remplacant` → Double (optionnel, uniquement pour les remplaçants)

Exemple :

```java
@EmbeddedId
private EquipeSessionId id;

@ManyToOne
@MapsId("idSession")
private SessionTruck sessionTruck;

@ManyToOne
@MapsId("idUtilisateur")
private Utilisateur utilisateur;

@Enumerated(EnumType.STRING)
private RoleDuJour roleDuJour;

private Double salaireJournalierRemplacant;
```

---

## Endpoints à créer

* `/equipe/affecter` — Ajouter un employé à une session
* `/equipe/retirer` — Retirer un employé d'une session
* `/equipe/findBySession` — Lister tous les employés d'une session donnée
* `/equipe/findAll`

---

## Affichage minimal

### Page de gestion de l'équipe du jour

Champs :

* Sélection de la session (dropdown des sessions OUVERTES du jour)
* Sélection de l'employé (dropdown des utilisateurs actifs)
* Sélection du rôle du jour (dropdown : VENDEUSE / CUISINIER / CHAUFFEUR)
* Champ salaire journalier (affiché uniquement si l'employé est un REMPLACANT)

Action :

* Bouton **Affecter à la session**

### Liste des employés affectés

Afficher pour chaque session :

```text
Session #1 — Analakely — 01/07/2026
Jean    | CHAUFFEUR  | Fixe
Marie   | VENDEUSE   | Fixe
Ranto   | CUISINIER  | Remplaçant — 25 000 Ar/jour
```

---

## Demande de changement d'itinéraire

> **Assigné à : Miantsa**

### Entités concernées

* `Demande_Changement_Itineraire`

### Fonctionnalités à implémenter

Permettre au chauffeur de signaler en cours de journée qu'il souhaite changer de zone :

* Soumettre une demande de changement avec une raison (météo, embouteillage, panne)
* Proposer un itinéraire alternatif parmi les zones existantes (dropdown)
* Ou préciser un autre lieu en texte libre si la zone n'est pas dans la liste
* L'admin valide ou refuse la demande

### Statuts possibles

* `EN_ATTENTE`
* `VALIDE`
* `REFUSE`

---

## Fichiers à créer

### DemandeChangementItineraire

* `DemandeChangementItineraire.java`
* `DemandeChangementItineraireRepository.java`
* `DemandeChangementItineraireService.java`
* `DemandeChangementItineraireController.java`

---

## Structure de l'entité

### Champs

* `id_session` → FK vers `SessionTruck`
* `id_demandeur` → FK vers `Utilisateur`
* `raison` → texte libre
* `id_itineraire_propose` → FK optionnelle vers `Itineraire`
* `autre_lieu_precise` → texte libre (si hors dropdown)
* `date_heure_demande` → LocalDateTime
* `statut_validation` → enum (`EN_ATTENTE`, `VALIDE`, `REFUSE`)

Exemple :

```java
@ManyToOne
@JoinColumn(name = "id_session")
private SessionTruck sessionTruck;

@ManyToOne
@JoinColumn(name = "id_demandeur")
private Utilisateur demandeur;

private String raison;

@ManyToOne
@JoinColumn(name = "id_itineraire_propose")
private Itineraire itinerairePropose;

private String autreLieuPrecise;

private LocalDateTime dateHeureDemande;

@Enumerated(EnumType.STRING)
private StatutValidation statutValidation;
```

---

## Endpoints à créer

* `/changement/demander` — Soumettre une demande
* `/changement/valider` — Admin valide (paramètre : `id_demande`)
* `/changement/refuser` — Admin refuse (paramètre : `id_demande`)
* `/changement/find`
* `/changement/findAll`

---

## Affichage minimal

### Côté chauffeur — Formulaire de demande

Champs :

* Session en cours (automatique)
* Raison (texte libre)
* Itinéraire proposé (dropdown des itinéraires existants)
* Autre lieu (champ texte, affiché si aucun itinéraire choisi dans le dropdown)

Bouton :

**Envoyer la demande**

---

### Côté admin — Tableau des demandes

Afficher :

* Chauffeur
* Session concernée
* Raison
* Itinéraire proposé ou autre lieu
* Date/heure
* Statut

Actions par ligne :

* Bouton **Valider**
* Bouton **Refuser**

---

## Gestion des équipements (LIFO / CUMP)

> **Assigné à : Hasina**

### Entités concernées

* `Equipement`

### Fonctionnalités à implémenter

Gérer le matériel utilisé par le food truck (emballages, ustensiles, machines) :

* Enregistrer chaque équipement avec son type et sa méthode comptable
* Gérer le stock d'équipements
* Calculer la valeur du stock selon la méthode choisie :
  * `LIFO` : le dernier entré est le premier sorti (Last In First Out)
  * `CUMP` : Coût Unitaire Moyen Pondéré — recalculé à chaque nouvel achat
* Gérer le taux de dégradation (`taux_fahasimbana`) — un équipement s'use avec le temps
* Déclencher des alertes selon le statut : `OK`, `SOLOINA` (endommagé), `TOKONY_VIDIANA` (à racheter)

### Méthodes comptables

#### LIFO

Le dernier lot acheté est le premier consommé.

Exemple :
```text
Achat 1 : 100 emballages à 50 Ar
Achat 2 : 100 emballages à 60 Ar
Utilisation de 50 → on déduit de l'Achat 2 (le plus récent)
```

#### CUMP

La valeur unitaire est recalculée à chaque nouvel achat.

Exemple :
```text
Stock actuel : 100 unités à 50 Ar = 5000 Ar
Nouvel achat : 100 unités à 60 Ar = 6000 Ar
CUMP = (5000 + 6000) / 200 = 55 Ar/unité
```

---

## Fichiers à créer

### Equipement

* `Equipement.java`
* `EquipementRepository.java`
* `EquipementService.java`
* `EquipementController.java`

---

## Structure de l'entité

### Champs

* `nom_equipement` → String
* `type_equipement` → enum (`EMBALLAGE`, `CUILLERE`, `REFRIGERATEUR`, `MACHINE`)
* `methode_comptable` → enum (`LIFO`, `CUMP`)
* `quantite_stock` → Integer
* `valeur_cump` → Double (recalculée automatiquement si méthode CUMP)
* `taux_fahasimbana` → Double (taux de dégradation)
* `statut_alerte` → enum (`OK`, `SOLOINA`, `TOKONY_VIDIANA`)

Exemple :

```java
@Enumerated(EnumType.STRING)
private TypeEquipement typeEquipement;

@Enumerated(EnumType.STRING)
private MethodeComptable methodeComptable;

private Integer quantiteStock;

private Double valeurCump;

private Double tauxFahasimbana;

@Enumerated(EnumType.STRING)
private StatutAlerte statutAlerte;
```

---

## Endpoints à créer

* `/equipement/save`
* `/equipement/update`
* `/equipement/delete`
* `/equipement/find`
* `/equipement/findAll`
* `/equipement/alertes` — retourner les équipements en statut `SOLOINA` ou `TOKONY_VIDIANA`
* `/equipement/calculerCump` — recalculer le CUMP après un nouvel achat

---

## Affichage minimal

### Tableau des équipements

Afficher :

* Nom
* Type
* Méthode comptable
* Quantité en stock
* Valeur CUMP
* Statut

Exemple :

```text
Emballage carton | EMBALLAGE    | CUMP | 500  | 55 Ar  | OK
Réfrigérateur    | REFRIGERATEUR| LIFO | 2    | 850000 | SOLOINA
Cuillère         | CUILLERE     | CUMP | 30   | 200 Ar | TOKONY_VIDIANA
```

### Alerte visuelle

* Ligne en **orange** si `SOLOINA`
* Ligne en **rouge** si `TOKONY_VIDIANA`

---

## Inventaire journalier

> **Assigné à : Nampoina**

### Entités concernées

* `Inventaire_Journalier`

### Fonctionnalités à implémenter

En fin de chaque journée de travail, permettre de faire un inventaire physique :

* Comparer ce qui est physiquement en stock avec ce que le système pense qu'il y a
* Enregistrer les écarts (pertes, surplus)
* L'inventaire peut porter sur des **ingrédients** ou des **équipements**

Exemple concret : le système dit qu'il reste 500g de fromage, mais physiquement on ne compte que 350g → écart de -150g, probablement une perte ou une erreur de saisie à corriger.

### Type d'item inventorié

* `INGREDIENT`
* `EQUIPEMENT`

---

## Fichiers à créer

### InventaireJournalier

* `InventaireJournalier.java`
* `InventaireJournalierRepository.java`
* `InventaireJournalierService.java`
* `InventaireJournalierController.java`

---

## Structure de l'entité

### Champs

* `id_session` → FK vers `SessionTruck`
* `date_inventaire` → LocalDate
* `type_item` → enum (`INGREDIENT`, `EQUIPEMENT`)
* `id_item` → Long (ID de l'ingrédient ou de l'équipement concerné)
* `quantite_physique_constatee` → Double (ce qu'on a compté physiquement)
* `quantite_theorique_systeme` → Double (ce que le système indique)
* `ecart_inventaire` → Double (calculé automatiquement : physique - théorique)

Exemple :

```java
@ManyToOne
@JoinColumn(name = "id_session")
private SessionTruck sessionTruck;

private LocalDate dateInventaire;

@Enumerated(EnumType.STRING)
private TypeItem typeItem;

private Long idItem;

private Double quantitePhysiqueConstatee;

private Double quantiteTheoriqueSysteme;

private Double ecartInventaire;
```

---

## Endpoints à créer

* `/inventaire/save`
* `/inventaire/findBySession` — tous les inventaires d'une session
* `/inventaire/findAll`
* `/inventaire/ecarts` — retourner uniquement les lignes avec un écart non nul

---

## Affichage minimal

### Formulaire de saisie inventaire

Champs :

* Session du jour (dropdown)
* Type d'item (INGREDIENT ou EQUIPEMENT)
* Item concerné (dropdown filtré selon le type choisi)
* Quantité physique constatée (input numérique)

Action :

Bouton **Enregistrer**

Effet :

* La quantité théorique est récupérée automatiquement depuis le système
* L'écart est calculé automatiquement

### Tableau des inventaires

Afficher :

* Item
* Quantité théorique
* Quantité physique
* Écart

Exemple :

```text
Fromage   | 500g | 350g | -150g ⚠️
Emballage | 200  | 210  | +10
Poulet    | 800g | 800g | 0 ✅
```

---

## Avis et retours clients

> **Assigné à : Fifa**

### Entités concernées

* `Retour_Client`

### Fonctionnalités à implémenter

Après avoir reçu sa commande, permettre au client de laisser un retour :

* Donner une **note sur 10**
* Laisser un **commentaire** (`REMARQUE_AVIS`) ou faire une **demande de produit** (`DEMANDE_PRODUIT`)
* Le système classe automatiquement l'avis en `POSITIF`, `NEGATIF` ou `NEUTRE` selon la note :
  * Note ≥ 7 → `POSITIF`
  * Note entre 4 et 6 → `NEUTRE`
  * Note ≤ 3 → `NEGATIF`
* Si plusieurs clients font la même remarque, le système marque l'avis comme **populaire** (`est_populaire = true`)

### Types de retour

* `REMARQUE_AVIS` — avis sur un produit ou le service
* `DEMANDE_PRODUIT` — demande d'un nouveau produit

---

## Fichiers à créer

### RetourClient

* `RetourClient.java`
* `RetourClientRepository.java`
* `RetourClientService.java`
* `RetourClientController.java`

---

## Structure de l'entité

### Champs

* `type_retour` → enum (`REMARQUE_AVIS`, `DEMANDE_PRODUIT`)
* `note_sur_10` → Integer (optionnel)
* `contenu_texte` → String
* `classification_sentiment` → enum (`POSITIF`, `NEGATIF`, `NEUTRE`) — calculé automatiquement
* `est_populaire` → Boolean — calculé selon la redondance des remarques
* `date_soumission` → LocalDateTime

Exemple :

```java
@Enumerated(EnumType.STRING)
private TypeRetour typeRetour;

private Integer noteSur10;

private String contenuTexte;

@Enumerated(EnumType.STRING)
private ClassificationSentiment classificationSentiment;

private Boolean estPopulaire;

private LocalDateTime dateSoumission;
```

---

## Endpoints à créer

* `/retour/save` — Soumettre un avis
* `/retour/findAll`
* `/retour/findBysentiment` — filtrer par POSITIF / NEGATIF / NEUTRE (paramètre : `sentiment`)
* `/retour/populaires` — retourner uniquement les avis marqués populaires

---

## Affichage minimal

### Côté client — Formulaire d'avis

Champs :

* Type de retour (REMARQUE_AVIS / DEMANDE_PRODUIT)
* Note sur 10 (slider ou input, optionnel)
* Commentaire (texte libre)

Bouton :

**Envoyer mon avis**

---

### Côté admin — Tableau des avis

Afficher :

* Type
* Note
* Contenu
* Sentiment (calculé)
* Populaire (oui/non)
* Date

Filtres :

* Par sentiment (POSITIF / NEGATIF / NEUTRE)
* Populaires uniquement

---

## Actions d'amélioration suite aux avis

> **Assigné à : Giovan**

### Entités concernées

* `Action_Amelioration`

### Fonctionnalités à implémenter

Une fois qu'un avis client est reçu (via `Retour_Client`), l'admin peut créer une **action corrective** à destination de l'équipe :

* Relier l'action à un avis client précis
* Rédiger une instruction claire à l'équipe
* Gérer le cas où l'action nécessite un achat

Exemple concret :
* Avis : "Le tacos est trop salé" (NEGATIF, populaire) → Action : "Réduire la quantité de sel dans la recette"
* Demande : "Ajoutez du Pakopako" (populaire) → Action : "Créer une fiche recette pour le Pakopako" + Demande d'achat envoyée à l'admin

### Statuts de demande d'achat

* `NON_APPLICABLE` — l'action ne nécessite pas d'achat
* `DEMANDE_ACHAT_ENVOYEE_A_ADMIN` — une demande d'achat a été soumise
* `APPROUVEE` — l'admin a approuvé l'achat

---

## Fichiers à créer

### ActionAmelioration

* `ActionAmelioration.java`
* `ActionAmeliorationRepository.java`
* `ActionAmeliorationService.java`
* `ActionAmeliorationController.java`

---

## Structure de l'entité

### Champs

* `id_retour_origine` → FK vers `RetourClient`
* `id_auteur_admin` → FK vers `Utilisateur`
* `instruction_employes` → String
* `statut_demande_achat` → enum (`NON_APPLICABLE`, `DEMANDE_ACHAT_ENVOYEE_A_ADMIN`, `APPROUVEE`)

Exemple :

```java
@ManyToOne
@JoinColumn(name = "id_retour_origine")
private RetourClient retourClient;

@ManyToOne
@JoinColumn(name = "id_auteur_admin")
private Utilisateur auteurAdmin;

private String instructionEmployes;

@Enumerated(EnumType.STRING)
private StatutDemandeAchat statutDemandeAchat;
```

---

## Endpoints à créer

* `/action/save` — Créer une action depuis un avis
* `/action/update` — Modifier le statut de demande d'achat
* `/action/findAll`
* `/action/findByRetour` — Toutes les actions liées à un avis donné (paramètre : `id_retour`)

---

## Affichage minimal

### Tableau des actions admin

Afficher :

* Avis d'origine (résumé)
* Instruction donnée à l'équipe
* Statut demande d'achat
* Auteur admin

Actions par ligne :

* Bouton **Approuver l'achat** (si statut = `DEMANDE_ACHAT_ENVOYEE_A_ADMIN`)

---

## Notifications plateforme

> **Assigné à : i Aina**

### Entités concernées

* `Notification_Plateforme`

### Fonctionnalités à implémenter

Permettre d'envoyer des notifications aux clients via la plateforme, dans deux cas :

* **Le truck est arrivé à un point de vente** — déclenché automatiquement à l'ouverture d'une session (`/session/ouvrir`)
* **Un nouveau produit est disponible** — déclenché manuellement par l'admin

Chaque notification a un titre, un message et est liée soit à une session (pour la localisation), soit à un produit (pour le boost).

### Types de notifications

* `ARRIVEE_POINT_DE_VENTE` — "Le truck est arrivé à Analakely !"
* `BOOST_NOUVEAU_PRODUIT` — "Découvrez notre nouveau Tteokbokki !"

---

## Fichiers à créer

### NotificationPlateforme

* `NotificationPlateforme.java`
* `NotificationPlateformeRepository.java`
* `NotificationPlateformeService.java`
* `NotificationPlateformeController.java`

---

## Structure de l'entité

### Champs

* `type_notification` → enum (`BOOST_NOUVEAU_PRODUIT`, `ARRIVEE_POINT_DE_VENTE`)
* `titre` → String
* `message` → String
* `id_produit_lie` → FK optionnelle vers `Produit`
* `id_session_liee` → FK optionnelle vers `SessionTruck`
* `date_heure_envoi` → LocalDateTime

Exemple :

```java
@Enumerated(EnumType.STRING)
private TypeNotification typeNotification;

private String titre;

private String message;

@ManyToOne
@JoinColumn(name = "id_produit_lie")
private Produit produitLie;

@ManyToOne
@JoinColumn(name = "id_session_liee")
private SessionTruck sessionLiee;

private LocalDateTime dateHeureEnvoi;
```

---

## Endpoints à créer

* `/notification/envoyer` — Créer et envoyer une notification
* `/notification/findAll`
* `/notification/findByType` — filtrer par type (paramètre : `type`)

---

## Affichage minimal

### Formulaire — Envoyer une notification

Champs :

* Type de notification (dropdown)
* Titre
* Message
* Produit lié (dropdown, visible si type = BOOST_NOUVEAU_PRODUIT)
* Session liée (dropdown, visible si type = ARRIVEE_POINT_DE_VENTE)

Bouton :

**Envoyer la notification**

### Liste des notifications envoyées

Afficher :

* Type
* Titre
* Message
* Date/heure d'envoi

---

## Génération des fiches de paie

> **Assigné à : Fabrice**

### Entités concernées

* `Fiche_Paie`

### Fonctionnalités à implémenter

Générer la fiche de paie mensuelle de chaque employé, en tenant compte de :

* Son **salaire fixe de base** (depuis `Utilisateur`)
* Ses **absences injustifiées** du mois (depuis `AbsenceConge`) → déduction
* Ses **congés payés** → pas de déduction
* Son **total d'heures supplémentaires** (sessions clôturées après 18h)
* Le **montant net final à verser**

Exemple de calcul :
```text
Salaire de base       : 600 000 Ar
Absence injustifiée   : 3 jours × 20 000 Ar = -60 000 Ar
Heures supplémentaires: +15 000 Ar
Montant net versé     : 555 000 Ar
```

---

## Fichiers à créer

### FichePaie

* `FichePaie.java`
* `FichePaieRepository.java`
* `FichePaieService.java`
* `FichePaieController.java`

---

## Structure de l'entité

### Champs

* `id_utilisateur` → FK vers `Utilisateur`
* `mois_annee` → String (ex: `"07-2026"`)
* `montant_fixe_brut` → Double
* `total_heures_supp` → Double
* `total_deductions_absences` → Double (calculé depuis `AbsenceConge`)
* `montant_net_verse` → Double (calculé automatiquement)
* `date_paiement` → LocalDate

Exemple :

```java
@ManyToOne
@JoinColumn(name = "id_utilisateur")
private Utilisateur utilisateur;

private String moisAnnee;

private Double montantFixeBrut;

private Double totalHeuresSupp;

private Double totalDeductionsAbsences;

private Double montantNetVerse;

private LocalDate datePaiement;
```

---

## Endpoints à créer

* `/paie/generer` — Générer la fiche du mois pour un employé (paramètres : `id_utilisateur`, `mois_annee`)
* `/paie/genererTous` — Générer les fiches de tout le personnel pour un mois donné
* `/paie/find`
* `/paie/findAll`
* `/paie/findByUtilisateur` — Historique des fiches d'un employé

---

## Affichage minimal

### Fiche de paie générée

Afficher :

```text
========================================
         FICHE DE PAIE — 07/2026
========================================
Employé          : Jean Rakoto
Rôle             : CHAUFFEUR
Salaire brut     : 600 000 Ar
Heures supp.     : + 15 000 Ar
Absences déduit. : - 60 000 Ar
                  ────────────
Montant net      : 555 000 Ar
Date paiement    : 31/07/2026
========================================
```

### Bouton de génération

* Sélection du mois (dropdown mois/année)
* Bouton **Générer toutes les fiches** (pour tout le personnel d'un coup)
* Bouton **Générer** sur chaque ligne employé individuellement

---

## Suite et refactorisation — Personnalisation Commande

> **Assigné à : Ismael**

### Entités concernées

* `Personnalisation_Commande` (déjà créée au Sprint 2)

### Contexte

La table `personnalisation_commande` a été créée et le script SQL a été mis en place au sprint 2. Ismael prend le relais pour **consolider et améliorer** ce module.

### Fonctionnalités à implémenter

* Vérifier que les endpoints existants fonctionnent correctement (`/personnalisation/save`, `/update`, `/delete`, `/find`, `/findAllByLigne`)
* Ajouter une **validation métier** : on ne peut pas ajouter un ingrédient qui n'existe pas dans la recette de base du produit concerné (vérification croisée avec `Recette_De_Base`)
* Ajouter un endpoint `/personnalisation/findAllByCommande` — toutes les personnalisations d'une commande entière (pas juste d'une ligne)
* Améliorer l'affichage : regrouper les personnalisations par produit dans la vue commande

### Affichage amélioré attendu

```text
Commande #12
├── Burger Classic
│   + Bacon x2
│   - Oignon x1
├── Tacos
│   + Sauce piquante x1
└── Frites
    (aucune personnalisation)
```

---

## Export CSV / PDF

> **Assigné à : Aro**

### Contexte

Cette fonctionnalité est **transversale** : elle concerne tous les modules qui produisent des listes, statistiques ou factures. C'est une règle posée dès le sprint 2 mais jamais implémentée.

### Fonctionnalités à implémenter

Ajouter la capacité d'export sur les modules suivants (un endpoint d'export par module) :

| Module | Endpoint d'export |
|---|---|
| Commandes | `/commande/export` |
| Factures | `/facture/export` |
| Statistiques | `/statistique/export` |
| Lots d'ingrédients | `/lot/export` |
| Inventaires | `/inventaire/export` |
| Absences/Congés | `/absence/export` |
| Fiches de paie | `/paie/export` |
| Avis clients | `/retour/export` |

### Formats supportés

* `CSV` — export en tableau texte brut, importable dans Excel
* `PDF` — export en document mis en forme, imprimable

### Paramètre commun

Chaque endpoint d'export prend un paramètre `format` :

```http
GET /commande/export?format=CSV
GET /commande/export?format=PDF
```

### Librairies recommandées

* **CSV** : `OpenCSV` ou `Apache Commons CSV`
* **PDF** : `iText` ou `Apache PDFBox`

### Affichage minimal

Sur chaque page listant des données, ajouter deux boutons :

* Bouton **Exporter en CSV**
* Bouton **Exporter en PDF**

---

# Récapitulatif des assignations — Sprint 3

| Tâche | Entité(s) | Assigné à | Charge |
|---|---|---|---|
| **Équipe par session** | `Equipe_Session` | Loïc | Normale |
| **Changement d'itinéraire** | `Demande_Changement_Itineraire` | Miantsa | Légère |
| **Gestion équipements** | `Equipement` | Hasina | Normale |
| **Inventaire journalier** | `Inventaire_Journalier` | Nampoina | Normale |
| **Avis clients** | `Retour_Client` | Fifa | Normale |
| **Actions d'amélioration** | `Action_Amelioration` | Giovan | Normale |
| **Notifications plateforme** | `Notification_Plateforme` | i Aina | Légère |
| **Fiches de paie** | `Fiche_Paie` | Fabrice | Normale |
| **Suite Personnalisation Commande** | `Personnalisation_Commande` | Ismael | Légère |
| **Export CSV / PDF** | Transversal | Aro | Normale |

**Règle transverse :** toute liste/statistique/facture doit pouvoir s'exporter en **CSV et PDF** — Aro centralise cette fonctionnalité mais chaque dev doit prévoir les endpoints d'export sur son propre module pour qu'Aro puisse les brancher.

**Dépendances à surveiller :**
- `Action_Amelioration` (Giovan) dépend de `Retour_Client` (Fifa) — Giovan peut commencer à coder l'entité et hardcoder un `id_retour` en attendant.
- `Fiche_Paie` (Hasina) dépend de `AbsenceConge` (Aro, sprint 2) — vérifier que les données d'absence sont bien accessibles avant de commencer les calculs.
- `Export CSV/PDF` (Aro) dépend de tous les autres modules — à démarrer en fin de sprint une fois que les listes sont disponibles.
