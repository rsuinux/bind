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
 
