# bind

Bind9 en docker, avec signature de zone.
Utilise debian:stable et le docker apt-proxy (cf mon git du même nom)
Usage:
 Créer un répertoire, dans lequel vous copiez les fichiers
   - Dockerfile
   - docker-compose.yml
   - restore.sh
   - zonesigner.sh
   - 01proxy
   - creation.sh
   - detect_proxy.sh

  Et dans ce même répertoire, créer deux sous répertoires
     - bind  => configuration de bind9
     - named => vos zones
 
ATTENTION: Dans les fichiers 
    - docker-compose.yml
    - creation.sh
    - restore.sh

  il faut modifier les items "exemple.org" par votre nom de fichier de zone (chez moi, il porte le nom de mon nom de domaine)

Ensuite:
  - docker build -t bind .
  - docker-compose -d up
