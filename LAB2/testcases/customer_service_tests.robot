*** Settings ***
Library    SeleniumLibrary
Resource    ../resources/customer_service_keywords.robot



*** Test Cases ***
# Test 1001 - Home Page Should Load
#     Ouvrir Navigateur Et Accéder À La Home Page
#     Vérifier Contenu Home Page
#     Fermer Navigateur


# Test 1002 - Login should succeed with valid credentials
#     Ouvrir Navigateur Et Accéder À La Home Page
#     Cliquer Sur Le Lien Login
#     Saisir Identifiants Valides
#     Cliquer Sur Le Bouton Submit
#     Fermer Navigateur


# Test 1003 - Login Should Fail With Missing Credentials
#     Ouvrir Navigateur Et Accéder À La Home Page
#     Clique sur Login
#     Laisser Champs Vides Et Soumettre
#     Fermer Navigateur


# Test 1003 - "Remember Me" Should Persist Email
#     Ouvrir Navigateur Et Accéder À La Home Page
#     Cliquer Sur Le Lien Login
#     Entrer Identifiants Valides
#     Cocher Checkbox Remember Me
#     Soumettre Formulaire De Connexion
#     Se Déconnecter
#     Cliquer Sur Le Lien Login
#     Vérifier Email Prérempli
#     Fermer Navigateur


# Test 1004 - Should be able to log out
#     Ouvrir Navigateur Et Accéder À La Home Page
#     Clique Sur Le Lien Login
#     Saisi Identifiants Valides
#     Clique Sur Le Bouton Submit
#     Déconnecter
#     Fermer Navigateur


# Test 1005 - Customers Page Should Display Multiple Customers
#     Ouvrir Navigateur Et Accéder À La Home Page
#     Cliquer Sur Le Lien Login
#     Saisir Identifiants Valides
#     Cliquer Sur Le Bouton Submit
#     Vérifier Qu’il Y A Plusieurs Clients
#     Fermer Navigateur

# 1006 - Should be able to add new customer
#     Ouvrir Navigateur Et Accéder À La Home Page
#     Cliquer Sur Le Lien Login
#     Saisir Identifiants Valides
#     Cliquer Sur Le Bouton Submit
#     Go To Add Customer Page
#     Fill Customer Form
#     Customer Should Be Added Successfully
#     Fermer Navigateur

1007 - Should be able to cancel adding new customer
    Ouvrir Navigateur Et Accéder À La Home Page
    Cliquer Sur Le Lien Login
    Saisir Identifiants Valides
    Cliquer Sur Le Bouton Submit
    Go To Add Customer Page
    Cancel Add Customer
    Added Cancel
    Fermer Navigateur