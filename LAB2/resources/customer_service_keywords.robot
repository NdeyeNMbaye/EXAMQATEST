*** Settings ***
Library    SeleniumLibrary
Variables  ../pageobject/variables.py


*** Keywords ***
Ouvrir Navigateur Et Accéder À La Home Page
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout    10s
    Set Selenium Speed      0.5s

Vérifier Contenu Home Page
    Wait Until Page Contains    Customer Service

### Teste 2

Cliquer Sur Le Lien Login
    Click Link   xpath=/html/body/nav/ul/li/a 
    Wait Until Page Contains    Login
   

Saisir Identifiants Valides
    Input Text    id=email-id    ${USERNAME}
    Input Text    id=password    ${PASSWORD}

Cliquer Sur Le Bouton Submit
    Click Button    id=submit-id
    Wait Until Page Contains    Our Happy Customers


### Test 3

Clique sur Login
    Click Link    xpath=/html/body/nav/ul/li/a
    Wait Until Page Contains    Login
    

Laisser Champs Vides Et Soumettre
    Click Button    id=submit-id
    Wait Until Page Contains    Login


### Test 3 Remember

Entrer Identifiants Valides
    Click Link    xpath=/html/body/nav/ul/li/a
    Wait Until Page Contains    Login

    Input Text    id=email-id    ${USERNAME}
    Input Text    id=password    ${PASSWORD}

Cocher Checkbox Remember Me
    Select Checkbox    id=remember

Soumettre Formulaire De Connexion
    Click Button    id=submit-id
    Wait Until Page Contains    Our Happy Customers

Se Déconnecter
    Click Link    xpath=/html/body/nav/ul/li/a
    Wait Until Page Contains    Signed Out

Vérifier Email Prérempli
    Click Link    xpath=/html/body/nav/ul/li/a
    Sleep    2s
    Element Attribute Value Should Be    id=email-id    value    ${USERNAME}



### Test 4

Clique Sur Le Lien Login
    Click Link   xpath=/html/body/nav/ul/li/a 
    Wait Until Page Contains    Login

Saisi Identifiants Valides
    Input Text    id=email-id    ${USERNAME}
    Input Text    id=password    ${PASSWORD}

Clique Sur Le Bouton Submit
    Click Button    id=submit-id
    Wait Until Page Contains    Our Happy Customers

Déconnecter
    Click Link    xpath=/html/body/nav/ul/li/a
    Wait Until Page Contains    Signed Out


### Test 5

Vérifier Qu’il Y A Plusieurs Clients
    ${row_count}=    Get Element Count    xpath=//*[@id="customers"]/tbody/tr
    Should Be True    ${row_count} > 1


### Test 6

Go To Add Customer Page
    Click Element    id=new-customer

Fill Customer Form
    Input Text    id=EmailAddress    ${EMAIL}
    Sleep    2s
    Input Text    id=FirstName    ${FIRST_NAME}
    Sleep    2s
    Input Text    id=LastName    ${LAST_NAME}
    Sleep    2s
    Input Text    id=City    ${CITY}
    Sleep    2s
    Select From List By Value    id=StateOrRegion    ${STATE}
    Sleep    2s
    Select Radio Button    gender    ${GENDER}
    Sleep    2s
    Select Checkbox    name=promos-name
    Sleep    2s
    Click Button    xpath=//*[@id="loginform"]/div/div/div/div/form/button

Customer Should Be Added Successfully
    Wait Until Page Contains    Our Happy Customers

### Test 7
    
Cancel Add Customer
    Click Element    xpath=//*[@id="loginform"]/div/div/div/div/form/a
Added Cancel
    Wait Until Page Contains    Our Happy Customers

Fermer Navigateur
    Close Browser


