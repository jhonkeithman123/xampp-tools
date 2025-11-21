#!/bin/zsh

action="$1"
shift || true

usage() { echo "Usage: xampp {start|stop|restart|status} {all|apache|mysql|proftpd} [more services...]"; exit 1; }

if ! command -v netstat >/dev/null 2>&1; then
  if command -v ss >/dev/null 2>&1; then
    TMPDIR="$(mktemp -d)"
    cat > "$TMPDIR/netstat" <<'EOF'
#!/bin/sh
ss -nltup "$@" 2>/dev/null
EOF
    chmod +x "$TMPDIR/netstat"
    PATH="$TMPDIR:$PATH"
    trap 'rm -rf "$TMPDIR"' EXIT
  else
    echo "Warning: netstat not found and ss not available; XAMPP may warn."
  fi
fi

handle_service() {
  local action=$1 service=$2
  case $action in
    start)
      case $service in
        all) sudo /opt/lampp/lampp start ;;
        apache) sudo /opt/lampp/lampp startapache ;;
        mysql) sudo /opt/lampp/lampp startmysql ;;
        proftpd) sudo /opt/lampp/lampp startproftpd ;;
        *) usage ;;
      esac ;;
    stop)
      case $service in
        all) sudo /opt/lampp/lampp stop ;;
        apache) sudo /opt/lampp/lampp stopapache ;;
        mysql) sudo /opt/lampp/lampp stopmysql ;;
        proftpd) sudo /opt/lampp/lampp stopproftpd ;;
        *) usage ;;
      esac ;;
    status)
      case $service in
        all) sudo /opt/lampp/lampp status ;;
        apache) sudo /opt/lampp/lampp statusapache ;;
        mysql) sudo /opt/lampp/lampp statusmysql ;;
        proftpd) sudo /opt/lampp/lampp statusproftpd ;;
        *) usage ;;
      esac ;;
    restart)
      case $service in
        all)
          sudo /opt/lampp/lampp stop
          sudo /opt/lampp/lampp start
          ;;
        apache)
          sudo /opt/lampp/lampp stopapache
          sudo /opt/lampp/lampp startapache
          ;;
        mysql)
          sudo /opt/lampp/lampp stopmysql
          sudo /opt/lampp/lampp startmysql
          ;;
        proftpd)
          sudo /opt/lampp/lampp stopproftpd
          sudo /opt/lampp/lampp startproftpd
          ;;
        *) usage ;;
      esac ;;
    *) usage ;;
  esac
}

[ -z "$action" ] && usage
services=("$@")
[ ${#services[@]} -eq 0 ] && services=(all)

for svc in "${services[@]}"; do
  handle_service "$action" "$svc"
done