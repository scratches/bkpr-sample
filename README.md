Experiment with [Bitnami Kubernetes Production Runtime](https://github.com/bitnami/kube-prod-runtime).

Prerequisites: BKPR installed in the cluster, and DNS set up for your custom domain as documented in the BKPR guides.

> NOTE: You have to use the external DNS registrar to create NS records for your domain into the platform where you have BKPR (e.g. Cloud DNS in GCP). This is documented in the BKPR guides but a bit sketchy. Some registrars don't allow NS records for subdomains, so check that before you choose a domain. Expect that it might take upwards of an hour to propagate the NS records - you only have to do it once per cluster, but it's a real pain.

There are two sample apps: "demo" (simple HTTP endpoint) and "petclinic" (Spring Petclinic with MySQL).

Also there are 2 re-usable Kustomize resources:

* "ingress": adds `Ingress` to your app if deployed in BKPR.
* "oauth2": additionally adds OAuth2 single sign on to the ingress

To use the "ingress" resource the application has to have a `Service` called `app` listening on port 80, and it has to define 2 variables in `kustomize.yaml`: `$(HOST)` and `$(DOMAIN)`. The ingress will then be accessible on the internet at `https://$(HOST).$(DOMAIN)`. The samples here set up the `$(DOMAIN)` variable as an attribute on the `Service`, but anything would work as long as it has the correct DNS records. The `$(HOST)` is always the name of the `Service`.

> TIP: If you set up a wildcard DNS A-record to `*.$(DOMAIN)` in the Kubernetes platform (e.g. Cloud DNS for GCP) you won't have to wait for BKPR to register new apps. It will still register A-records for new apps, but DNS resolution can go through the wildcard without having to wait for propagation.

There seems to be a bug in BKPR that prevents you from uninstalling it - the namespace cannot be deleted. To work around that you might need to manually delete the finalizers from the challenge resources in the `kubeprod` namespace.

```
$ kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --ignore-not-found -n kubeprod
$ kubectl edit -n kubeprod challenge grafana-tls-2452413783-1426328939-1827263010 # etc.
# replace finalizers with empty array []
```