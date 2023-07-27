#!/bin/bash
# Usage ./build_image NOM_IMAGE DOCKER_FILE
# Les dockerfiles se trouvent dans le dossier docker/devops
# Leur convention de nommage est APP-dockerfile - Exemple config-dockerfile
# La variable d'environnement $PETCLINIC_HOME doit etre positionné sur le
# repertoire racine du projet: petclinic-microservices-devop 

app=$1
tag='latest'       # Valeur par défaut
docker_id='agdgpn' # Valeur par défaut
if [ $2 ]
then
  docker_id=$2
fi
if [ $3 ]
then
  tag=$3
fi
get_suffix() {
  if [ $1 = 'config' ] || [ $1 = 'discovery' ] || [ $1 = 'admin' ]
  then
    suffix='server'
    return
  fi
  if [ $1 = 'customers' ] || [ $1 = 'vets' ] || [ $1 = 'visits' ]
  then
    suffix='service'
    return
  fi
  suffix=''
  return
}
dock_path="$PETCLINIC_HOME"/docker/devops
apps="config discovery customers vets visits admin api-gateway"
# Le repertoire de base des fichiers docker (HOME_DIR/petclinic-microservices-devop/docker/devops)
if [ $app = all ]
then
  echo "Generation des images docker de toutes les applications ..."
  for iApp in $apps
  do
    echo "  - Generation de l'image de l'application '$iApp'"
    get_suffix $iApp
    if [ $suffix ]
    then
      app_full_name=$iApp-$suffix
    else
      app_full_name=$iApp
    fi
    docker build / -t $docker_id/$iApp-image:$tag --build-arg BASE_DIR=$PETCLINIC_HOME \
    --build-arg APP=$app_full_name -f $dock_path/generic-dockerfile
  done
else
  echo "  - Generation de l'image de l'application '$app'"
  get_suffix $app
  if [ $suffix ]
  then
      app_full_name="$app-$suffix"
  else
    app_full_name=$app
  fi
  docker build / -t $docker_id/$app-image:$tag --build-arg BASE_DIR=$PETCLINIC_HOME \
  --build-arg APP=$app_full_name -f $dock_path/generic-dockerfile
fi
