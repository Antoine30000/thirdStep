# Explications des commandes passées


### Création du network

`docker network ls | grep -q newNetwork || docker network create newNetwork`

* Vérifie si le réseau Docker nommé newNetwork existe (docker network ls liste tous les réseaux).
* Si le réseau n'est pas trouvé (grep -q newNetwork ne trouve pas de correspondance), alors docker network create newNetwork crée un nouveau réseau.

### Création d'un dossier App si il n'existe pas

`if [ ! -d "app" ]; then
  mkdir app
fi`
 
*Vérifie si le répertoire local app n'existe pas (! -d "app").
*S'il n'existe pas, crée le répertoire app avec mkdir app.

### DL de wordpress 

`wget https://wordpress.org/latest.tar.gz -O wordpress.tar.gz
tar -xzf wordpress.tar.gz -C app
`
* Extrait le contenu de wordpress.tar.gz dans le répertoire local app

### Création des Containers 

* MySQL
`docker run -d --network newNetwork --name db -e MYSQL_ROOT_PASSWORD=lesupermdp -e MYSQL_DATABASE=wordpress -v db_data:/var/lib/mysql mysql:8.0`


* PHP
`docker run -d --network newNetwork --name script -v $(pwd)/app:/app php:8.3.7-fpm bash -c "docker-php-ext-install mysqli && docker-php-ext-enable mysqli && php-fpm`

* NGINX
`docker run -p 8080:80 -d --name http -v $(pwd)/app:/app -v $(pwd)/default.conf:/etc/nginx/conf.d/default.conf --network newNetwork nginx:1.25`

`docker exec -it http nginx -s reload`


