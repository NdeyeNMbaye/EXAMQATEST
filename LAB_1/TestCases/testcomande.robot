*** Settings ***
Library    ../Ressource/mongo_library.py
Library    Collections
Library    BuiltIn

Suite Teardown    Disconnect From Mongo

*** Variables ***
${uri}         mongodb+srv://nmbaye:passer@cluster0.wgydv1y.mongodb.net/?retryWrites=true&w=majority
${db_name}     fakestoredb

*** Test Cases ***
Créer Une Commande Valide
    Connect To Mongo    ${uri}    ${db_name}
    ${produits}=    Create List    {'produitId': 1, 'quantite': 2}
    ${id}=         Creer Commande    123    ${produits}
    Should Not Be Empty    ${id}

Créer Commande Sans userId (Invalide)
    Connect To Mongo    ${uri}    ${db_name}
    ${produits}=    Create List    {'produitId': 1, 'quantite': 2}
    Run Keyword And Expect Error    *    Creer Commande    ${EMPTY}    ${produits}

Créer Commande Avec Produits Vides (Invalide)
    Connect To Mongo    ${uri}    ${db_name}
    Run Keyword And Expect Error    *    Creer Commande    123    ${EMPTY}

Lire Toutes Les Commandes
    Connect To Mongo    ${uri}    ${db_name}
    ${result}=    Lire Commandes
    Length Should Be Greater Than    ${result}    0

Lire Commandes Par Date Valide (si existe)
    Connect To Mongo    ${uri}    ${db_name}
    ${result}=    Lire Commandes Par Date    2025-08-07
    Should Be True    ${result} != []

Lire Commandes Par Date Vide (Invalide)
    Connect To Mongo    ${uri}    ${db_name}
    Run Keyword And Expect Error    *    Lire Commandes Par Date    ${EMPTY}

Mettre À Jour Quantité Produit Valide
    Connect To Mongo    ${uri}    ${db_name}
    ${produits}=    Create List    {'produitId': 1, 'quantite': 2}
    ${id}=         Creer Commande    123    ${produits}
    ${count}=      Mettre A Jour Quantite Produit    ${id}    0    5
    Should Be Equal As Integers    ${count}    1

Mettre À Jour Quantité Produit - Quantité Négative (Invalide)
    Connect To Mongo    ${uri}    ${db_name}
    ${produits}=    Create List    {'produitId': 1, 'quantite': 2}
    ${id}=         Creer Commande    123    ${produits}
    Run Keyword And Expect Error    *    Mettre A Jour Quantite Produit    ${id}    0    -1

Mettre À Jour Quantité Produit - Index Invalide (Invalide)
    Connect To Mongo    ${uri}    ${db_name}
    ${produits}=    Create List    {'produitId': 1, 'quantite': 2}
    ${id}=         Creer Commande    123    ${produits}
    Run Keyword And Expect Error    *    Mettre A Jour Quantite Produit    ${id}    10    1

Supprimer Commande Valide
    Connect To Mongo    ${uri}    ${db_name}
    ${produits}=    Create List    {'produitId': 1, 'quantite': 2}
    ${id}=         Creer Commande    123    ${produits}
    ${deleted}=    Supprimer Commande    ${id}
    Should Be Equal As Integers    ${deleted}    1

Supprimer Commande Inexistante
    Connect To Mongo    ${uri}    ${db_name}
    ${deleted}=    Supprimer Commande    000000000000000000000000
    Should Be Equal As Integers    ${deleted}    0

Supprimer Commande ID Vide (Invalide)
    Connect To Mongo    ${uri}    ${db_name}
    Run Keyword And Expect Error    *    Supprimer Commande    ${EMPTY}
