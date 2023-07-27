#!/bin/bash
# Usage ./build_image NOM_IMAGE DOCKER_FILE
# Les dockerfiles se trouvent dans le dossier docker/devops
# Leur convention de nommage est APP-dockerfile - Exemple config-dockerfile
# La variable d'environnement $PETCLINIC_HOME doit etre positionné sur le
# repertoire racine du projet: petclinic-microservices-devop 
app=$1
if [ $app = 'config' ] || [ $app = 'discovery' ] || [ $app = 'admin' ]
then
    app=$app-server
fi
if [ $app = 'customers' ] || [ $app = 'vets' ] || [ $app = 'visits' ]
then
    app=$app-service
fi
# Le repertoire de base des fichiers docker (HOME_DIR/petclinic-microservices-devop/docker/devops)
dock_path="$PETCLINIC_HOME"/docker/devops
docker build / -t $1-image --build-arg BASE_DIR=$PETCLINIC_HOME \
--build-arg APP=$app -f $dock_path/generic-dockerfile
