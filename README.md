# my-first-api

This project includes a Helm chart in `chart/` for deploying the API and PostgreSQL to Kubernetes.

## Helm Chart Validation

Install Helm locally, then validate the chart from the project root:

```bash
helm lint chart
helm template test-release chart
```

To render the Ingress template as well, enable it during templating:

```bash
helm template test-release chart --set ingress.enabled=true
```

## VS Code Helm Templates

The files in `chart/templates/` are Helm templates, not plain YAML. This workspace maps those files to the `helm` language in `.vscode/settings.json`.

If VS Code still shows lots of YAML errors in template files:

1. Install the `Helm Intellisense` extension (`tim-koehler.helm-intellisense`).
2. Reload the VS Code window.
3. Confirm the language mode for files in `chart/templates/` is `Helm`, not `YAML`.
