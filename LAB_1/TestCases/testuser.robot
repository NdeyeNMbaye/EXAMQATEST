*** Settings ***
Library           ../Ressource/mongo_library.py
Library           BuiltIn

*** Variables ***
${uri}               mongodb+srv://nmbaye:passer@cluster0.wgydv1y.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0
${db_name}           fakestoredb
${COLLECTION_NAME}   users

*** Test Cases ***

# ====== CREATE ======

Créer Utilisateur Valide
    [Documentation]    C-01 Scénario passant - création d’un utilisateur valide
    Connect To Mongo    ${uri}    ${db_name}
    ${user}=    Create Dictionary
    ...    email=john@gmail.com
    ...    username=johnd
    ...    password=hashedpassword
    ...    name={'firstname': 'John', 'lastname': 'Doe'}
    ...    address={'city': 'kilcoole', 'street': '7835 new road', 'zipcode': '12926-3874', 'geolocation': {'lat': '-37.3159', 'long': '81.1496'}}
    ...    phone=1-570-236-7033
    ${result}=    Insert Document    ${COLLECTION_NAME}    ${user}
    Should Not Be Empty   ${result}

Créer Utilisateur Sans Email (Invalide)
    [Documentation]    C-02 Scénario non passant - utilisateur sans email => erreur
    Connect To Mongo    ${uri}    ${db_name}
    ${user}=    Create Dictionary
    ...    username=johnd
    ...    password=hashedpassword
    Run Keyword And Expect Error    *    Insert Document    ${COLLECTION_NAME}    ${user}

Créer Utilisateur Email Vide (Invalide)
    [Documentation]    C-03 Scénario non passant - utilisateur avec email vide => erreur
    Connect To Mongo    ${uri}    ${db_name}
    ${user}=    Create Dictionary
    ...    email=
    ...    username=johnd
    ...    password=hashedpassword
    Run Keyword And Expect Error    *    Insert Document    ${COLLECTION_NAME}    ${user}

# ====== READ ======

Lire Tous Les Utilisateurs
    [Documentation]    R-01 Scénario passant - lire tous les utilisateurs (doit retourner > 0)
    Connect To Mongo    ${uri}    ${db_name}
    ${result}=    Find Documents    ${COLLECTION_NAME}
    Should Be True    len(${result}) > 0

Lire Utilisateurs Email Vide (Invalide)
    [Documentation]    R-02 Scénario non passant - aucun utilisateur ne doit avoir un email vide
    Connect To Mongo    ${uri}    ${db_name}
    ${result}=    Find Documents    ${COLLECTION_NAME}
    ${vide}=      Evaluate    [item for item in ${result} if 'email' in item and item['email'] == '']
    Length Should Be    ${vide}    0

Lire Utilisateurs Username Vide (Invalide)
    [Documentation]    R-03 Scénario non passant - aucun utilisateur ne doit avoir un username vide
    Connect To Mongo    ${uri}    ${db_name}
    ${result}=    Find Documents    ${COLLECTION_NAME}
    ${vide}=      Evaluate    [item for item in ${result} if 'username' in item and item['username'] == '']
    Length Should Be    ${vide}    0

# ====== UPDATE ======

Mettre à Jour Téléphone Utilisateur Valide
    [Documentation]    U-01 Scénario passant - mise à jour téléphone valide
    Connect To Mongo    ${uri}    ${db_name}
    ${query}=     Create Dictionary    email=john@gmail.com
    ${update}=    Create Dictionary    phone=1234567890
    ${result}=    Update Document      ${COLLECTION_NAME}    ${query}    ${update}
    Should Be True    ${result} >= 1

Mettre Téléphone Vide (Invalide)
    [Documentation]    U-02 Scénario non passant - mise à jour avec téléphone vide => erreur
    Connect To Mongo    ${uri}    ${db_name}
    ${query}=     Create Dictionary    email=john@gmail.com
    ${update}=    Create Dictionary    phone=
    Run Keyword And Expect Error    *    Update Document    ${COLLECTION_NAME}    ${query}    ${update}

Mettre à Jour Utilisateur Inexistant (Invalide)
    [Documentation]    U-03 Scénario non passant - mise à jour d’un utilisateur inexistant
    Connect To Mongo    ${uri}    ${db_name}
    ${query}=     Create Dictionary    email=nonexistent@gmail.com
    ${update}=    Create Dictionary    phone=1234567890
    ${result}=    Update Document      ${COLLECTION_NAME}    ${query}    ${update}
    Should Be Equal As Integers    ${result}    0

# ====== DELETE ======

Supprimer Utilisateur Valide
    [Documentation]    D-01 Scénario passant - suppression d’un utilisateur existant
    Connect To Mongo    ${uri}    ${db_name}
    ${query}=    Create Dictionary    email=john@gmail.com
    ${result}=   Delete Document       ${COLLECTION_NAME}    ${query}
    Should Be True    ${result} >= 1

Supprimer Utilisateur Inexistant
    [Documentation]    D-02 Scénario non passant - suppression utilisateur inexistant => 0 suppression
    Connect To Mongo    ${uri}    ${db_name}
    ${query}=    Create Dictionary    email=nonexistent@gmail.com
    ${result}=   Delete Document       ${COLLECTION_NAME}    ${query}
    Should Be Equal As Integers    ${result}    0

Supprimer Avec Champs Vide (Invalide)
    [Documentation]    D-03 Scénario non passant - suppression avec requête vide => erreur
    Connect To Mongo    ${uri}    ${db_name}
    ${query}=    Create Dictionary
    Run Keyword And Expect Error    *    Delete Document    ${COLLECTION_NAME}    ${query}
