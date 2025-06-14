module login

import veb
import json
import jwt
import time
import shareds.wcontext
import shareds.conf_env

pub struct LoginController {
	veb.Controller
	veb.Middleware[wcontext.WsCtx]
}

// UserData representa os dados do usuário para o JWT
struct UserData {
pub:
	email string
	name  string
}

@['/google'; post]
pub fn (lc &LoginController) auth_google(mut ctx wcontext.WsCtx) veb.Result {
	// Decodifica o body da requisição
	body := json.decode(map[string]string, ctx.req.data) or {
		ctx.res.set_status(.bad_request)
		return ctx.json({
			'error': 'Invalid request data'
		})
	}

	// Extrai o código de autorização
	code := body['code'] or {
		ctx.res.set_status(.bad_request)
		return ctx.json({
			'error': 'Authorization code is required'
		})
	}

	// Troca o código por token de acesso
	mut access_auth := LoginHandler.get_token(code) or {
		ctx.res.set_status(.unauthorized)
		return ctx.json({
			'error': 'Failed to exchange authorization code'
		})
	}

	// Obtém informações do usuário
	user_info := LoginHandler.get_user_info(access_auth.access_token or { '' }) or {
		ctx.res.set_status(.unauthorized)
		return ctx.json({
			'error': 'Failed to get user information'
		})
	}

	// Atualiza o objeto com as informações do usuário
	access_auth.insert_user_info(user_info) or {
		ctx.res.set_status(.unauthorized)
		return ctx.json({
			'error': 'Failed to get user information'
		})
	}

	// Salva/atualiza usuário no banco
	user_uuid := LoginRepository.insert_user_by_google_user_info(access_auth) or {
		ctx.res.set_status(.internal_server_error)
		return ctx.json({
			'error': 'Failed to save user data'
		})
	}

	dump(access_auth)

	// Carrega configurações de ambiente
	env := conf_env.load_env()
	jwt_secret := env.jwt_secret

	// Cria payload do JWT
	user_data := UserData{
		email: user_info.email or { '' }
		name:  user_info.name or { '' }
	}

	payload := jwt.Payload[UserData]{
		sub: user_uuid
		exp: time.now().add(time.hour * 48).str()
		iat: time.now().str()
		iss: 'ModerAI'
		ext: user_data
	}

	// Gera o JWT
	token := jwt.Token.new(payload, jwt_secret)
	token_str := token.str()

	// Retorna a resposta no formato esperado pelo frontend
	return ctx.json(RespObj{
		token: token_str
		user:  struct {
			email:   user_info.email or { '' }
			name:    user_info.name or { '' }
			picture: user_info.picture or { '' }
		}
	})
}
