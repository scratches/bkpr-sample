// Cluster-specific configuration
(import "https://releases.kubeprod.io/files/v1.4.0/manifests/platforms/gke.jsonnet") {
	config:: import "kubeprod-autogen.json",
	// Place your overrides here
}