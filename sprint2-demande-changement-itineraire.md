

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

* `/changement-itineraire/demander` — Soumettre une demande
* `/changement-itineraire/valider` — Admin valide (paramètre : `id_demande`)
* `/changement-itineraire/refuser` — Admin refuse (paramètre : `id_demande`)
* `/changement-itineraire/findAll`

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
