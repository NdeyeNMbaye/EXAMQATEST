*** Settings ***
Resource    ../Ressource/ebay_keywords.robot

*** Test Cases ***
Créer Un Fulfillment Valide
    ${fulfillmentId}=    Create Valid Shipping Fulfillment    ${VALID_ORDER_ID}    ${VALID_LINE_ITEM}
    Log    Créé avec succès: ${fulfillmentId}

Créer Un Fulfillment Invalide
    Create Invalid Shipping Fulfillment    ${VALID_ORDER_ID}

Récupérer Fulfillment Valide
    ${fulfillmentId}=    Create Valid Shipping Fulfillment    ${VALID_ORDER_ID}    ${VALID_LINE_ITEM}
    Get Shipping Fulfillment    ${VALID_ORDER_ID}    ${fulfillmentId}

Récupérer Fulfillment Invalide
    Get Shipping Fulfillment Invalid    ${VALID_ORDER_ID}

Lister Tous Les Fulfillments Valides
    Get All Shipping Fulfillments    ${VALID_ORDER_ID}

Lister Tous Les Fulfillments Invalide
    Get All Shipping Fulfillments Invalid    ${INVALID_ORDER_ID}
