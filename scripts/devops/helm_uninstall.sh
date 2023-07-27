#!/bin/bash
# Déinstalle une application (argument nom application) ou toutes les application (argument all)
app=$1
args=$#
if [ $args -le 1 ]
then
  echo "Exécution impossible: Le nom de l'appication et le namespace sont requis: "
  echo "  1.) Choisir un nom dans la liste { config, discovery, customers, vets, visits, admin, api-gateway } comme argument du script."
  echo "      Ou mettre 'all' pour installer toutes les applications."
  echo "  2.) Puis choisir un namespace parmi {dev, prod}."
  exit
fi
namespace=$2
if [ $args = 2 ]
then
  if [ $app = mysql ] || [ $app = config ] || [ $app = admin ] || [ $app = discovery ]
  then
    app="$app-server"
  fi
  if [ $app = customers ] || [ $app = vets ] || [ $app = visits ]
  then
    app=$app-service
  fi
fi
if [ $app = all ]
then
  echo "Desinstallation de toutes les applications ..."
  apps="config-server discovery-server customers-service vets-service visits-service admin-server api-gateway"
  for iApp in $apps
  do
    echo "Desinstallation de l'application '$iApp'"
    helm uninstall $iApp --namespace $namespace
  done
else
    echo "Desinstallation de l'application '$app'"
    helm uninstall $app --namespace $namespace
fi


