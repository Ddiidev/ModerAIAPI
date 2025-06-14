module login

import json
import net.http
import shareds.conf_env
import domain.auth_login.google

pub struct LoginHandler {}

pub type AccessToken = string

const url_googleapi_token = 'https://oauth2.googleapis.com/token'
const url_googleapi_user_info = 'https://www.googleapis.com/oauth2/v2/userinfo'

pub fn LoginHandler.get_token(code string) !google.GoogleAuth {
	env := conf_env.load_env()

	result := http.fetch(http.FetchConfig{
		method: .post
		header: http.new_header(http.HeaderConfig{.content_type, 'application/x-www-form-urlencoded'})
		url:    url_googleapi_token
		data:   http.url_encode_form_data({
			'code':          code
			'client_id':     env.google_client_id
			'client_secret': env.google_client_secret
			'redirect_uri':  env.google_redirect_uri
			'grant_type':    'authorization_code'
		})
	})!

	acess_auth := json.decode(google.GoogleAuth, result.body) or {
		return error('access_token is not found')
	}

	return acess_auth
}

pub fn LoginHandler.get_user_info(access_token AccessToken) !google.GoogleAuthUserInfo {
	if access_token == '' {
		return error('access_token is required')
	}
	result := http.fetch(http.FetchConfig{
		header: http.new_header(http.HeaderConfig{.authorization, 'Bearer ${access_token}'})
		url:    url_googleapi_user_info
	})!

	dump(result.body)

	return json.decode(google.GoogleAuthUserInfo, result.body)!
}
