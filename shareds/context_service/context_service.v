module context_service

import time
import services.logs.models as log_models
import shareds.context_service.models as ctx_models

pub struct ContextService {
mut:
	data_ctx ctx_models.DataContext
pub mut:
	duration time.Duration
}

pub fn (cs ContextService) log_api(parametter log_ctx_models.LogModel) {}

pub fn (cs ContextService) log_server_action(parametter log_ctx_models.LogModel) {}

pub fn (cs ContextService) log_register(parametter log_ctx_models.LogModel) {}

pub fn (cs ContextService) log_info(parametter map[string]log_ctx_models.LogModel) {}

pub fn (mut cs ContextService) add_callstack(callstack string) {
	cs.data_ctx.callstack << callstack
}
