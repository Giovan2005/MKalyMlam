- [ok] list
    * [ok] donnees
    * [ok] alertes
        - [ok] ajout du lien vers /lot/findAll dans le sidebar
        - [ok] ajout de l attribut booleen alerte  dans l entite (tsy misy hidiran ny base tyh)
        - [ok] ajout d une nouvelle fonctin getAllWithAlertStatus dans le service
        - [ok] appel de la methode getAllWithAlertStatus pour alerte dans le controller lors de findAll
        - [ok] ajout d un nouveau css specifique pour les alertes

- [ok] formulaire
    - [ok] Champs :
        * [ok] Choisir l'ingrédient (dropdown)
        * [ok] Saisir la quantité reçue
        * [ok] Saisir la date de péremption
    - [ok] modifs dans le controller pour save et update
    - [ok] ajout de methode getAllIngredients dans le service
    - [ok] modif de lien dans la liste

- [ok] plus plus
    - [ok] filtre
        - [ok] champ filtre selon le nom de l ingredeint
        - [ok] checkbox pour filtrer seulement les lots en alerte
            - modif de /lot/findAll dans le controller
            - ajout de l alerte dans la methode findByIngredientName dans le service
            - ajout de CSS pour la partie filtre dans la liste