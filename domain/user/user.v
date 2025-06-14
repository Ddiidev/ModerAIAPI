module user

import rand
import shareds.types
import domain.auth_login.google

@[table: 'Users']
pub struct User {
pub:
	id          int @[primary; serial]
	uuid        types.UUID = rand.uuid_v7()
	google_auth []google.GoogleAuthEntity @[fkey: 'parent_id']
	first_name  string
	last_name   ?string
	username    ?string
	password    ?string
	email       ?string
}
