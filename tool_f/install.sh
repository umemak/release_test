#!/bin/sh
# Based on Flyctl installer: Based on Deno installer: Copyright 2019 the Deno authors. All rights reserved. MIT license.
# TODO(everyone): Keep this script simple and easily auditable.

set -e

main() {
	os=$(uname -s)
	arch=$(uname -m)
	version=${1:-latest}

	az_cmd="az storage blob download --container-name release --name tool_f.gz -f ./tool_f.gz"

	tool_install="${TOOL_INSTALL:-$HOME/.tool_f}"

	bin_dir="$tool_install/bin"
	tmp_dir="$tool_install/tmp"
	exe="$bin_dir/tool_f"

	mkdir -p "$bin_dir"
	mkdir -p "$tmp_dir"

	az storage blob download --container-name release --name tool_f.gz -f "$tmp_dir/tool_f.gz"
	# extract to tmp dir so we don't open existing executable file for writing:
	gunzip -kdf "$tmp_dir/tool_f.gz"
	chmod +x "$tmp_dir/tool_f"
	# atomically rename into place:
	mv "$tmp_dir/tool_f" "$exe"
	rm "$tmp_dir/tool_f.gz"

	if [ "${1}" = "prerel" ] || [ "${1}" = "pre" ]; then
		"$exe" version -s "shell-prerel"
	else
		"$exe" version -s "shell"
	fi

	echo "tool_f was installed successfully to $exe"
	if command -v tool_f >/dev/null; then
		echo "Run 'tool_f --help' to get started"
	else
		case $SHELL in
		/bin/zsh) shell_profile=".zshrc" ;;
		*) shell_profile=".bash_profile" ;;
		esac
		echo "Manually add the directory to your \$HOME/$shell_profile (or similar)"
		echo "  export FLYCTL_INSTALL=\"$flyctl_install\""
		echo "  export PATH=\"\$FLYCTL_INSTALL/bin:\$PATH\""
		echo "Run '$exe --help' to get started"
	fi
}

main "$1"
