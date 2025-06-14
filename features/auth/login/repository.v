module login

import domain.user
import shareds.types
import shareds.infradb
import domain.auth_login.google

pub struct LoginRepository {}

// insert_user_by_google_user_info Insere ou atualiza um usuário no banco de dados com base nos dados do Google.
// Retorna o ID do usuário para uso no JWT
pub fn LoginRepository.insert_user_by_google_user_info(google_auth google.GoogleAuth) !types.UUID {
	mut db := infradb.ConnectionDb.new()!

	mut google_auth_entity := google_auth.to_google_auth_entity()

	user_data := user.User{
		email:       google_auth.user_info.email
		username:    google_auth.user_info.name
		first_name:  google_auth.user_info.given_name or { '' }
		google_auth: [google_auth_entity]
	}

	email := if user_data.google_auth.len > 0 {
		google_auth.user_info.email or { '' }
	} else {
		''
	}

	data := sql db.conn {
		select from google.GoogleAuthEntity where user_info_email == email
	}!

	if data.len > 0 {
		sql db.conn {
			update user.User set first_name = google_auth_entity.user_info_given_name, last_name = google_auth_entity.user_info_family_name
			where id == data[0].parent_id
		} or { return error('user.User : ${err.msg()}') }

		sql db.conn {
			update google.GoogleAuthEntity set expires_in = google_auth.expires_in, email_verified = google_auth.email_verified,
			access_token = google_auth.access_token, scope = google_auth.scope, token_type = google_auth.token_type,
			id_token = google_auth.id_token, user_info_sub = google_auth.user_info.sub,
			user_info_name = google_auth.user_info.name, user_info_given_name = google_auth.user_info.given_name,
			user_info_family_name = google_auth.user_info.family_name, user_info_picture = google_auth.user_info.picture,
			user_info_locale = google_auth.user_info.locale, client_id = google_auth.client_id
			where user_info_email == email
		} or { return error('google.GoogleAuthEntity : ${err.msg()}') }

		// Retorna o ID do usuário existente
		return sql db.conn {
			select from user.User where id == data[0].parent_id
		}![0].uuid
	} else {
		id := sql db.conn {
			insert user_data into user.User
		} or { return error('user.User : ${err.msg()}') }

		google_auth_entity = google.GoogleAuthEntity{
			...google_auth_entity
			parent_id: id
		}

		sql db.conn {
			insert google_auth_entity into google.GoogleAuthEntity
		} or { return error('google.GoogleAuthEntity : ${err.msg()}') }

		// Retorna o ID do novo usuário
		return user_data.uuid
	}
}
