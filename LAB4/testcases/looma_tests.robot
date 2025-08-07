*** Settings ***
Library    AppiumLibrary
Resource    ../resources/looma_keywords.robot



*** Test Cases ***
Test Authentification
    Démarrer l'application
    Se connecter
    Fermer l'application

# Test Création et Affichage Produit
#     Démarrer l'application
#     Se connecter
#     Créer un produit
#     Vérifier le produit
#     Fermer l'application