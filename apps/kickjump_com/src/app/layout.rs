use leptos::*;
use leptos_router::*;

use crate::components::Footer;
use crate::components::Navbar;

/// Renders the home page of your application.
#[component]
pub fn MainLayout() -> impl IntoView {
	view! {
	  <header class="fixed inset-0">
		  <Navbar />
	  </header>
	  <main class="mt-16 sm:mt-[68] min-h-[calc(100vh-64px)] sm:min-h-[calc(100vh-64)]">
		  <Outlet />
	  </main>
		<Footer />
	}
}
