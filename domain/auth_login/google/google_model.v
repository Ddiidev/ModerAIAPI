module google

pub struct GoogleAuth {
pub:
	id             int
	parent_id      int
	expires_in     int
	email_verified bool
	access_token   ?string
	scope          ?string
	token_type     ?string
	id_token       ?string
	user_info      GoogleAuthUserInfo
	client_id      ?string
}

pub struct GoogleAuthUserInfo {
pub:
	sub         ?string
	name        ?string
	given_name  ?string
	family_name ?string
	picture     ?string
	email       ?string
	locale      ?string
}

pub fn (mut g GoogleAuth) insert_user_info(user_info GoogleAuthUserInfo) ! {
	if name := user_info.name {
		if name == '' {
			return error('Name is required')
		}
	}

	if email := user_info.email {
		if email == '' {
			return error('Email is required')
		}
	}

	g = GoogleAuth{
		...g
		user_info: user_info
	}
}

pub fn (g GoogleAuth) to_google_auth_entity() GoogleAuthEntity {
	return GoogleAuthEntity{
		id:                    g.id
		parent_id:             g.parent_id
		expires_in:            g.expires_in
		email_verified:        g.email_verified
		access_token:          g.access_token
		scope:                 g.scope
		token_type:            g.token_type
		id_token:              g.id_token
		user_info_email:       g.user_info.email
		user_info_name:        g.user_info.name
		user_info_given_name:  g.user_info.given_name
		user_info_family_name: g.user_info.family_name
		user_info_picture:     g.user_info.picture
		user_info_locale:      g.user_info.locale
		client_id:             g.client_id
	}
}
