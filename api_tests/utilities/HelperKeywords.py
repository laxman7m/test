import json

class HelperKeywords(object):
    def policy_list_should_contain_policy_details(self, policies_list, policy_details):
        flag = False
        policy_details = json.loads(policy_details)
        for policy in policies_list:
            if policy_details.viewitems() <= policy.viewitems():
                flag = True
                print "Policy Details found in Policy List: "+str(policy)
                break
        if flag is False:
            raise AssertionError("Policy Details not found in Policy List: "+str(policy_details))


    def policy_set_list_should_contain_policy_set_details(self, policy_set_list, policy_set_details):
        flag = False
        policy_set_details = json.loads(policy_set_details)
        for policy_set in policy_set_list:
            if policy_set_details.viewitems() <= policy_set.viewitems():
                flag = True
                print "Policy Set Details found in Policy Set List: "+str(policy_set)
                break
        if flag is False:
            raise AssertionError("Policy Set Details not found in Policy Set List: "+str(policy_set_details))

    def group_list_should_contain_group_details(self, group_list, group_details):
        flag = False
        group_details = json.loads(group_details)
        for group in group_list:
            if group_details.viewitems() <= group.viewitems():
                flag = True
                print "Group Details found in Group List: "+str(group)
                break
        if flag is False:
            raise AssertionError("Group Details not found in Group List: "+str(group_details))



    def get_policy_set_id(self, policy_set_list, policy_set_name):
        flag = False
        for policy_set in policy_set_list:
            if policy_set['name'] == policy_set_name:
                policy_set_id = policy_set['id']
                print "Policy Set ID for " + policy_set_name + " is" + str(policy_set_id)
                return policy_set_id
        if flag is False:
            raise AssertionError("Policy Set Name not found in Policy Set List: "+str(policy_set_list))

    def get_policy_id(self, policy_list, policy_name):
        flag = False
        for policy in policy_list:
            if policy['name'] == policy_name:
                policy_id = policy['id']
                print "Policy ID for " + policy_name + " is" + str(policy_id)
                return policy_id
        if flag is False:
            raise AssertionError("Policy Name not found in Policy  List: "+str(policy_list))


    def get_endpoint_id(self, endpoint_list, endpoint_name):
        flag = False
        for endpoint in endpoint_list:
            if endpoint['name'] == endpoint_name:
                endpoint_id = endpoint['id']
                print "Endpoint ID for " + endpoint_name + " is" + str(endpoint_id)
                return endpoint_id
        if flag is False:
            raise AssertionError("Endpoint Name not found in Endpoint List: "+str(endpoint_list))

    def get_group_id(self, group_list, group_name):
        flag = False
        for group in group_list:
            if group['name'] == group_name:
                group_id = group['id']
                print "Group ID for " + group_name + " is" + str(group_id)
                return group_id
        if flag is False:
            raise AssertionError("Group Name not found in Group List: "+str(group_list))

    def get_endpoint_json(self, endpoint_list, endpoint_id):
        flag = False
        for endpoint in endpoint_list:
            if endpoint['id'] == endpoint_id:
                print "Endpoint Json for " + str(endpoint_id) + " is" + str(endpoint)
                return endpoint
        if flag is False:
            raise AssertionError("Endpoint ID not found in Endpoint List: "+str(endpoint_list))
