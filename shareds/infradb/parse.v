module infradb

import time

// Função para mapear um map[string]string para uma struct genérica T
pub fn map_to_struct[T](data map[string]string) T {
	mut instance := T{}

	// Itera sobre os campos da struct
	$for field in T.fields {
		if field.name in data {
			value := data[field.name]

			// Define o valor no campo correspondente
			$if field.typ is int {
				instance.$(field.name) = value.int()
			} $else $if field.typ is string {
				instance.$(field.name) = value
			} $else $if field.typ is bool {
				instance.$(field.name) = value == 'true' || value == '1'
			} $else $if field.typ is f64 {
				instance.$(field.name) = value.f64()
			} $else $if field.typ is f32 {
				instance.$(field.name) = value.f32()
			} $else $if field.typ is i8 {
				instance.$(field.name) = value.i8()
			} $else $if field.typ is i16 {
				instance.$(field.name) = value.i16()
			} $else $if field.typ is i64 {
				instance.$(field.name) = value.i64()
			} $else $if field.typ is u8 {
				instance.$(field.name) = value.u8()
			} $else $if field.typ is u16 {
				instance.$(field.name) = value.u16()
			} $else $if field.typ is u32 {
				instance.$(field.name) = value.u32()
			} $else $if field.typ is u64 {
				instance.$(field.name) = value.u64()
			} $else $if field.typ is isize {
				instance.$(field.name) = value.int()
			} $else $if field.typ is usize {
				instance.$(field.name) = value.u32()
			} $else $if field.typ is rune {
				instance.$(field.name) = value.runes()[0]
			} $else $if field.typ is time.Time {
				instance.$(field.name) = time.parse(value) or { time.Time{} }
			}
		}
	}
	return instance
}

fn get_variant[T](input T, value string) T {
	mut instance := T{}

	$for variant in T.variants {
		$if variant.typ is string {
			instance = value
		} $else $if variant.typ is int {
			instance = value.int()
		} $else $if variant.typ is bool {
			instance = value == 'true' || value == '1'
		} $else $if variant.typ is f64 {
			instance = value.f64()
		} $else $if variant.typ is f32 {
			instance = value.f32()
		} $else {
			eprintln('Unsupported variant type for field: ${field.name}')
		}
	}
	return instance
}

// Função para mapear uma lista de maps para uma lista de structs
pub fn map_to_structs[T](data []map[string]string) []T {
	mut results := []T{}
	for row in data {
		results << map_to_struct[T](row)
	}
	return results
}
