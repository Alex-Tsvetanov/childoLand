#!/usr/bin/env bash
# Run the built kindergarten jar with .env-provided DB credentials.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

ENV_FILE="${PROJECT_DIR}/.env"
[[ -f "$ENV_FILE" ]] || { echo "Missing ${ENV_FILE}. Run scripts/setup-macos.sh first." >&2; exit 1; }

# Load .env (export every assignment)
set -o allexport
# shellcheck disable=SC1090
source "$ENV_FILE"
set +o allexport

export JAVA_HOME="$(/usr/libexec/java_home -v 17)"

JAR="$(ls -1 "${PROJECT_DIR}/target/"*.jar 2>/dev/null | grep -v '\.original$' | head -1)"
[[ -n "$JAR" ]] || { echo "No jar in target/. Run: mvn -DskipTests package" >&2; exit 1; }

exec "${JAVA_HOME}/bin/java" -jar "$JAR" "$@"
