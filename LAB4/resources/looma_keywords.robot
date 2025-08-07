*** Settings ***
Library    AppiumLibrary
Variables  ../pageobject/variables.py


*** Keywords ***
Démarrer l'application
    Open Application    ${REMOTE_URL}   platformName=${PLATFORM_NAME}    deviceName=${DEVICE_NAME}    automationName=${AUTOMATION_NAME}    appPackage=${APP_PACKAGE}    appActivity=${APP_ACTIVITY}    noReset=true
    

Fermer l'application
    Close Application

Se connecter
    # Input Text    class=android.widget.EditText    johnd
    # Input Text    class=android.widget.EditText    m38rmF$
    # Click Element    accessibility_id=Se connecter
    Click Element    android=new UiSelector().className("android.widget.EditText").instance(0)
    Input Text       android=new UiSelector().className("android.widget.EditText").instance(0)    ${USERNAME}

    Click Element    android=new UiSelector().className("android.widget.EditText").instance(1)
    Input Text       android=new UiSelector().className("android.widget.EditText").instance(1)    ${PASSWORD}

    Sleep    1s
    Click Element    accessibility_id=Se connecter

