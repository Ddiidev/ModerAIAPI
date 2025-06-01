module main

import veb

pub struct Context {
	veb.Context
}

pub struct App {}

// Rota principal
pub fn (app &App) index(mut ctx Context) veb.Result {
	return ctx.json({
		'status': 'online'
		'message': 'ModerAI API em funcionamento'
		'version': '1.0.0'
	})
}

fn main() {
	mut app := &App{}
	
	veb.run[App, Context](mut app, 4242)
}
