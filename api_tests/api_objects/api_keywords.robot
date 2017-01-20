*** Settings ***
Documentation     A resource file with reusable keywords for Automox API
Resource          ../config/config.robot   # Contains system configuration properties
Library  Collections
Library  OperatingSystem
Library  ../utilities/RequestsKeywords.py   # Library for making REST API calls
Library  ../utilities/HelperKeywords.py      # Library for performing API level validations

*** Keywords ***

#Description        :: This keyword will create a patch policy with provided inputs
#Author             :: Laxman.M
#Date               :: 14Jan2017
#Input Parameters   :: name - string - Name of the Patch Policy - Default[api-patch-policy]
#                      organization_id - integer - Organization Id for which patch policy should be created - Default[1]
#                      auto_patch - boolean - Automatic Patch should be applied or not - Default[true]
#                      auto_reboot - boolean - Automatic Reboot should be applied or not - Default[false]
#                      schedule_days - int - Patch Policy Schedue Days - Default[0]
#                      schedule_time - string - Patch Policy Schedule Time - Default[10:00]
#                      notes - string - comments - Default[this is test policy]
#Output Parameters  :: None
#Pending Impl       :: NA
Create Patch Policy
      [Arguments]   ${name}=api-patch-policy  ${organization_id}=${1}    ${auto_patch}=${true}  ${auto_reboot}=${false}   ${schedule_days}=${0}   ${schedule_time}=10:00  ${notes}=this is test policy
      &{configuration_dict}=    Create Dictionary    auto_patch=${auto_patch}    auto_reboot=${auto_reboot}
      &{patch_policy_dict}=     Create Dictionary   name=${name}   policy_type_name=patch  organization_id=${organization_id}   configuration=${configuration_dict}  schedule_days=${schedule_days}   schedule_time=${schedule_time}   notes=${notes}
      ${json_string}=    Evaluate    json.dumps(${patch_policy_dict})    json
      ${params}=   Create Dictionary   o=${organization_id}
      Log   ${json_string}
      ${resp}=  Post Request  automoxapi  /policies  data=${json_string}  params=${params}
      Log  ${resp.content}

#Description        :: This keyword will verify whether patch policy is created successfully
#Author             :: Laxman.M
#Date               :: 16Jan2017
#Input Parameters   :: name - string - Name of the Patch Policy
#                      organization_id - integer - Organization Id for which patch policy should be created
#                      auto_patch - boolean - Automatic Patch should be applied or not
#                      auto_reboot - boolean - Automatic Reboot should be applied or not
#                      schedule_days - int - Patch Policy Schedue Days
#                      schedule_time - string - Patch Policy Schedule Time
#                      notes - string - comments
#Output Parameters  :: None
#Pending Impl       :: NA
Patch Policy should be created successfully
      [Arguments]   ${name}  ${organization_id}    ${auto_patch}  ${auto_reboot}   ${schedule_days}   ${schedule_time}  ${notes}
      &{configuration_dict}=    Create Dictionary    auto_patch=${auto_patch}    auto_reboot=${auto_reboot}
      &{patch_policy_dict}=     Create Dictionary   name=${name}   policy_type_name=patch  organization_id=${organization_id}   configuration=${configuration_dict}  schedule_days=${schedule_days}   schedule_time=${schedule_time}   notes=${notes}
      ${json_string}=    Evaluate    json.dumps(${patch_policy_dict})    json
      ${resp}=  Get Request  automoxapi  /policies
      Should Be Equal As Strings  ${resp.status_code}  200
      @{resp_json}=  Set Variable   ${resp.json()}
      Policy List Should Contain Policy Details   ${resp_json}    ${json_string}

#Description        :: This keyword will create a policy set with provided inputs
#Author             :: Laxman.M
#Date               :: 16Jan2017
#Input Parameters   :: name - string - Name of the Policy Set - Default[api-policy-set]
#                      organization_id - integer - Organization Id for which policy set should be created - Default[1]
#                      notes - string - Comments - Default[this is test-policy-set]
#                      policies - string - Policy Names seperated by comma - Default[Empty]
#Output Parameters  :: None
#Pending Impl       :: Comma seperated policy name inputs is not implemented. Currently only supports empty policies
Create Policy Set
      [Arguments]   ${name}=api-policy-set  ${organization_id}=${1}    ${notes}=this is test policy    ${policies}=@{EMPTY}
      &{policy_set_dict}=     Create Dictionary   name=${name}   organization_id=${organization_id}   notes=${notes}    policies=${policies}
      ${json_string}=    Evaluate    json.dumps(${policy_set_dict})    json
      ${params}=   Create Dictionary   o=${organization_id}
      Log   ${json_string}
      ${resp}=  Post Request  automoxapi  /policysets  data=${json_string}  params=${params}
      Log  ${resp.content}
      Should Be Equal As Strings  ${resp.status_code}  201

#Description        :: This keyword will verify whether policy set is created successfully
#Author             :: Laxman.M
#Date               :: 16Jan2017
#Input Parameters   :: name - string - Name of the Policy Set
#                      organization_id - integer - Organization Id for which policy set should be created
#                      notes - string - Comments
#                      policies - string - Policy Names seperated by comma
#Output Parameters  :: None
#Pending Impl       :: NA
Policy Set should be created successfully
      [Arguments]   ${name}  ${organization_id}   ${notes}   ${policies}=@{EMPTY}
      &{policy_set_dict}=     Create Dictionary   name=${name}   organization_id=${organization_id}   notes=${notes}    policies=${policies}
      ${json_string}=    Evaluate    json.dumps(${policy_set_dict})    json
      ${resp}=  Get Request  automoxapi  /policysets
      Should Be Equal As Strings  ${resp.status_code}  200
      @{resp_json}=  Set Variable   ${resp.json()}
      Log   ${resp_json}
      Policy Set List Should Contain Policy Set Details   ${resp_json}    ${json_string}

#Description        :: This keyword will create a group with provided inputs
#Author             :: Laxman.M
#Date               :: 16Jan2017
#Input Parameters   :: name - string - Name of the Group - Default[api-group]
#                      organization_id - integer - Organization Id for which group should be created - Default[1]
#                      parent_server_group_id - integer - Parent Server Group ID - Default[1]
#                      policy_set_name - string - Name of the policy set to assign to group - Default[api-policy-set]
#                      refresh_interval - integer - Interval for the endpoint to refresh automatically in mins - Default[480]
#                      override - boolean - Enable Custom Settings if true - Default[true]
#Output Parameters  :: None
#Pending Impl       :: NA
Create Group
      [Arguments]   ${name}=api-group  ${organization_id}=${1}    ${parent_server_group_id}=${1}    ${policy_set_name}=api-policy-set    ${refresh_interval}=${480}   ${override}=${true}
      ${resp}=  Get Request  automoxapi  /policysets
      @{resp_json}=  Set Variable   ${resp.json()}
      ${policy_set_id}=    Get Policy Set ID    ${resp_json}    ${policy_set_name}
      Log   ${policy_set_id}
      ${policy_set_id_int}=   Convert To Integer    ${policy_set_id}
      &{group_dict}=     Create Dictionary   name=${name}   parent_server_group_id=${parent_server_group_id}   policy_set_id=${policy_set_id}    refresh_interval=${refresh_interval}    override=${override}
      ${json_string}=    Evaluate    json.dumps(${group_dict})    json
      ${params}=   Create Dictionary   o=${organization_id}
      Log   ${json_string}
      ${resp}=  Post Request  automoxapi  /servergroups  data=${json_string}  params=${params}
      Log  ${resp.content}
      Should Be Equal As Strings  ${resp.status_code}  201

#Description        :: This keyword will verify whether group is created successfully
#Author             :: Laxman.M
#Date               :: 16Jan2017
#Input Parameters   :: name - string - Name of the Group
#                      organization_id - integer - Organization Id for which group should be created
#                      parent_server_group_id - integer - Parent Server Group ID
#                      policy_set_name - string - Name of the policy set to assign to group
#                      refresh_interval - integer - Interval for the endpoint to refresh automatically in mins
#                      override - boolean - Enable Custom Settings if true
#Output Parameters  :: None
#Pending Impl       :: NA
Group should be created successfully
      [Arguments]   ${name}=api-group  ${organization_id}=${1}    ${parent_server_group_id}=${1}    ${policy_set_name}=api-policy-set    ${refresh_interval}=${480}   ${override}=${true}
      ${resp}=  Get Request  automoxapi  /policysets
      @{resp_json}=  Set Variable   ${resp.json()}
      ${policy_set_id}=    Get Policy Set ID    ${resp_json}    ${policy_set_name}
      Log   ${policy_set_id}
      ${policy_set_id_int}=   Convert To Integer    ${policy_set_id}
      &{group_dict}=     Create Dictionary   name=${name}  parent_server_group_id=${parent_server_group_id}    policy_set_id=${policy_set_id_int}    refresh_interval=${refresh_interval}    override=${override}
      ${json_string}=    Evaluate    json.dumps(${group_dict})    json
      Log    ${json_string}
      ${resp}=  Get Request  automoxapi  /servergroups
      Should Be Equal As Strings  ${resp.status_code}  200
      @{resp_json}=  Set Variable   ${resp.json()}
      Log   ${resp_json}
      Group List Should Contain Group Details   ${resp_json}    ${json_string}

#Description        :: This keyword will assign endpoint to a group as provided
#Author             :: Laxman.M
#Date               :: 17Jan2017
#Input Parameters   :: endpoint_name - string - Name of the Endpoint - Default[test]
#                      group_name - string - Name of the group to which endpoint should be assigned - Default[test-group]
#                      organization_id - integer - Organization Id for which group should be created - Default[1]
#Output Parameters  :: None
#Pending Impl       :: Need to implement multiple endpoints assignment to a group
Assign Endpoint to Group
      [Arguments]   ${endpoint_name}=test  ${group_name}=test-group   ${organization_id}=${1}
      ${resp}=  Get Request  automoxapi  /servers
      @{resp_json}=  Set Variable   ${resp.json()}
      ${endpoint_id}=    Get Endpoint ID    ${resp_json}    ${endpoint_name}
      Log   ${endpoint_id}
      ${endpoint_id_int}=   Convert To Integer    ${endpoint_id}
      ${endpoint_json}=   Get Endpoint Json   ${resp_json}   ${endpoint_id_int}

      ${resp}=  Get Request  automoxapi  /servergroups
      @{resp_json}=  Set Variable   ${resp.json()}
      ${group_id}=    Get Group ID    ${resp_json}    ${group_name}
      Log   ${group_id}
      ${group_id_int}=   Convert To Integer    ${group_id}

      Set To Dictionary    ${endpoint_json}    server_group_id     ${group_id_int}
      Log   ${endpoint_json}
      ${endpoint_json_string}=    Evaluate    json.dumps(${endpoint_json})    json

      ${params}=   Create Dictionary   o=${organization_id}
      ${resp}=  Put Request  automoxapi  /servers/${endpoint_id_int}  data=${endpoint_json_string}  params=${params}
      Log  ${resp.content}
      Should Be Equal As Strings  ${resp.status_code}  204

#Description        :: This keyword will verify whether endpoint is assigned to group successfullys
#Author             :: Laxman.M
#Date               :: 17Jan2017
#Input Parameters   :: endpoint_name - string - Name of the Endpoint
#                      group_name - string - Name of the group to which endpoint should be assigned
#                      organization_id - integer - Organization Id for which group should be created
#Output Parameters  :: None
#Pending Impl       :: NA
Endpoint Should be assigned to Group successfully
      [Arguments]   ${endpoint_name}=test  ${group_name}=test-group   ${organization_id}=${1}
      ${resp}=  Get Request  automoxapi  /servers
      @{resp_json}=  Set Variable   ${resp.json()}
      ${endpoint_id}=    Get Endpoint ID    ${resp_json}    ${endpoint_name}
      Log   ${endpoint_id}
      ${endpoint_id_int}=   Convert To Integer    ${endpoint_id}
      ${endpoint_json}=   Get Endpoint Json   ${resp_json}   ${endpoint_id_int}

      ${resp}=  Get Request  automoxapi  /servergroups
      @{resp_json}=  Set Variable   ${resp.json()}
      ${group_id}=    Get Group ID    ${resp_json}    ${group_name}
      Log   ${group_id}
      ${group_id_int}=   Convert To Integer    ${group_id}

      Dictionary Should Contain Item    ${endpoint_json}    server_group_id    ${group_id_int}    Endpoint is not assigned to Group

#Description        :: This keyword will create a software deployment policy with provided inputs
#Author             :: Laxman.M
#Date               :: 17Jan2017
#Input Parameters   :: name - string - Name of the Software Deployment Policy - Default[api-sw-deployment-policy]
#                      organization_id - integer - Organization Id for which patch policy should be created - Default[1]
#                      os_family - string - Name of the OS Family - Default[Linux]
#                      package_name - string - Name of the package - Default[ftp]
#                      installation_code - string - Installation Code - Default[dnf install ftp]
#                      schedule_days - int - Software Deployment Policy Schedue Days - Default[0]
#                      schedule_time - string - Software Deployment Policy Schedule Time - Default[10:00]
#                      notes - string - comments - Default[this is test policy]
#Output Parameters  :: None
#Pending Impl       :: NA
Create Software Deployment Policy
      [Arguments]   ${name}=api-sw-deployment-policy  ${organization_id}=${1}    ${os_family}=Linux  ${package_name}=ftp    ${installation_code}=dnf install ftp   ${schedule_days}=${0}   ${schedule_time}=10:00  ${notes}=this is test policy
      &{configuration_dict}=    Create Dictionary    os_family=${os_family}    package_name=${package_name}    installation_code=${installation_code}
      &{sw_deployment_policy_dict}=     Create Dictionary   name=${name}   policy_type_name=required_software  organization_id=${organization_id}   configuration=${configuration_dict}  schedule_days=${schedule_days}   schedule_time=${schedule_time}   notes=${notes}
      ${json_string}=    Evaluate    json.dumps(${sw_deployment_policy_dict})    json
      ${params}=   Create Dictionary   o=${organization_id}
      Log   ${json_string}
      ${resp}=  Post Request  automoxapi  /policies  data=${json_string}  params=${params}
      Log  ${resp.content}
      Should Be Equal As Strings  ${resp.status_code}  201

#Description        :: This keyword will verify whether software deployment policy is created successfully
#Author             :: Laxman.M
#Date               :: 17Jan2017
#Input Parameters   :: name - string - Name of the Software Deployment Policy
#                      organization_id - integer - Organization Id for which patch policy should be created
#                      os_family - string - Name of the OS Family
#                      package_name - string - Name of the package
#                      installation_code - string - Installation Code
#                      schedule_days - int - Software Deployment Policy Schedue Days
#                      schedule_time - string - Software Deployment Policy Schedule Time
#                      notes - string - comments
#Output Parameters  :: None
#Pending Impl       :: NA
Software Deployment Policy should be created successfully
      [Arguments]   ${name}  ${organization_id}    ${os_family}  ${package_name}    ${installation_code}   ${schedule_days}   ${schedule_time}  ${notes}
      &{configuration_dict}=    Create Dictionary    os_family=${os_family}    package_name=${package_name}    installation_code=${installation_code}
      &{sw_deployment_policy_dict}=     Create Dictionary   name=${name}   policy_type_name=required_software  organization_id=${organization_id}   configuration=${configuration_dict}  schedule_days=${schedule_days}   schedule_time=${schedule_time}   notes=${notes}
      ${json_string}=    Evaluate    json.dumps(${sw_deployment_policy_dict})    json
      ${resp}=  Get Request  automoxapi  /policies
      Should Be Equal As Strings  ${resp.status_code}  200
      @{resp_json}=  Set Variable   ${resp.json()}
      Policy List Should Contain Policy Details   ${resp_json}    ${json_string}

#Description        :: This keyword will create a custom policy with provided inputs
#Author             :: Laxman.M
#Date               :: 19Jan2017
#Input Parameters   :: name - string - Name of the Custom Policy - Default[api-custom-policy]
#                      organization_id - integer - Organization Id for which custom policy should be created - Default[1]
#                      os_family - string - Name of the OS Family - Default[Linux]
#                      test_code - string - Test Code
#                      evaluation_code - string - Evaluation Code
#                      remediation_code - string - Remediation Code
#                      schedule_days - int - Software Deployment Policy Schedue Days - Default[0]
#                      schedule_time - string - Software Deployment Policy Schedule Time - Default[10:00]
#                      notes - string - comments - Default[this is test policy]
#Output Parameters  :: None
#Pending Impl       :: NA
Create Custom Policy
      [Arguments]   ${name}=api-custom-policy  ${organization_id}=${1}    ${os_family}=Linux  ${test_code_path}=test_code.sh   ${evaluation_code_path}=evaluation_code.sh    ${remediation_code_path}=remediation_code.sh   ${schedule_days}=${0}   ${schedule_time}=10:00  ${notes}=this is test policy
      ${test_code}=         Get File       resources/custom_policy/linux/${test_code_path}
      ${evaluation_code}=     Get File     resources/custom_policy/linux/${evaluation_code_path}
      ${remediation_code}=    Get File    resources/custom_policy/linux/${remediation_code_path}
      &{configuration_dict}=    Create Dictionary    os_family=${os_family}    test_code=${test_code}    evaluation_code=${evaluation_code}       remediation_code=${remediation_code}
      &{custom_policy_dict}=     Create Dictionary   name=${name}   policy_type_name=custom  organization_id=${organization_id}   configuration=${configuration_dict}  schedule_days=${schedule_days}   schedule_time=${schedule_time}   notes=${notes}
      ${json_string}=    Evaluate    json.dumps(${custom_policy_dict})    json
      ${params}=   Create Dictionary   o=${organization_id}
      Log   ${json_string}
      ${resp}=  Post Request  automoxapi  /policies  data=${json_string}  params=${params}
      Log  ${resp.content}
      Should Be Equal As Strings  ${resp.status_code}  201

#Description        :: This keyword will verify whether custom policy is created successfully
#Author             :: Laxman.M
#Date               :: 19Jan2017
#Input Parameters   :: name - string - Name of the Custom Policy
#                      organization_id - integer - Organization Id for which custom policy should be created
#                      os_family - string - Name of the OS Family
#                      test_code - string - Test Code
#                      evaluation_code - string - Evaluation Code
#                      remediation_code - string - Remediation Code
#                      schedule_days - int - Software Deployment Policy Schedue Days
#                      schedule_time - string - Software Deployment Policy Schedule Time
#                      notes - string - comments
#Output Parameters  :: None
#Pending Impl       :: NA
Custom Policy should be created successfully
      [Arguments]   ${name}=api-custom-policy  ${organization_id}=${1}    ${os_family}=Linux  ${test_code_path}=test_code.sh   ${evaluation_code_path}=evaluation_code.sh    ${remediation_code_path}=remediation_code.sh   ${schedule_days}=${0}   ${schedule_time}=10:00  ${notes}=this is test policy
      ${test_code}=         Get File       resources/custom_policy/linux/${test_code_path}
      ${evaluation_code}=     Get File     resources/custom_policy/linux/${evaluation_code_path}
      ${remediation_code}=    Get File    resources/custom_policy/linux/${remediation_code_path}
      &{configuration_dict}=    Create Dictionary    os_family=${os_family}    test_code=${test_code}    evaluation_code=${evaluation_code}       remediation_code=${remediation_code}
      &{custom_policy_dict}=     Create Dictionary   name=${name}   policy_type_name=custom  organization_id=${organization_id}   configuration=${configuration_dict}  schedule_days=${schedule_days}   schedule_time=${schedule_time}   notes=${notes}
      ${json_string}=    Evaluate    json.dumps(${custom_policy_dict})    json
      ${resp}=  Get Request  automoxapi  /policies
      Should Be Equal As Strings  ${resp.status_code}  200
      @{resp_json}=  Set Variable   ${resp.json()}
      Policy List Should Contain Policy Details   ${resp_json}    ${json_string}

#Description        :: This keyword will delete a policy as per provided inputs
#Author             :: Laxman.M
#Date               :: 18Jan2017
#Input Parameters   :: policy_name - string - Name of the Policy to be deleted
#                      organization_id - integer - Organization Id for which patch policy should be created
#Output Parameters  :: None
#Pending Impl       :: NA
Delete Policy
      [Arguments]   ${policy_name}=api-patch-policy  ${organization_id}=${1}
      ${resp}=  Get Request  automoxapi  /policies
      @{resp_json}=  Set Variable   ${resp.json()}
      ${policy_id}=    Get Policy ID    ${resp_json}    ${policy_name}
      Log   ${policy_id}
      ${policy_id_int}=   Convert To Integer    ${policy_id}
      ${params}=   Create Dictionary   o=${organization_id}
      ${resp}=  Delete Request  automoxapi  /policies/${policy_id_int}  params=${params}
      Log  ${resp.content}
      Should Be Equal As Strings  ${resp.status_code}  204

#Description        :: This keyword will delete a policy set as per provided inputs
#Author             :: Laxman.M
#Date               :: 18Jan2017
#Input Parameters   :: policy_set_name - string - Name of the Policy to be deleted
#                      organization_id - integer - Organization Id for which patch policy should be created
#Output Parameters  :: None
#Pending Impl       :: NA
Delete Policy Set
      [Arguments]   ${policy_set_name}=api-patch-policy  ${organization_id}=${1}
      ${resp}=  Get Request  automoxapi  /policysets
      @{resp_json}=  Set Variable   ${resp.json()}
      ${policy_set_id}=    Get Policy Set ID     ${resp_json}    ${policy_set_name}
      Log   ${policy_set_id}
      ${policy_set_id_int}=   Convert To Integer    ${policy_set_id}
      ${params}=   Create Dictionary   o=${organization_id}
      ${resp}=  Delete Request  automoxapi  /policysets/${policy_set_id_int}  params=${params}
      Log  ${resp.content}
      Should Be Equal As Strings  ${resp.status_code}  204

#Description        :: This keyword will delete a group as per provided inputs
#Author             :: Laxman.M
#Date               :: 18Jan2017
#Input Parameters   :: group_name - string - Name of the Policy to be deleted
#                      organization_id - integer - Organization Id for which patch policy should be created
#Output Parameters  :: None
#Pending Impl       :: NA
Delete Group
      [Arguments]   ${group_name}=api-group  ${organization_id}=${1}
      ${resp}=  Get Request  automoxapi  /servergroups
      @{resp_json}=  Set Variable   ${resp.json()}
      ${group_id}=    Get Group ID    ${resp_json}    ${group_name}
      Log   ${group_id}
      ${group_id_int}=   Convert To Integer    ${group_id}
      ${params}=   Create Dictionary   o=${organization_id}
      ${resp}=  Delete Request  automoxapi  /servergroups/${group_id_int}  params=${params}
      Log  ${resp.content}
      Should Be Equal As Strings  ${resp.status_code}  204

################################################################################
######################## Suite Level Keywords ##################################
################################################################################

#Description        :: This keyword will create Automox API server session
#Author             :: Laxman.M
#Date               :: 14Jan2017
#Input Parameters   :: None
#Output Parameters  :: None
Create Session To Automox API Server
      ${auth}=  Create List  ${VALID USER}   ${VALID PASSWORD}
      Create Session    automoxapi    ${API SERVER}    auth=${auth}       verify=False     disable_warnings=0

#Description        :: This keyword will contain all the steps for Suite Cleanup
#Author             :: Laxman.M
#Date               :: 18Jan2017
#Input Parameters   :: None
#Output Parameters  :: None
#Pending Impl       :: NA
API Suite Cleanup
    Run Keyword And Ignore Error    Delete Policy   api-sw-deployment-policy-01     ${1}
    Run Keyword And Ignore Error    Delete Policy   api-patch-policy-01       ${1}
    Run Keyword And Ignore Error    Delete Policy   api-custom-policy-01       ${1}
    Run Keyword And Ignore Error    Delete Policy Set    api-policy-set-01    ${1}
    Run Keyword And Ignore Error    Delete Group    api-group-01    ${1}
    Delete All Sessions
