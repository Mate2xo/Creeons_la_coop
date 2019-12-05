# Créons la Coop (CLAC) :ear_of_rice:


## What's this app for:

An association ('Créons la Coop') located north of France has created a food co-op, inspired by [Park Slope Food Coop](https://fr.wikipedia.org/wiki/Park_Slope_Food_Coop). Members of this co-op need to use more efficient means of communication than just e-mail and phone.
Members buy products from productors, and sell these products to themselves. Each member must give at least 3 hours/month of their time to the association.


## Details

### Why?

- Communicate quickly, easily find relevant info, facilitate organisation

### How?

- Members list with contact infos, by workgroup
- Productors list with contact infos, products lists, quick geographic lookup
- Activities calendar: see in a glance what needs to be done in the co-op
- Forum to chat and get involved in decisions that need to be made
- General announcements and common administrative documents share
- Admin interface to manage resources in bulk

## Features

- Admin interface with [ActiveAdmin](https://activeadmin.info/), config via `app/admin`

### Members

- Authentication with [Devise](https://github.com/plataformatec/devise), member registration by invitaion only
- CRUD on `Member` model
- Privilege level set on the `role` attribute
- Authorizations `policies` managed with [Pundit](https://github.com/varvet/pundit)

### Produtors

- CRUD on `Produtor` model
- Geolocation on `index` page, coordinates auto-lookup on `Address` model instanciation, with [Leaflet.js](https://github.com/axyjo/leaflet-rails/) and [OpenStreetMap](https://wiki.openstreetmap.org/wiki/API_v0.6)

### Activities

- CRUD on `Mission` model (will probably be renamed in the future)
- Calendar on `index` page with [FullCalendar](https://fullcalendar.io/)
- Event Recurrence management with [IceCube](https://github.com/seejohnrun/ice_cube)
- Member subscription on events, with member count validations

### Share

- CRUD on `Info` model
- Basic blog interface
- Administrative documents upload set up with S3
- Forum set with [Thredded](https://github.com/thredded/thredded) engine

### Theme
- Currently using [Boomerang](https://themes.getbootstrap.com/product/boomerang-bootstrap-4-business-corporate-theme/) bootstrap theme
- If you want to use this app as it is, you must buy a Boomerang license. Otherwise, set up your own theme by deleting Boomerang resources from `/vendor` and asset pipeline. Libs and asset pipeline will be cleaned soon to facilitate this


## Versions:

- Ruby => 2.5.1
- Rails => 5.2.3


## Demo:

* https://creeons-coop-staging.herokuapp.com/
* access to mess around: `super@admin.com`, `password`.

## Contributions / set up

Any contributions would be very welcome. See projects tab if something interests you, or post an issue with a feature suggestion that you think would be useful considering the scope of this kind of app.

To get started:
- Choose one:
  * [Docker Compose](https://docs.docker.com/compose/install/) setup : `$ docker-compose up` to setup containers, DB, and launch server on `localhost:3000`. `$ docker-compose down` to unmount. You might need administrative privileges.
  * Manual setup: You need to install [PostgreSQL](https://www.postgresql.org/). Then `$ rails db:setup` to create + migrate + seed DB, then `$ rails server` launch server on `localhost:3000`.
- The main branch is `development`, start your branch from there.
- Launch `$ bundle exec guard` if you want to auto-run tests on file save.
- Launch `$ npm install` if you want to setup git hooks via `package.json`
