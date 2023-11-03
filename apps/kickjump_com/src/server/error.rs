use http::status::StatusCode;
use leptos::*;
use leptos_axum::ResponseOptions;
use leptos_axum::ResponseParts;

pub fn server_404() {
	let res_parts = ResponseParts {
		status: Some(StatusCode::NOT_FOUND),
		..Default::default()
	};
	let res_options_outer = use_context::<ResponseOptions>();
	if let Some(res_options) = res_options_outer {
		res_options.overwrite(res_parts);
	}
}
