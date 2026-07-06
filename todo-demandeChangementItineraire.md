# Demande de changement d'itineraire

## Fichiers à créer
* `DemandeChangementItineraire.java`
* `DemandeChangementItineraireRepository.java`
* `DemandeChangementItineraireService.java`
* `DemandeChangementItineraireController.java`

* `StatutValidation.java`
* `StatutValidationRepository.java`
* `StatutValidationService.java`
* `StatutValidationController.java`

## Fonctionnalites

### Soumettre une demande de changement avec une raison

* Soumettre une demande de changement avec une raison (météo, embouteillage, panne)
* Proposer un itinéraire alternatif parmi les zones existantes (dropdown)
* Ou préciser un autre lieu en texte libre si la zone n'est pas dans la liste


#### Entity [ok]
* DemandeChangementItineraire
* StatutValidation


#### Repository [ok]
* DemandeChangementItineraireRepository
* StatutValidationRepository

#### Service : DemandeChangementItineraireService [ok]
* Fonction demanderChangementItineraire DemandeChangementItineraire:
    * appeler save de DemandeChangementItineraireRepository


#### Controller : DemandeChangementItineraireController
**Endpoint:** `/changement-itineraire/demander`
* Fonction demander DemandeChangementItineraire:
    * appeler demanderChangementItineraire de DemandeChangementItineraireService


#### Affichage

##### Formulaire de demande
Champs:
* Session dropdown
* Utilisateur dropdown
* raison text
* Itineraire dropdown a part itineraire du session
* autre lieu text
