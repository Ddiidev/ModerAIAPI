module models

@[params]
pub struct DataContext {
pub mut:
	callstack []string
	infos     []string
	request   map[string]string
}
