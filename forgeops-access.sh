#!/usr/bin/env bash
# Expone el ingress del minikube forgeops-lab en 127.0.0.1:443 y :80 para que
# https://forgeops26.example.com funcione desde Windows (WSL reenvía localhost).
# Necesita sudo porque los puertos < 1024 son privilegiados.
# Requiere en C:\Windows\System32\drivers\etc\hosts:  127.0.0.1 forgeops26.example.com
set -e
export KUBECONFIG="$(cd "$(dirname "$0")" && pwd)/.kubeconfig-minikube"
[ "$(kubectl config current-context)" = "forgeops-lab" ] || { echo "Contexto inesperado: $(kubectl config current-context)"; exit 1; }
echo "Port-forward activo en https://forgeops26.example.com (Ctrl+C para cortar)"
exec sudo -E "$(command -v kubectl)" port-forward --address 127.0.0.1 \
  -n ingress-nginx svc/ingress-nginx-controller 443:443 80:80
