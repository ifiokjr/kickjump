use leptos::*;
use leptos_meta::*;

/// Example using leptos state.
#[component]
pub fn ExamplePage() -> impl IntoView {
	// Creates a reactive value to update the button
	let (count, set_count) = create_signal(0);
	let on_click = move |_| set_count.update(|count| *count += 1);

	view! {
		<Title text="Example" />
		<button on:click=on_click class="btn btn-primary">
			"Click Me: "
			{count}
		</button>
	}
}
