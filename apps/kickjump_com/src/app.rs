use leptos::*;
use leptos_meta::*;
use leptos_router::*;

use crate::components::Seo;
use crate::error_template::AppError;
use crate::error_template::ErrorTemplate;

#[path = "./app/layout.rs"]
mod l0_layout;
#[path = "./app/page.rs"]
mod l0_page;
#[path = "./app/example/page.rs"]
mod l1_page_example;

#[component]
pub fn App() -> impl IntoView {
	// Provides context that manages stylesheets, titles, meta tags, etc.
	provide_meta_context();

	view! {
		<Stylesheet id="leptos" href="/pkg/kickjump_com.css" />
		<Seo />
		// content for this welcome page
		<Router fallback=|| {
			let mut outside_errors = Errors::default();
			outside_errors.insert_with_default_key(AppError::NotFound);
			view! { <ErrorTemplate outside_errors /> }.into_view()
		}>
				<Routes>
					<Route path="/" view={l0_layout::MainLayout}>
						<Route path="" view={l0_page::HomePage} />
						<Route path="example" view={l1_page_example::ExamplePage} />
					</Route>
				</Routes>
		</Router>
	}
}
