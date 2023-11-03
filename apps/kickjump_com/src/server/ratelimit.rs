use axum::error_handling::HandleErrorLayer;
use axum::BoxError;
use axum::Router;
use tower::ServiceBuilder;
use tower_governor::errors::display_error;
use tower_governor::governor::GovernorConfigBuilder;
use tower_governor::key_extractor::SmartIpKeyExtractor;
use tower_governor::GovernorLayer;

pub fn ratelimit(app: Router) -> Router {
	let governor_conf = Box::new(
		GovernorConfigBuilder::default()
			.key_extractor(SmartIpKeyExtractor)
			.finish()
			.unwrap(),
	);
	app.layer(
		ServiceBuilder::new()
			.layer(HandleErrorLayer::new(|e: BoxError| {
				async move { display_error(e) }
			}))
			.layer(GovernorLayer {
				config: Box::leak(governor_conf),
			}),
	)
}
