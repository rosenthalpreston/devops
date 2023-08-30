#!/bin/bash

# Vérification des privilèges administratifs
if [ "$(id -u)" != "0" ]; then
  echo "Ce script doit être exécuté en tant qu'administrateur."
  exit 1
fi

# Connexion à GCP
echo "Veuillez vous connecter à votre compte GCP :"
gcloud auth login

# Variables de configuration
project="mon-projet"
vpcName="mon-vpc"
subnetName="mon-subnet"
subnetRange="10.0.0.0/20"

# Création du VPC
gcloud compute networks create $vpcName --project=$project --subnet-mode=custom

# Création du sous-réseau
gcloud compute networks subnets create $subnetName --network=$vpcName --range=$subnetRange --project=$project

# Affichage des informations de déploiement
echo "Le VPC a été déployé avec succès !"
echo "Nom du VPC : $vpcName"
echo "Nom du sous-réseau : $subnetName"
echo "Plage du sous-réseau : $subnetRange"

# Création d'un fichier texte récapitulatif des informations de déploiement
echo "Le VPC a été déployé avec succès !" > deployment_info_gcp.txt
echo "Nom du VPC : $vpcName" >> deployment_info_gcp.txt
echo "Nom du sous-réseau : $subnetName" >> deployment_info_gcp.txt
echo "Plage du sous-réseau : $subnetRange" >> deployment_info_gcp.txt