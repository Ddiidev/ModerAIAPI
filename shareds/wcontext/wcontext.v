module wcontext

import veb

pub struct WsCtx {
	veb.Context
}

pub fn (mut ctx WsCtx) not_found() veb.Result {
	ctx.res.set_status(.not_found)
	return ctx.html('<h1>404</h1>')
}
