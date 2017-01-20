*** Settings ***
Documentation    API Functional Tests for Automox
Suite Setup    Create Session To Automox API Server
Suite Teardown  API Suite Cleanup
Metadata    Version    1.0
Metadata    Executed At    %{COMPUTERNAME}
Metadata    Test User       %{USERNAME}
Metadata    Operating System    %{OS}
Metadata    Processor    %{PROCESSOR_LEVEL}
Metadata    Test Framework     Robot Framework   Python
Resource    api_keywords_playAround.robot     # Contains keywords for Automox API calls

*** Test Cases ***

#Description        :: To validate creation of custom policy
#Author             :: Laxman.M
#Date               :: 19Jan2017
Create a Custom Policy
      Create Custom Policy      api-custom-policy-01   ${1}    Linux    test_code.sh    evaluation_code.sh      remediation_code.sh    ${254}    14:10    This is api-custom-policy-01
      Custom Policy should be created successfully      api-custom-policy-01   ${1}    Linux    test_code.sh    evaluation_code.sh      remediation_code.sh    ${254}    14:10    This is api-custom-policy-01
