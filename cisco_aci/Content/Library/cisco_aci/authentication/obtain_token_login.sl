########################################################################################################################
#!!
#! @description: Obtain token (login)
#!
#! @input url: The URL for the HTTP call
#! @input authentication_auth_type: Authentication type (Anonymous/Basic/Digest/Bearer)
#! @input username: Username
#! @input password: Password
#!
#! @output return_result: Response of the operation.
#! @output token: Authentication token.
#! @output error_message: Return_result when the return_code is non-zero (e.g. network or other failure).
#! @output status_code: Status code of the HTTP call.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output response_headers: Response headers string from the HTTP Client REST call.
#!
#! @result SUCCESS: Operation succeeded (statusCode is contained in valid_http_status_codes list).
#! @result FAILURE: Operation failed (statusCode is not contained in valid_http_status_codes list).
#!!#
########################################################################################################################
namespace: cisco_aci.authentication
flow:
  name: obtain_token_login
  inputs:
    - url: "${get_sp('cisco_aci_base_url')+'/api/aaaLogin.json'}"
    - authentication_auth_type: "${get_sp('cisco_aci_auth_type')}"
    - username
    - password:
        sensitive: true
  workflow:
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - method: POST
            - content_type: application/json
            - body: "${'{ \"aaaUser\": { \"attributes\": { \"name\": \"'+ username  +'\", \"pwd\": \"' + password + '\"}}}'}"
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
          - SUCCESS: is_401
          - FAILURE: on_failure
    - is_401:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: "${cs_json_query(return_result,'$.imdata[0].error.attributes.code')}"
            - second_string: '401'
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: SUCCESS
  outputs:
    - return_result: '${return_result}'
    - token: "${cs_json_query(return_result,'$.imdata[0].aaaLogin.attributes.token')}"
    - error_message: '${error_message}'
    - status_code: '${status_code}'
    - return_code: '${return_code}'
    - response_headers: '${response_headers}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      http_client_action:
        x: 80
        'y': 160
      is_401:
        x: 360
        'y': 160
        navigate:
          3eba7a27-0c51-8709-b683-9aa4bae1d57e:
            targetId: b6c4df02-322d-dee7-2e2b-70c2fde382e6
            port: SUCCESS
          b502d1cf-a953-bce6-37b3-9065286f21db:
            targetId: 63867063-8e00-25a4-f277-14a0f919666a
            port: FAILURE
    results:
      SUCCESS:
        63867063-8e00-25a4-f277-14a0f919666a:
          x: 680
          'y': 160
      FAILURE:
        b6c4df02-322d-dee7-2e2b-70c2fde382e6:
          x: 360
          'y': 360
