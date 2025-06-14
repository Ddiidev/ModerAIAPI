module login

import domain.user
import domain.auth_login.google

pub struct LoginAdapter {}

pub fn LoginAdapter.google_auth_model_to_entitiy(g google.GoogleAuth) user.User {
	return user.User{
		google_auth: [
			g.to_google_auth_entity(),
		]
		first_name:  g.user_info.given_name or { '' }
		last_name:   g.user_info.family_name
	}
}
