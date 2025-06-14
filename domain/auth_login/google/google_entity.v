module google

@[table: 'GoogleAuth']
pub struct GoogleAuthEntity {
pub:
	id                    int @[primary; serial]
	parent_id             int
	expires_in            int
	email_verified        bool
	access_token          ?string
	scope                 ?string
	token_type            ?string
	id_token              ?string
	user_info_sub         ?string
	user_info_name        ?string
	user_info_given_name  ?string
	user_info_family_name ?string
	user_info_picture     ?string
	user_info_email       ?string
	user_info_locale      ?string
	client_id             ?string
}

pub fn (gae GoogleAuthEntity) to_google_auth() GoogleAuth {
	return GoogleAuth{
		id:             gae.id
		parent_id:      gae.parent_id
		expires_in:     gae.expires_in
		email_verified: gae.email_verified
		access_token:   gae.access_token
		scope:          gae.scope
		token_type:     gae.token_type
		id_token:       gae.id_token
		user_info:      GoogleAuthUserInfo{
			sub:         gae.user_info_sub
			name:        gae.user_info_name
			given_name:  gae.user_info_given_name
			family_name: gae.user_info_family_name
			picture:     gae.user_info_picture
			email:       gae.user_info_email
		}
	}
}
