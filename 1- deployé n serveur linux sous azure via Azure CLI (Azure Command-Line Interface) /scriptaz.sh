#!/bin/bash

# Vérification des privilèges administratifs
if [ "$(id -u)" != "0" ]; then
  echo "Ce script doit être exécuté en tant qu'administrateur."
  exit 1
fi

# Connexion à Azure
echo "Veuillez vous connecter à votre compte Azure :"
read -p "Nom d'utilisateur : " username
read -s -p "Mot de passe : " password
echo ""
az login --username $username --password $password

# Variables de configuration
resourceGroupName="mon-vpc"
location="westeurope"
vnetName="mon-vnet"
subnetName="mon-subnet"
subnetPrefix="10.0.0.0/24"

# Création du groupe de ressources
az group create --name $resourceGroupName --location $location > /dev/null 2>&1

# Création du réseau virtuel
az network vnet create --name $vnetName --resource-group $resourceGroupName --location $location --address-prefixes $subnetPrefix --subnet-name $subnetName --subnet-prefix $subnetPrefix > /dev/null 2>&1

# Affichage des informations de déploiement
echo "Le VPC a été déployé avec succès !"
echo "Nom du groupe de ressources : $resourceGroupName"
echo "Emplacement : $location"
echo "Nom du réseau virtuel : $vnetName"
echo "Nom du sous-réseau : $subnetName"
echo "Préfixe du sous-réseau : $subnetPrefix"

# Création d'un fichier texte récapitulatif des informations de déploiement
echo "Le VPC a été déployé avec succès !" > deployment_info.txt
echo "Nom du groupe de ressources : $resourceGroupName" >> deployment_info.txt
echo "Emplacement : $location" >> deployment_info.txt
echo "Nom du réseau virtuel : $vnetName" >> deployment_info.txt
echo "Nom du sous-réseau : $subnetName" >> deployment_info.txt
echo "Préfixe du sous-réseau : $subnetPrefix" >> deployment_info.txt