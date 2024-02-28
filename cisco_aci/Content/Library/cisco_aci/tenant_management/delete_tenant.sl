########################################################################################################################
#!!
#! @description: Delete tenant
#!
#! @input rspsubtree: Requests a response of the modified object
#! @input url: The URL for the HTTP call
#! @input authentication_auth_type: Authentication type (Anonymous/Basic/Digest/Bearer)
#!
#! @output return_result: Response of the operation.
#! @output error_message: Return_result when the return_code is non-zero (e.g. network or other failure).
#! @output status_code: Status code of the HTTP call.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output response_headers: Response headers string from the HTTP Client REST call.
#!
#! @result SUCCESS: Operation succeeded (statusCode is contained in valid_http_status_codes list).
#! @result FAILURE: Operation failed (statusCode is not contained in valid_http_status_codes list).
#!!#
########################################################################################################################
namespace: cisco_aci.tenant_management
flow:
  outputs:
    - return_result: '${return_result}'
    - error_message: '${error_message}'
    - status_code: '${status_code}'
    - return_code: '${return_code}'
    - response_headers: '${response_headers}'
  workflow:
    - http_client_action:
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
        publish:
          - return_result
          - error_message
          - status_code
          - return_code
          - response_headers
        do:
          io.cloudslang.base.http.http_client_action:
            - method: DELETE
            - query_params: "${'rsp-subtree='+rspsubtree}"
            - url: '${url}'
            - auth_type: '${authentication_auth_type}'
            - headers: "${''}"
  inputs:
    - rspsubtree:
        required: false
    - url: "${get_sp('cisco_aci_base_url')+'/api/mo/uni/tn-globoTenant.json'}"
    - authentication_auth_type: "${get_sp('cisco_aci_auth_type')}"
  name: delete_tenant
  results:
    - SUCCESS
    - FAILURE
