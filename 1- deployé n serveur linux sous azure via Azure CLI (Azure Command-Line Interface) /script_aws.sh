#!/bin/bash

# Vérification des privilèges administratifs
if [ "$(id -u)" != "0" ]; then
  echo "Ce script doit être exécuté en tant qu'administrateur."
  exit 1
fi

# Connexion à AWS
echo "Veuillez vous connecter à votre compte AWS :"
read -p "Access Key ID : " accessKey
read -s -p "Secret Access Key : " secretKey
echo ""
aws configure set aws_access_key_id $accessKey
aws configure set aws_secret_access_key $secretKey

# Variables de configuration
vpcName="mon-vpc"
cidrBlock="10.0.0.0/16"
subnetName="mon-subnet"
subnetCidrBlock="10.0.1.0/24"

# Création du VPC
vpcId=$(aws ec2 create-vpc --cidr-block $cidrBlock --query 'Vpc.VpcId' --output text)

# Création du sous-réseau
subnetId=$(aws ec2 create-subnet --vpc-id $vpcId --cidr-block $subnetCidrBlock --query 'Subnet.SubnetId' --output text)

# Affichage des informations de déploiement
echo "Le VPC a été déployé avec succès !"
echo "ID du VPC : $vpcId"
echo "ID du sous-réseau : $subnetId"

# Création d'un fichier texte récapitulatif des informations de déploiement
echo "Le VPC a été déployé avec succès !" > deployment_info_aws.txt
echo "ID du VPC : $vpcId" >> deployment_info_aws.txt
echo "ID du sous-réseau : $subnetId" >> deployment_info_aws.txt
