use leptos::*;
use leptos_meta::*;

use crate::components::Hero;

#[component]
pub fn HomePage() -> impl IntoView {
	view! {
		<Title text="Home" />
		<Hero />
	}
}
