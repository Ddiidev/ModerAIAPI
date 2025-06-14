module main

import veb
import shareds.wcontext
import features.auth.login
// import shareds.auth

pub struct App {
	veb.Controller
	veb.Middleware[wcontext.WsCtx]
}

pub fn (app &App) index(mut ctx wcontext.WsCtx) veb.Result {
	return ctx.json({
		'status':        'online'
		'message':       'ModerAI API em funcionamento'
		'version':       '1.0.0'
		'Authorization': ctx.get_cookie('Authorization') or { '' }
	})
}

fn main() {
	mut app := &App{}
	mut login_controller := &login.LoginController{}

	// Configuração CORS corrigida para funcionar com credentials
	conf_cors := veb.cors[wcontext.WsCtx](veb.CorsOptions{
		origins:         ['*']
		allowed_methods: [.get, .head, .options, .patch, .put, .post, .delete]
	})
	app.use(conf_cors)
	login_controller.use(conf_cors)

	app.register_controller[login.LoginController, wcontext.WsCtx]('/auth', mut login_controller)!

	veb.run[App, wcontext.WsCtx](mut app, 4242)
}
