use leptos::*;
use leptos_meta::*;

#[component]
pub fn Seo() -> impl IntoView {
	view! {
		<Title formatter=|text| format!("{text} | KickJump")/>
		<Link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png"/>
		<Link rel="icon" type_="image/png" sizes="32x32" href="/favicon-32x32.png"/>
		<Link rel="icon" type_="image/png" sizes="16x16" href="/favicon-16x16.png"/>
		<Link rel="manifest" href="/site.webmanifest"/>
		<Meta name="robots" content="index,follow" />
		<Meta name="googlebot" content="index,follow" />
		<Meta name="description" content="Your toolkit for financially sustainable open source development." />
	}
}
