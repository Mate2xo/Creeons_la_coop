# Créons la Coop (CLAC) :ear_of_rice:


## Description de l'association:

Une association Picarde (Créons La Coop') est en train de monter un supermarché coopératif. Son activité sera d'acheter en gros des fruits, légumes et viandes aux producteurs locaux afin de les revendre à prix réduit à ses membres. Chacun des membres se doit de participer au moins 3 heures par mois à l'organisation.
Modèle inspiré par le modèle du supermarché coopératif Park Slope Food Coop :
https://fr.wikipedia.org/wiki/Park_Slope_Food_Coop


## Utilité de l'application:

### Pour Qui ?

- Plateforme de communication entre les membres de l'association pour faciliter l'organisation commune

### Comment ?

- liste de membres pour contacter quelqu'un rapidement en fonction de leurs groupes de travail
- liste de producteurs pour voir leurs coordonnées de contact et la liste de leurs produits
- calendrier de missions pour une organisation claire et facilitée entre les membres
- listes d'infos générales concernant l'association (compte rendus réunions plénières, etc)

### Où ?

- Régional: 60km autour de la ville de Creil

## Fonctionnalités de l'application:

- Interface Administateur via [ActiveAdmin](https://activeadmin.info/), config via `app/admin`
- CRUD sur les modèles `Productor`, `Member`, `Info`, `Mission` en fonction des `policies`

### Membres

- 3 niveaux d'authorization via un attribut `role`
- Gestion des authorizations (`policies`) via [Pundit](https://github.com/varvet/pundit)

### Produteurs

- Carte géographique en index, illustrant la position des producteurs via [Leaflet.js](https://github.com/axyjo/leaflet-rails/) et [OpenStreetMap](https://wiki.openstreetmap.org/wiki/API_v0.6)

### Missions

- Liste des missions à réaliser sous forme de calendrier récapitulatif via [FullCalendar](https://fullcalendar.io/)
- Gestion de récurrence évènementielle en s'aidant de la gem [IceCube](https://github.com/seejohnrun/ice_cube)
- Possibilité d'afficher sa participation à des missions (validations min/max en fonction du nombre de participants)

### Infos

- Interface de blog basique, cette partie sera enrichie quand les autres features seront complétées et que les retours utilisateurs seront ok.
- TODO : forum de discussion, upload de documents officiels


## Versions:

- Ruby => 2.5.1
- Rails => 5.2.3


## Démo:

https://creeons-coop-staging.herokuapp.com/

## Contributions / set up

- Lancer `$ npm install` la première fois qu'on participe au projet, pour setup le lancement automatique de Rubocop, Annotate à chaque commit, et RSpec à chaque push. CircleCi donnera également un retour une fois le code pushé.
- optionnellement, l'app est utilisable avec [Docker Compose](https://docs.docker.com/compose/install/) : `sudo docker-compose build` pour contruire l'image, puis `sudo docker-compose up` pour monter l'image et setup la DB. Le terminal de l'app dans le container est ensuite accessible avec `sudo docker-compose exec clac-app bash` (via un autre terminal local)
- Branche principale : `development`. (`master` est inutilisée actuellement). Créez votre propre branche à partir de `development`.
- Lorsqu'on résout une `issue`, Pull-Request d'une branche du même nom que l'`issue` sur la branche `development`. Tim fera la code review.
- Guard est dispo (`$ bundle exec guard`) pour le lancement automatique des tests sur les fichiers en cours de travail
