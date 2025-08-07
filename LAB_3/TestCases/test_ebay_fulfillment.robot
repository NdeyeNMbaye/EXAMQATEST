*** Settings ***
Library           ../Ressource/mongo_library
Library           Collections
Library           BuiltIn

*** Variables ***
${uri}               mongodb+srv://nmbaye:passer@cluster0.wgydv1y.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0
${db_name}           fakestoredb
${COLLECTION_NAME}   products

*** Test Cases ***

Connexion MongoDB
    [Documentation]    Teste la connexion MongoDB avec gestion des erreurs
    Run Keyword And Ignore Error    Connect To Mongo    ${uri}    ${db_name}
    ${connected}=    Is Connected
    Run Keyword If    '${connected}'=='False'    Fail    Échec de la connexion à MongoDB

Créer Un Produit Valide
    Connect To Mongo    ${uri}    ${db_name}
    ${connected}=    Is Connected
    Should Be True    ${connected}    msg=Connexion MongoDB non établie
    ${product}=    Create Dictionary    title=Test Product    price=99.99    category=electronics    image=test.jpg    phone=770000000
    ${result}=     Insert Document      ${COLLECTION_NAME}    ${product}
    Should Not Be Empty   ${result}

Créer Produit Sans Titre (Invalide)
    Connect To Mongo    ${uri}    ${db_name}
    ${product}=    Create Dictionary    price=99.99    category=electronics    image=test.jpg    phone=770000000
    Run Keyword And Expect Error    *    Insert Document    ${COLLECTION_NAME}    ${product}

Créer Produit Prix Texte (Invalide)
    Connect To Mongo    ${uri}    ${db_name}
    ${product}=    Create Dictionary    title=Produit Test    price=invalidPrice    category=electronics    image=test.jpg    phone=770000000
    Run Keyword And Expect Error    *    Insert Document    ${COLLECTION_NAME}    ${product}

Lire Tous Les Produits
    Connect To Mongo    ${uri}    ${db_name}
    ${result}=    Find Documents    ${COLLECTION_NAME}
    Length Should Be Greater Than    ${result}    0

Lire Produits Avec Catégorie Vide (Invalide)
    Connect To Mongo    ${uri}    ${db_name}
    ${result}=    Find Documents    ${COLLECTION_NAME}
    ${vide}=      Evaluate    [item for item in ${result} if 'category' in item and item['category'] == '']
    Length Should Be    ${vide}    0

Lire Produits Avec Prix Negatif (Invalide)
    Connect To Mongo    ${uri}    ${db_name}
    ${result}=    Find Documents    ${COLLECTION_NAME}
    ${negatifs}=  Evaluate    [item for item in ${result} if 'price' in item and item['price'] < 0]
    Length Should Be    ${negatifs}    0

Mettre à Jour Prix Produit Valide
    Connect To Mongo    ${uri}    ${db_name}
    ${query}=     Create Dictionary    title=Test Product
    ${update}=    Create Dictionary    price=79.99
    ${result}=    Update Document      ${COLLECTION_NAME}    ${query}    ${update}
    Should Be True    ${result} >= 1

Mettre Prix Vide (Invalide)
    Connect To Mongo    ${uri}    ${db_name}
    ${query}=     Create Dictionary    title=Test Product
    ${update}=    Evaluate    {"price": None}
    Run Keyword And Expect Error    *    Update Document    ${COLLECTION_NAME}    ${query}    ${update}

Mettre Prix Négatif (Invalide)
    Connect To Mongo    ${uri}    ${db_name}
    ${query}=     Create Dictionary    title=Test Product
    ${update}=    Create Dictionary    price=-100
    Run Keyword And Expect Error    *    Update Document    ${COLLECTION_NAME}    ${query}    ${update}

Supprimer Produit Valide
    Connect To Mongo    ${uri}    ${db_name}
    ${query}=    Create Dictionary    title=Test Product
    ${result}=   Delete Document       ${COLLECTION_NAME}    ${query}
    Should Be True    ${result} >= 1

Supprimer Produit Inexistant
    Connect To Mongo    ${uri}    ${db_name}
    ${query}=    Create Dictionary    title=Produit Inexistant
    ${result}=   Delete Document       ${COLLECTION_NAME}    ${query}
    Should Be Equal As Integers    ${result}    0

Supprimer Avec Champs Vide (Invalide)
    Connect To Mongo    ${uri}    ${db_name}
    ${query}=    Create Dictionary
    Run Keyword And Expect Error    *    Delete Document    ${COLLECTION_NAME}    ${query}
