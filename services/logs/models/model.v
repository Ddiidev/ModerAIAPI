module models

import time

@[params]
pub struct LogModel {
pub:
	ip     string
	date   time.Time = time.now()
	method string    = 'GET'
}
