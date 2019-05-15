# Créons la Coop (CLAC) :ear_of_rice:


## Description de l'association:

Une association Picarde (Créons La Coop') est en train de monter un supermarché coopératif. Son activité sera d'acheter en gros des fruits, légumes et viandes aux producteurs locaux afin de les revendre à prix réduit à ses membres. Chacun des membres se doit de participer au moins 3 heures par mois à l'organisation.
Modèle inspiré par le modèle du supermarché coopératif Park Slope Food Coop :
https://fr.wikipedia.org/wiki/Park_Slope_Food_Coop


## Utilité de l'application:

### Pour Qui ?

- Plateforme de communication entre les membres de l'association pour faciliter l'organisation commune

### Comment ?

- liste de membres pour contacter quelqu'un rapidement
- liste de producteurs pour voir leurs coordonnées et voir la liste de leurs produits
- calendrier de missions pour une organisation claire et facilitée entre les membres
- listes d'infos générales concernant l'association (compte rendus réunions plénières, etc)

### Où ?

- Régional: 60km autour de la ville de Creil

## Fonctionnalités de l'application:

### Membres

- 3 niveaux d'authorization via un attribut : `member`, `admin`, `super-admin`
- Gestion des authorizations via la gem [Pundit](https://github.com/varvet/pundit) (`app/policies`, tests dans `spec/policies`)
- Interface Administateur pour les `admin` et `super-admin` via la gem [ActiveAdmin](https://activeadmin.info/), config via `app/admin`
- CRUD sur les modèles `Productor`, `Member`, `Info`, `Mission` en fonction des authorizations (voir les `policies`)
- Intégration Active Storage avec AWS S3 pour upload d'avatars
- TODO -> catégorification des membres en fonction de leur groupe de travail : Communication, Approvisionnement, Informatique, Etude, Financement, Accueil. Certains membres peuvent n'avoir aucun groupe en particulier

### Produteurs

- Gmaps préconfiguré, future implémentation d'une carte récapitulative des producteurs sur `productors/index`. Les `address` peuvent être transformés en coordonnées via une méthode dans le modèle `Address`, pour une intégration plus facile de GMaps.
- Intégration Active Storage avec AWS S3 pour upload d'avatars et de catalogues
- TODO -> catégorification des producteurs : Producteurs locaux, Fournisseurs

### Missions

- Liste des missions à réaliser sous forme de calendrier récapitulatif via [FullCalendar](https://fullcalendar.io/)
- Possibilité d'afficher sa participation à des missions (validations min/max en fonction du nombre de participants)
- TODO -> gestion de récurrence évènementielle avec une entrée dans la DB pour chaque instance en s'aidant de la gem [IceCube](https://github.com/seejohnrun/ice_cube)

### Infos

- Interface de blog basique, cette partie sera enrichie quand les autres features seront complétées et que les retours utilisateurs seront ok.


## Versions:

- Ruby => 2.5.1
- Rails => 5.2.1


## Démo:

https://creeons-coop-staging.herokuapp.com/

## Workflow

- *Lancer `$ npm install` la première fois qu'on participe au projet*, pour setup le lancement automatique de Rubocop, Annotate à chaque commit, et RSpec à chaque push
- Branche principale : `development`. `master` nous servira de 'stable release' (elle n'est donc pas utilisée actuellement)
- Lorsqu'on résout une `issue`, Pull-Request d'une branche du même nom que l'`issue` sur la branche `development`. Tim fera la code review.
- Guard est dispo (`$ bundle exec guard`) pour le lancement automatique des tests sur les fichiers en cours de travail
- Ru


## La TEAM: :fire:

- Timothee Bullen
- Jérôme Delfosse
- Sonia Hemami
- Margaux Mahias

### Mentor: :+1:

- Showner (Jean-Baptiste Malhadas)
