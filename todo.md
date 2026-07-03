# TODO Integration front du Module Ingredient

- [ok] test back
- [ok] integration temmplate pour
    - [ok] liste de /ingredients
    - [ok] ajout
    - [ok] update


# TODO Integration Front SPRINT 2 - Nampoina
## Truck

- [ok] reinit base local (script pour plus rapidite)
- [ok] insertion de donnees
- [ok] modif de application properties
- [ok] test back
    - [ok] tsy nandeha tato amiko le back fa nila nampiana guillemet le anaran le table
        ex: "\"statutDisponibilite\"" au lieu de "statutDisponibilite" fotsiny tao: equipesession, lignecomande, sessiontruck,statutDisponibilite, statut,session 
    - [ok] lasa manao reinsertion an le donnee faona ao am le base le hoe 
        spring.sql.init.mode=always ao am application properties 
        de novaiko : spring.sql.init.mode=never

- integration template 
    - ajout de CSS de l affichage minimal 
        - [ok] Formulaire : **Ouvrir une session**
        - [ok] Liste des sessions du jour


------------------------------------------------------
413 
## Alerte stock et gestion des lots d'ingrédients

- endpoints 
    - CRUD standard

    * `/lot/save`
    * `/lot/update`
    * `/lot/delete`
    * `/lot/find`
    * `/lot/findAll`

    - Endpoint utile

    * `/lot/alertes`

## Affichage minimal

- Tableau des lots
Afficher :

* Ingrédient
* Date de réception
* Date de péremption
* Quantité initiale
* Quantité restante
* Statut

Exemple :

```text
Poulet | 2026-06-20 | 2026-06-28 | 100g | 20g | ALERTE
Farine | 2026-06-21 | 2026-07-15 | 200g | 150g | OK
```

---
### Alerte visuelle

Si :

```text
quantite_restante < seuil_alerte_quantite
```

Afficher :

* Ligne en rouge
  ou
* Texte : **ALERTE**

---

## Formulaire : Nouvel arrivage

Champs :

* Choisir l'ingrédient (dropdown)
* Saisir la quantité reçue
* Saisir la date de péremption

Action :

Bouton :

**Enregistrer l'arrivage**

Effet :

* Création d'un nouveau lot
* Initialisation automatique :

  * `date_reception = aujourd'hui`
  * `quantite_restante = quantite_initiale`
