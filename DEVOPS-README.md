# Petclinic - Docker

Ce document explique les étapes à suivre pour configurer configuer et exécuter le projet **« petclinic microservice »** avec des containers Docker.
Pour ce faire, voici les étapes à suivre.
## 1. Prérequis avant l'exécution des images docker
### 1.1 Installation JAVA
Une version de JAVA >= 17 est requise pour l'exécution du projet.
La variable d'environnement JAVA_HOME pointant sur le répertoire contenant le sous-répertoire _"bin"_ doit être créée.
### 1.1 Variable d'environnement "PETCLINIC_HOME"
La variable d'environnement *"PETCLINIC_HOME"* est nécessaire car elle est utilisée par certains scripts. Sa valeur est le répertoire racine du projet **_"petclinic-microservices-devops"_**.

## 2. Paramétrage dans le projet de base (" petclinic-microservices-devops")

Les différents éléments ajoutés dans la version d’origine du projet sont :
### Dans le dossier "scripts" :

#### Un sous-dossier "devops" contentant les scripts:
**_run_container_app.sh_** : le script utiliser par les différentes applications pour s’exécuter dans les containers.  
Ce script peut être lancé avec deux arguments :
- **_delay_** : premier argument (entier) du script pour indiquer le temps d’attente avant le démarrage de l’application lancée par le script ;
- **_profile_** : le profile « spring boot » utilisé par l’application démarrée par le script dans le container.
Ces arguments permettent d’une part d’assurer le bon ordonnancement du démarrage des applications et d’autre part la possibilité de démarrer les applications sous différents profiles. Sans argument, les applications démarrent immédiatement avec le profile par défaut. Le script ne donne pas la possibilité d’etre exécuté le profile comme unique argument pour l’instant.
- **_build_image.sh_**: le script qui permet de générer les images Docker utilisées pour lancer les containers. Ce script doit être lancé avec un seul argument obligatoire qui estle nom de l’application pour laquelle on souhaite générer l’image Docker.
Les valeurs à utiliser pour les noms d’applications sont : _config_, _discovery_, _customers_, _vets_, _visits_, _admin_, _api-gateway_.
En sortie, le script génère une image docker avec le suffixe **_« -image »_** est concaténé avec le nom d’application fourni en argument.
**Exemple:** L'exécution du script avec la commande ci-dessous permet de générer l'image ***config-image***.
`./ build_image.sh config`

**Attention** : il est important de fournir les bons arguments au script de lancement des applications dans les container. Par exemple pour les micro services utilisant la base de donnée, l’utilisation du profile « mysql » est obligatoire.

**Remarque**: Une version temporaire avec le suffixe "2" existe pour chacun de ces deux scripts et permet de générer des images à utiliser dans la partie "Kubernetes" du projet.

### Dans le dossier "docker" :
#### Un sous-dossier "devops" contentant les fichiers :
- **_generic-dockerfile_** : le fichier permettant de fabriquer les images Docker pour chaque application ou micro service.
- **_generic-dockerfile2_**: un "dockerfile" conçu pour la génération d'images Docker pour les prochaines phases du projet (Kubernetes, ...)
-  **_docker-compose_**: Pour le lancement des containers. 
-
### Dans les application et micro services:
#### Aller dans src > main > resources pour éditer le fichier "application.yml".

**Remarque:** Ces modifications étant déjà effectuées dans l'une des branches de développement du projet, il suffit de se mettre à jour avec ces branche pour les avoir automatiquement.

## 3. Paramétrage dans le projet de configuration (" petclinic-microservices-config-devops")

### Modifier les fichier *.yml se trouvant à la racine de ce projet.

**Remarque:** Ces modifications étant déjà effectuées dans l'une des branches de développement du projet, il suffit de se mettre à jour avec ces branche pour les avoir automatiquement.

## 4. Exécution
Pour exécuter les différentes applications du projet, il faudra:
-  d'abord exécuter la base de donnée MySQL avec 
```
docker run -e MYSQL_ROOT_PASSWORD=petclinic -e MYSQL_DATABASE=petclinic -p 3306:3306 mysql:5.7.8
```
- puis lancer toutes les applications depuis le dossier _"docker/devops"_ avec la commande :
`docker-compose up`

**Remarques**: 
- La gestion du temps du temps d'attente avant le démarrage de chaque application est paramétrés dans le fichier _"docker-compose.yml"_. 
- Les profiles _spring-boot_ utilisés sont aussi paramétrés dans le _"docker-compose.yml"_.
