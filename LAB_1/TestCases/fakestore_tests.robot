*** Settings ***
Library           ../Ressource/mongo_library.py
Library           BuiltIn

*** Variables ***
${uri}               mongodb+srv://nmbaye:passer@cluster0.wgydv1y.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0
${db_name}           fakestoredb
${COLLECTION_NAME}   products

*** Test Cases ***

# ====== CREATE ======

Créer Un Produit Valide
    Connect To Mongo    ${uri}    ${db_name}
    ${product}=    Create Dictionary    title=Test Product    price=99.99    category=electronics    image=test.jpg    phone=770000000
    ${result}=    Insert Document    ${COLLECTION_NAME}    ${product}
    Should Not Be Empty   ${result}

Créer Produit Sans Titre (Invalide)
    Connect To Mongo    ${uri}    ${db_name}
    ${product}=    Create Dictionary    price=99.99    category=electronics    image=test.jpg    phone=770000000
    Run Keyword And Expect Error    *    Insert Document    ${COLLECTION_NAME}    ${product}

Créer Produit Prix Texte (Invalide)
    Connect To Mongo    ${uri}    ${db_name}
    ${product}=    Create Dictionary    title=Produit Test    price=invalidPrice    category=electronics    image=test.jpg    phone=770000000
    Run Keyword And Expect Error    *    Insert Document    ${COLLECTION_NAME}    ${product}

# ====== READ ======

Lire Tous Les Produits
    Connect To Mongo    ${uri}    ${db_name}
    ${result}=    Find Documents    ${COLLECTION_NAME}
    Should Be True    len(${result}) > 0

Lire Produits Avec Catégorie Vide (Invalide)
    Connect To Mongo    ${uri}    ${db_name}
    ${result}=    Find Documents    ${COLLECTION_NAME}
    ${vide}=    Evaluate    [item for item in result if 'category' in item and item['category'] == '']    modules={'result': ${result}}
    Length Should Be    ${vide}    0

Lire Produits Avec Prix Negatif (Invalide)
    Connect To Mongo    ${uri}    ${db_name}
    ${result}=    Find Documents    ${COLLECTION_NAME}
    ${negatifs}=    Evaluate    [item for item in result if 'price' in item and ((isinstance(item['price'], (int, float)) and item['price'] < 0) or (isinstance(item['price'], str) and item['price'].replace('.', '', 1).isdigit() and float(item['price']) < 0))]    modules={'result': ${result}}
    Length Should Be    ${negatifs}    0

# ====== UPDATE ======

Mettre à Jour Prix Produit Valide
    Connect To Mongo    ${uri}    ${db_name}
    ${query}=     Create Dictionary    title=Test Product
    ${update}=    Create Dictionary    price=79.99
    ${result}=    Update Document      ${COLLECTION_NAME}    ${query}    ${update}
    Should Be True    ${result} >= 1

Mettre Prix Vide (Invalide)
    Connect To Mongo    ${uri}    ${db_name}
    ${query}=     Create Dictionary    title=Test Product
    ${update}=    Create Dictionary    price=
    Run Keyword And Expect Error    *    Update Document    ${COLLECTION_NAME}    ${query}    ${update}

Mettre Prix Négatif (Invalide)
    Connect To Mongo    ${uri}    ${db_name}
    ${query}=     Create Dictionary    title=Test Product
    ${update}=    Create Dictionary    price=-100
    Run Keyword And Expect Error    *    Update Document    ${COLLECTION_NAME}    ${query}    ${update}

# ====== DELETE ======

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
