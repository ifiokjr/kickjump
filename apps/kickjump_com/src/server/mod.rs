use axum::body::Body as AxumBody;
use axum::extract::FromRef;
use axum::extract::Path;
use axum::extract::RawQuery;
use axum::extract::State;
use axum::http::Request;
use axum::response::IntoResponse;
use http::HeaderMap;
use leptos::LeptosOptions;
use leptos::*;
use leptos_axum::handle_server_fns_with_context;

pub mod error;
pub mod fileserver;
pub mod prisma;
use cfg_if::cfg_if;
pub use error::*;
pub use fileserver::*;
pub use prisma::*;

cfg_if! {if #[cfg(feature = "ratelimit")] {
	pub mod ratelimit;
	pub use ratelimit::*;
}}
cfg_if! {if #[cfg(feature = "compression")] {
	pub mod compression;
	pub use compression::*;
}}

#[derive(FromRef, Debug, Clone)]
pub struct AppState {
	pub leptos_options: LeptosOptions,
	pub prisma_client: ArcPrisma,
}

pub async fn server_fn_handler(
	State(app_state): State<AppState>,
	path: Path<String>,
	headers: HeaderMap,
	raw_query: RawQuery,
	request: Request<AxumBody>,
) -> impl IntoResponse {
	handle_server_fns_with_context(
		path,
		headers,
		raw_query,
		move || {
			provide_context(app_state.prisma_client.clone());
		},
		request,
	)
	.await
}
