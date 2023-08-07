#!/bin/sh
# Based on Flyctl installer: Based on Deno installer: Copyright 2019 the Deno authors. All rights reserved. MIT license.
# TODO(everyone): Keep this script simple and easily auditable.

set -e

main() {
	os=$(uname -s)
	arch=$(uname -m)
	version=${1:-latest}

	tool_install="${TOOL_INSTALL:-$HOME/.tool_g}"
	bin_dir="$tool_install/bin"
	tmp_dir="$tool_install/tmp"
	exe="$bin_dir/tool_g"

	mkdir -p "$bin_dir"
	mkdir -p "$tmp_dir"

	az storage blob download --container-name release --name $version/tool_g.gz -f "$tmp_dir/tool_g.gz"
	# extract to tmp dir so we don't open existing executable file for writing:
	gunzip -kdf "$tmp_dir/tool_g.gz"
	chmod +x "$tmp_dir/tool_g"
	# atomically rename into place:
	mv "$tmp_dir/tool_g" "$exe"
	rm "$tmp_dir/tool_g.gz"

	echo "tool_g was installed successfully to $exe"
	if command -v tool_g >/dev/null; then
		echo "Run 'tool_g --help' to get started"
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
