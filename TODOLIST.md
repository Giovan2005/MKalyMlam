# Sprint - 0:
- Deadline: Samedi 19h 00
- Duree: 3h 

## # Hasina : Module Dashboard Statistique

### Classes a creer:
    - StatistiqueController.java:
        * Contient @Controller
        /chiffreAffaire
        /benefice
        /benefice/idItineraire
        /...

        ( a partir de commande et itineraires )

    - StatistiqueService.java:
        * Cotier metier contenant lees @Transactional

### Fonctionnalites attendues:
 ?  1- Affichage des grand indicateurs ( titres )
    2- Affichage de la chiffre d'affaire globale: 
        -> en utilisant un API 
        -> pour recuperation de cette valeur (en Ar)
    3- Benefice totaux:  ( en Ar)
    4- Affichage ( graphe )
        -> on va utiliser une graphe
        ->  avec chart deja existant 
    5- Creation des donnees de test ( a mettre en dures )

==============================================

#### 1- Chiffre d'affaire globale 1h
- globalite:
    - Total des chiffres d'affaires 
    - Liste ( consultation )
        - Chiffres d'affairese / mois 
        - chiffres d'affaires / semaine
        - chiffres d'affaires / jour
    

- controller/StatistiqueController.java
    -  @GetMapping("/chiffreAffaire")
    -  public Double chiffreAffaire() -> StatistiqueService.getChiffreAffaireGlobal():

    * Methode:  getChiffreAffaireGlobal()
    - retourne la chiffre d'affaire global 
    - Tables necessaires:
        -> itineraires
        -> produit 
        -> commande
        -> ligneCommande
        -> personnalisationCommande
        -> factureRecu
            -> modePaiement
            -> 
    - Elements necessaires:
        -> 

Commnent ?
    - produit:
        * idProduit
        * prix de base
    - commande:
        * idCommande
        * montantTotal 
        * idStatutCommande=4 ( LIVREE)

    - ligneCommande:
        * idCommande
        * idProduit
        * quantite
        * prixUniraireFacture 

    - factureRecu:
        * idCommande
        * detailsTaxesBrut


Exemple: 
* Dans table produit:
P1      4000
P2      3000

* Dans table commande: 
Commande C1: (idCommande = 1)

* Dans table ligneCommande:
1       P1       1
1       P2       2

* factureRecu:
1       10000

-------------- TERMINE


#### 2- Benefice totaux: 1h
- globalite: 
    - Benefice globale 
    - Consultation:
        - Benefice / mois
        - Benefice / semaine
        - Benefice / jour
        Benefice = Recette - Depense 

    - filtre / itineraire 


    * Methode: getBeneficeTotal():
    - retourne la benefice globale
    - Tables necessaires:
        -> depense 
        -> chiffreAffaire 
    - Elemetns necessaires:
        ->

----------------- TERMINE

    * Methode: getBeneficeByItineraire( Long idItineraire ):
    - retourne la benefice par une itineraire
    - Tables necessaires:
        -> itineraire
            * idItineraire
            "heureDebutPrevue"
            "heureFinPrevue
            "jourSemaine"
        -> sessionTruck
            * idItineraire
            * fondDecaisseCloture
            * chiffreAffaireTotal
        -> depense
    - elements necessaires:
        -> 

itineraire.idItineraire
sessionTruck.idItineraire
beneficeByIditineraire = SUM ( ChiffreAffaireTotal ) dansla table sessionTruck pour un idItineraire - SUM ( montantDepense ) pour un idSession.iditineraire

- view: itineraire + sessionTruck + depense
iditineraire --------
idSession
idTruck
nomZone ------
dateSession
fondDeCasisseOuverture
fondDeCaisseCloture
ChiffreAffaireTotal ---------
montantDepense ---------- 
dateDepense ----------

beneficeByItineraire = SUM chiffreAffaireTotal - SUM montantDepense where idItineraire = idItineraire



#### 4- Donnee a afficher pour le graphe  a creer 2h 15
- globalite:

    Methode: getDonneesGraphique():
    - retourne la liste des donnee necessaires pour l'affichage de la graphe
    - Tables necessaires:
        ->
    - Elemetns necessaires: 
        -> 


===============================================
# Partie bloques: 
    1- Calcul de chiffres d'affaires globale:
    2- Calcul de Benefice Totaux:
        - Calcul de benefice par une itineraire
    3- Pour le graphe: on va afficher quoi >
        - Statistique par rapport a quoi ?


# RESTUCTURATION DES TACHES ( Todolist - sprint2 ) by hasina

## Contexte
- Modules 'LotIngredient' et Gestion d'alerte

## Tables necessaires: 
CREATE TABLE "ingredient" (
    "idIngredient" SERIAL PRIMARY KEY,
    "nomIngredient" VARCHAR(100) NOT NULL,
    "seuilAlerteQuantite" NUMERIC(10, 2) NOT NULL,
    "uniteMesure" VARCHAR(20) NOT NULL
);

CREATE TABLE "lotIngredient" (
    "idLot" SERIAL PRIMARY KEY,
    "idIngredient" INT NOT NULL,
    "dateReception" DATE NOT NULL,
    "datePeremption" DATE NOT NULL,
    "quantiteInitiale" NUMERIC(10, 2) NOT NULL,
    "quantiteRestante" NUMERIC(10, 2) NOT NULL,
    "prixAchatUnitaire" NUMERIC(10, 2) NOT NULL,
    FOREIGN KEY ("idIngredient") REFERENCES "ingredient"("idIngredient")
);

- ingredient: misy ny nom et alertequantite 
- lotIngredient: 


# Fonctionnalites attendues
1- Pour un ingredient , on va enregistrer:  ( 10 min)
    * Information d'un nouvel ingredient
    * Date de reception ( achat de cet ingredient )
    * Date de peremption de cet ingredient
    * Quantite initale recue de cet ingredient
    ------- OK

2 - Deduction des quantites restantes au fur et a mesure des utilisations 
    ------- OK ( normalement, deja faites pour celui qui s'occupe la partie commande et produit )

3- Mise a jour dynamique de stock lors des vnetes:
    -> Ingredient dans le stock
    -> ventes -> reductions des ingredient dans un stock 
    ?????? ( le ingredient ve , ingredient le fanamboarana nale produits , + d'infos )
    ------- OK 

4- Verificaiton d'un ingredient dans un stock si sa quantite devient inferieur QuantiteMin
    ------- OK

5- Lorsque la quantite d'un ingredient est devenu < quantite minimale -> alros on retourne un ealerte 
    ------- OK

# Classes a creer: 
    LotIngredient.java:
    LotIngredientRepository.java
    LotIngreientService.java
    LotIngredientController.java

=========================================
Repository: LotIngredientRepository.java ( 10 min )---OK
=========================================
- Uitlisation de jpa <long, LotIngredient >
- contenant deja :
    * save
    * update
    * delete
    * findAll

=========================================
criteres: LotIngredient.java ( 15 min ) ---------OK
=========================================
@ManyToOne
@JoinColumn(name = "id_ingredient")
private Ingredient ingredient;
private LocalDate dateReception;
private LocalDate datePeremption;
private Double quantiteInitiale;
private Double quantiteRestante;

=========================================
Couche Service LotIngredientService.java ---------OK 
=========================================
1- creation de la methode: ( 10 min )
    -boolean verifierAlerte(Long idIngredient)
-> Recuperation de la quantite restante totale de l'ingredient
-> Comparaison avec 'seuil_alerte_quantite' deja existant dans la table 'Ingredient'
-> Retourne une alerte si le stock est insuffisant
===> si quantite_restante <= seuil_alerte_quantite
→ ALERTE
    ------- OK

2- Mise a jour dynamique du stock
    - A chaque utilisation d'un ingredient:
        -> Deduire la quantite utilisée du lot le plus ancien ( FIFO )
        -> Passer au lot suivant si le premier lot est epuisé

===============================================
Couche controler: LotIngredientController.java -------- ok ( 20 min )
===============================================
- On doit y voir les routes:
    - /lot/save
        -> creation d'une methode et appele la service qui insere le nouveau ingredient
    - /lot/update
        -> creation d'une methode et appele le service qui moifie un ingredient
    - /lot/delete
        -> _____ || _____ suppression d'un ingredient
    - /lot/find
        -> a besoin d'un IdLotIngredient, ou bien Nom de l'ingredient
        -> retourne une Liste d'un ingredient
    - /lot/findAll
        -> appelle le service et retourne la liste de l'ingredient
        ?????? ingredient retraretra ve sa hoana ingredient ray 
    - /lot/alertes
        -> retourne la liste des ingredients dont leurs quantites sont <= Quantite minimale ( dans un tableau , )



=========================================================
Affichage : Les fonctionnalites atendues pour affichages ( cote frontend )
=========================================================
1- Liste des ingredients:
    - Nom
    - Date de reception
    - Date de peremption
    - Quantite initiale
    - Quantite restante
    - Statut  ( en alerte ou pas )

2- Affichage de l'alerte sur la lsite des ingredients 
    
3- Formulaire d'insetion de nouvel arrivage ( Nouvel ingredient )
    - Liste deroulante de Ingredient
    - Quantite
    - Saisie de la date de perumption
    * Bouton Enregistrer -> dans le table LotIngredient
Nb:
    * Création d'un nouveau lot
    * Initialisation automatique :

    * `date_reception = aujourd'hui`
    * `quantite_restante = quantite_initiale`








=======
RESUME:
=======
model:
    - Ingredient.java
    - LotIngredient.java

repository:
    - LotIngredientRepository.java
    - IngredientRepository.java

service:
    - IngredientService.java
    - LotIngredientService.java


--lotIngredient.quantiteRestante ( un ingredient )= SUM( lotIngredient.quantiteRestante ) pour un ingredient 