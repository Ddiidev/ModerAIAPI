module login

struct RespObj {
	token string
	user  struct {
		email   string
		name    string
		picture string
	}
}
