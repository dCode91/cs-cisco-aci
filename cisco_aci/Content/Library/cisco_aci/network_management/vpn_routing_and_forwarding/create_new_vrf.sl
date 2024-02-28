namespace: cisco_aci.network_management.vpn_routing_and_forwarding
flow:
  name: create_new_vrf
  inputs:
    - url: "${get_sp('cisco_aci_base_url') + '/api/mo/uni/tn-globoTenant.json'}"
    - authentication_auth_type: "${get_sp('cisco_aci_auth_type')}"
    - rsp_subtree: modified
    - name: VRF_GLOBO
    - ip_data_plane_learning: enabled
    - knw_mcast_act: permit
    - pc_enf_dir: ingress
    - pc_enf_pref: enforced
  workflow:
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - method: POST
            - content_type: application/json
            - body: "${'{ \"fvCtx\": { \"attributes\": { \"name\": \"' + name + '\", \"ipDataPlaneLearning\": \"' + ip_data_plane_learning + '\", \"knwMcastAct\": \"' + knw_mcast_act + '\", \"pcEnfDir\": \"' + pc_enf_dir + '\", \"pcEnfPref\": \"' + pc_enf_pref + '\" } } }'}"
            - query_params: "${'rsp-subtree=' + rsp_subtree}"
            - url: '${url}'
            - auth_type: '${authentication_auth_type}'
            - headers: "${''}"
        publish:
          - return_result
          - error_message
          - status_code
          - return_code
          - response_headers
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_action:
        x: 120
        'y': 170
        navigate:
          86933f35-76d8-17f2-6e0e-e81d38779750:
            targetId: 4fd03849-92df-d4c7-22d5-f369aec62d78
            port: SUCCESS
    results:
      SUCCESS:
        4fd03849-92df-d4c7-22d5-f369aec62d78:
          x: 400
          'y': 160
