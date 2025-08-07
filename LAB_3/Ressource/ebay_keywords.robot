*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    BuiltIn

Resource   ../Variables/variables.robot

*** Keywords ***
Create Valid Shipping Fulfillment
    [Arguments]    ${orderId}    ${lineItemId}
    Create Session    eBay    ${BASE_URL}
    ${body}=    Create Dictionary
    ...    shippingCarrierCode=FedEx
    ...    shippingServiceCode=FedEx_Ground
    ...    trackingNumber=123456789012
    ...    lineItems=${EMPTY}
    ${lineItem}=    Create Dictionary    lineItemId=${lineItemId}
    Append To List    ${body["lineItems"]}    ${lineItem}
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${TOKEN}
    ...    Content-Type=application/json
    ...    Accept=application/json
    ${response}=    Post Request    eBay    /sell/fulfillment/v1/order/${orderId}/shipping_fulfillment    json=${body}    headers=${headers}
    Should Be Equal As Integers    ${response.status_code}    201
    [Return]    ${response.json()["fulfillmentId"]}

Create Invalid Shipping Fulfillment
    [Arguments]    ${orderId}
    Create Session    eBay    ${BASE_URL}
    ${body}=    Create Dictionary
    ...    shippingCarrierCode=
    ...    shippingServiceCode=
    ...    trackingNumber=INVALID
    ...    lineItems=[]
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${TOKEN}
    ...    Content-Type=application/json
    ...    Accept=application/json
    ${response}=    Post Request    eBay    /sell/fulfillment/v1/order/${orderId}/shipping_fulfillment    json=${body}    headers=${headers}
    Should Not Be Equal As Integers    ${response.status_code}    201

Get Shipping Fulfillment
    [Arguments]    ${orderId}    ${fulfillmentId}
    Create Session    eBay    ${BASE_URL}
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${TOKEN}
    ...    Accept=application/json
    ${response}=    Get Request    eBay    /sell/fulfillment/v1/order/${orderId}/shipping_fulfillment/${fulfillmentId}    headers=${headers}
    Should Be Equal As Integers    ${response.status_code}    200

Get Shipping Fulfillment Invalid
    [Arguments]    ${orderId}
    Create Session    eBay    ${BASE_URL}
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${TOKEN}
    ...    Accept=application/json
    ${response}=    Get Request    eBay    /sell/fulfillment/v1/order/${orderId}/shipping_fulfillment/INVALID_ID    headers=${headers}
    Should Not Be Equal As Integers    ${response.status_code}    200

Get All Shipping Fulfillments
    [Arguments]    ${orderId}
    Create Session    eBay    ${BASE_URL}
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${TOKEN}
    ...    Accept=application/json
    ${response}=    Get Request    eBay    /sell/fulfillment/v1/order/${orderId}/shipping_fulfillment    headers=${headers}
    Should Be Equal As Integers    ${response.status_code}    200

Get All Shipping Fulfillments Invalid
    [Arguments]    ${invalidOrderId}
    Create Session    eBay    ${BASE_URL}
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${TOKEN}
    ...    Accept=application/json
    ${response}=    Get Request    eBay    /sell/fulfillment/v1/order/${invalidOrderId}/shipping_fulfillment    headers=${headers}
    Should Not Be Equal As Integers    ${response.status_code}    200
