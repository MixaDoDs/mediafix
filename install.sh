#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
install_dir="${XDG_DATA_HOME:-$HOME/.local/share}/mediafix"
bin_dir="${XDG_BIN_HOME:-$HOME/.local/bin}"

mkdir -p "$install_dir" "$bin_dir"
install -m 755 "$repo_dir/mediafix.py" "$install_dir/mediafix.py"
cat > "$bin_dir/mediafix" <<EOF
#!/bin/sh
exec /usr/bin/env python3 "$install_dir/mediafix.py" "\$@"
EOF
chmod 755 "$bin_dir/mediafix"

echo "mediafix установлен: $bin_dir/mediafix"
case ":${PATH:-}:" in
  *:"$bin_dir":*) ;;
  *) echo "Добавьте $bin_dir в PATH, например:"; echo "  export PATH=\"$bin_dir:\$PATH\"" ;;
esac
