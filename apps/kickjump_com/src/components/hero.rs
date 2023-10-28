use leptos::*;

#[component]
pub fn Hero() -> impl IntoView {
	view! {
	  <div class="hero min-h-screen bg-base-200">
		  <div class="hero-content text-center">
			  <div class="max-w-md">
				  <h1 class="text-5xl font-bold">"KickJump!"</h1>
				  <p class="py-6">"Your toolkit for financially sustainable open source development."</p>
				  <button class="btn btn-primary">"Get Started"</button>
			  </div>
		  </div>
	  </div>
	}
}
