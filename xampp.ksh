#!/bin/ksh

action="$1"
shift || true

usage() { printf "Usage: xampp {start|stop|restart|status} {all|apache|mysql|proftpd} [more services...]\n"; exit 1; }

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
    printf "Warning: netstat not found and ss not available; XAMPP may warn.\n"
  fi
fi

handle_service() {
  action="$1"; service="$2"
  case "$action" in
    start)
      case "$service" in
        all) sudo /opt/lampp/lampp start ;;
        apache) sudo /opt/lampp/lampp startapache ;;
        mysql) sudo /opt/lampp/lampp startmysql ;;
        proftpd) sudo /opt/lampp/lampp startproftpd ;;
        *) usage ;;
      esac ;;
    stop)
      case "$service" in
        all) sudo /opt/lampp/lampp stop ;;
        apache) sudo /opt/lampp/lampp stopapache ;;
        mysql) sudo /opt/lampp/lampp stopmysql ;;
        proftpd) sudo /opt/lampp/lampp stopproftpd ;;
        *) usage ;;
      esac ;;
    status)
      case "$service" in
        all) sudo /opt/lampp/lampp status ;;
        apache) sudo /opt/lampp/lampp statusapache ;;
        mysql) sudo /opt/lampp/lampp statusmysql ;;
        proftpd) sudo /opt/lampp/lampp statusproftpd ;;
        *) usage ;;
      esac ;;
    restart)
      case "$service" in
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

if [ -z "$action" ]; then usage; fi

services=("$@")
if [ "${#services[@]}" -eq 0 ]; then services=(all); fi

for svc in "${services[@]}"; do
  handle_service "$action" "$svc"
done