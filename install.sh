#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
install_dir="${XDG_DATA_HOME:-$HOME/.local/share}/mediafix"
bin_dir="${XDG_BIN_HOME:-$HOME/.local/bin}"
nautilus_dir="${XDG_DATA_HOME:-$HOME/.local/share}/nautilus/scripts"
dolphin_dir="${XDG_DATA_HOME:-$HOME/.local/share}/kservices5/ServiceMenus"

mkdir -p "$install_dir" "$bin_dir" "$nautilus_dir" "$dolphin_dir"
install -m 755 "$repo_dir/mediafix.py" "$install_dir/mediafix.py"

cat > "$bin_dir/mediafix" <<EOF
#!/bin/sh
exec /usr/bin/env python3 "$install_dir/mediafix.py" "\$@"
EOF
cat > "$bin_dir/mediafix-terminal" <<EOF
#!/bin/bash
set +e
mediafix "\$@"
status=\$?
printf '\\nГотово. Это окно закроется через 5 секунд. Нажмите любую клавишу, чтобы закрыть его сразу.\\n'
IFS= read -r -n 1 -t 5 _
exit "\$status"
EOF
cat > "$nautilus_dir/Prepare with mediafix" <<EOF
#!/bin/bash
exec "$install_dir/mediafix-nautilus" "\$@"
EOF
install -m 755 "$repo_dir/mediafix-nautilus" "$install_dir/mediafix-nautilus"
install -m 644 "$repo_dir/mediafix-dolphin.desktop" "$dolphin_dir/mediafix.desktop"
chmod 755 "$bin_dir/mediafix" "$bin_dir/mediafix-terminal" "$nautilus_dir/Prepare with mediafix"

echo "mediafix установлен: $bin_dir/mediafix"
echo "Nautilus: контекстное меню → Scripts → Prepare with mediafix"
echo "Dolphin: контекстное меню → Prepare for DaVinci Resolve (mediafix)"
case ":${PATH:-}:" in
  *:"$bin_dir":*) ;;
  *) echo "Добавьте $bin_dir в PATH: export PATH=\"$bin_dir:\$PATH\"" ;;
esac
