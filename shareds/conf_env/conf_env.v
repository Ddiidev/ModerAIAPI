module conf_env

import os
import dotenv

// EnvConfig representa todas as variáveis de ambiente do arquivo .env.local
// Contém todas as configurações necessárias para a aplicação funcionar corretamente
pub struct EnvConfig {
pub:
	name_db              string
	host_db              string
	port_db              string
	user_db              string
	pass_db              string
	google_url           string
	google_client_id     string
	google_redirect_uri  string
	google_client_secret string
	jwt_secret           string
	jwt_expires_in       string
}

// load_env carrega as variáveis de ambiente primeiro do sistema operacional e, se não encontradas,
// utiliza o arquivo .env.local como alternativa
// Retorna: Uma instância de EnvConfig com todas as variáveis de ambiente carregadas
pub fn load_env() EnvConfig {
	env_map := if !os.exists('.env') {
		map[string]string{}
	} else {
		dotenv.parse('.env')
	}

	// Create and populate the config struct
	return EnvConfig{
		name_db:              get_env('NAME_DB', env_map)
		host_db:              get_env('HOST_DB', env_map)
		port_db:              get_env('PORT_DB', env_map)
		user_db:              get_env('USER_DB', env_map)
		pass_db:              get_env('PASS_DB', env_map)
		google_client_id:     get_env('GOOGLE_CLIENT_ID', env_map)
		google_client_secret: get_env('GOOGLE_CLIENT_SECRET', env_map)
		google_url:           get_env('GOOGLE_URL', env_map)
		google_redirect_uri:  get_env('GOOGLE_REDIRECT_URI', env_map)
		jwt_secret:           get_env('JWT_SECRET', env_map)
		jwt_expires_in:       get_env('JWT_EXPIRES_IN', env_map)
	}
}

// get_env obtém o valor de uma variável de ambiente específica
// Parâmetros:
//   key - A chave da variável de ambiente a ser buscada
//   env_map - Um mapa contendo as variáveis de ambiente do arquivo .env.local
// Retorna: O valor da variável de ambiente ou gera um erro se não encontrada
fn get_env(key string, env_map map[string]string) string {
	sys_env := os.getenv(key)
	if sys_env != '' {
		return sys_env
	}
	return env_map[key] or { panic('Missing required environment variable: ${key}') }
}
