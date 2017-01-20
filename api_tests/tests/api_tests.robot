*** Settings ***
Documentation    API Functional Tests for Automox
Suite Setup    Create Session To Automox API Server
Suite Teardown    API Suite Cleanup
Metadata    Version    1.0
Metadata    Executed At    %{COMPUTERNAME}
Metadata    Test User       %{USERNAME}
Metadata    Operating System    %{OS}
Metadata    Processor    %{PROCESSOR_LEVEL}
Metadata    Test Framework     Robot Framework   Python
Resource    ../api_objects/api_keywords.robot     # Contains keywords for Automox API calls

*** Test Cases ***
#Description        :: To validate configuration of patch policy
#Author             :: Laxman.M
#Date               :: 16Jan2017
AX.TC3 Configuration of Patch Policy
    [Documentation]     **Test Case**
    ...   User should be able to create patch Policy
    ...   1. Create a patch policy with valid inputs
    ...   2. Verify whether patch policy is created successfully
    [Tags]   api_tests

    Create Patch Policy   api-patch-policy-01   ${1}    ${false}    ${true}    ${2}    13:10    api-patch-policy-01
    Patch Policy should be created successfully   api-patch-policy-01   ${1}    ${false}    ${true}    ${2}    13:10    api-patch-policy-01

#Description        :: To validate creation of policy set
#Author             :: Laxman.M
#Date               :: 16Jan2017
AX.TC4 Create a new Policy Set
    [Documentation]     **Test Case**
    ...   User should be able to create new policy set
    ...   1. Create a new policy set with valid inputs
    ...   2. Verify whether policy set is created successfully
    [Tags]   api_tests

    Create Policy Set    api-policy-set-01    ${1}    this is api-policy-set-01    @{EMPTY}
    Policy Set should be created successfully   api-policy-set-01    ${1}    this is api-policy-set-01     @{EMPTY}

#Description        :: To validate creation of new group
#Author             :: Laxman.M
#Date               :: 16Jan2017
AX.TC5 Create a new Group
      [Documentation]     **Test Case**
      ...   User should be able to create new group
      ...   1. Create a new group with valid inputs
      ...   2. Verify whether group is created successfully
      [Tags]   api_tests

      Create Group    api-group-01   ${1}   ${1}    api-policy-set-01    600    ${true}
      Group should be created successfully   api-group-01    ${1}   ${1}    api-policy-set-01    ${600}    ${true}

#Description        :: To validate assignments of endpoints to a group
#Author             :: Laxman.M
#Date               :: 17Jan2017
AX.TC6 Assign Endpoints to a Group
      [Documentation]     **Test Case**
      ...   User should be able to assign endpoints to a group
      ...   1. Assign endpoint to a group
      ...   2. Verify whether endpoint is assigned to the group
      [Tags]   api_tests

      Assign Endpoint to Group    test   api-group-01   ${1}
      Endpoint should be assigned to group successfully     test   api-group-01   ${1}

#Description        :: To validate creation of software deployment policy
#Author             :: Laxman.M
#Date               :: 19Jan2017
AX.TC7 Create a Software Deployment Policy
      [Documentation]     **Test Case**
      ...   User should be able to create Software Deployment Policy
      ...   1. Create a software deployment policy with valid inputs
      ...   2. Verify whether software deployment policy is created successfully
      [Tags]   api_tests

      Create Software Deployment Policy   api-sw-deployment-policy-01   ${1}    Linux    ftp    dnf install ftp    ${254}    14:10    This is api-sw-deployment-policy-01
      Software Deployment Policy should be created successfully   api-sw-deployment-policy-01   ${1}    Linux    ftp    dnf install ftp    ${254}    14:10    This is api-sw-deployment-policy-01

#Description        :: To validate creation of custom policy
#Author             :: Laxman.M
#Date               :: 19Jan2017
AX.TC8 Create a Custom Policy
      Create Custom Policy      api-custom-policy-01   ${1}    Linux    test_code.sh    evaluation_code.sh      remediation_code.sh    ${254}    14:10    This is api-custom-policy-01
      Custom Policy should be created successfully      api-custom-policy-01   ${1}    Linux    test_code.sh    evaluation_code.sh      remediation_code.sh    ${254}    14:10    This is api-custom-policy-01
