#!/usr/bin/env bash
set -euo pipefail

echo "--- commands ---"
for cmd in kubectl docker kind; do
  if command -v "${cmd}" >/dev/null 2>&1; then
    echo "${cmd}=$(command -v "${cmd}")"
  else
    echo "${cmd}=missing"
  fi
done

echo "--- docker desktop binaries ---"
find "/mnt/c/Program Files/Docker/Docker/resources/bin" -maxdepth 1 -iname 'kubectl*' -o -iname 'docker*' 2>/dev/null | sort || true

echo "--- kube config candidates ---"
ls -la "${HOME}/.kube" 2>/dev/null || true

if ! command -v kubectl >/dev/null 2>&1; then
  mkdir -p "${HOME}/.local/bin"
  if [[ -x "/mnt/c/Program Files/Docker/Docker/resources/bin/kubectl.exe" ]]; then
    cat > "${HOME}/.local/bin/kubectl" <<'WRAP'
#!/usr/bin/env bash
exec "/mnt/c/Program Files/Docker/Docker/resources/bin/kubectl.exe" "$@"
WRAP
    chmod +x "${HOME}/.local/bin/kubectl"
    echo "created kubectl wrapper at ${HOME}/.local/bin/kubectl"
  else
    echo "no Windows kubectl.exe found to wrap" >&2
  fi
fi

export PATH="${HOME}/.local/bin:${PATH}"

echo "--- kubectl check ---"
if command -v kubectl >/dev/null 2>&1; then
  kubectl version --client=true 2>&1 || true
  kubectl config current-context 2>&1 || true
else
  echo "kubectl still missing"
fi
