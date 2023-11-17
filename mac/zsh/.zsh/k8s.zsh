# Kubernetes:
alias kubectl="k8s-ctx-show; kubectl"
. ~/.kubectl_aliases
alias kprod="kubectl --namespace production"
alias kst="kubectl --namespace staging"
alias kl='kubectl logs -f'
alias kgpa='kubectl get pods --all-namespaces -owide'
