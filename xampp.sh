#!/bin/bash

action="$1"
shift || true

function usage() {
  echo "Usage: xampp {start|stop|restart|status} {all|apache|mysql|proftpd} [apache|mysql|proftpd](optional)"
}

# Wrapper (if netstat is missing and ss exists)
if ! command -v netstat >/dev/null 2>&1; then
  if command -v ss >/dev/null 2>&1; then
    TMPDIR="${mktemp -d}"
    cat > "$TMPDIR/netstat" <<'EOF'
#!/bin/sh
# netstat wrapper using ss to avoid "command not found" warnings.
# This attempts to mimic common netstat usage used by scripts (e.g. -tulpn).
# We ignore the header differences; presence of a command is what matters.
ss -nltup "$@" 2>/dev/null
EOF
    chmod +x "$TMPDIR/netstat"
    export PATH="$TMPDIR:$PATH"
    trap 'rm -rf "$TMPDIR"' EXIT
  else
    echo "Warning: netstat not found and ss not available; XAMPP may warn."
  fi
fi

function handle_service() {
  local action="$1"
  local service="$2"

  case "$action" in
    start)
      case "$service" in
        all) sudo /opt/lampp/lampp start ;;
        apache) sudo /opt/lampp/lampp startapache ;;
        mysql) sudo /opt/lampp/lampp startmysql ;;
        proftpd) sudo /opt/lampp/lampp startproftpd ;;
        *) usage ;;
      esac
      ;;
    stop)
      case "$service" in
        all) sudo /opt/lampp/lampp stop ;;
        apache) sudo /opt/lampp/lampp stopapache ;;
        mysql) sudo /opt/lampp/lampp stopmysql ;;
        proftpd) sudo /opt/lampp/lampp stopproftpd ;;
        *) usage ;;
      esac
      ;;
    status)
      case "$service" in
        all) sudo /opt/lampp/lampp status ;;
        apache) sudo /opt/lampp/lampp statusapache ;;
        mysql) sudo /opt/lampp/lampp statusmysql ;;
        proftpd) sudo /opt/lampp/lampp statusproftpd ;;
        *) usage ;;
      esac
      ;;
    restart)
      case "$service" in
        all)
          sudo /opt/lampp/lampp stop
          sudo /opt/lampp/lampp start
          echo "✅ XAMPP restarted (Apache, MySQL, ProFTPD)"
          ;;
        apache)
          sudo /opt/lampp/lampp stopapache
          sudo /opt/lampp/lampp startapache
          echo "🔁 Apache restarted"
          ;;
        mysql)
          sudo /opt/lampp/lampp stopmysql
          sudo /opt/lampp/lampp startmysql
          echo "🔁 MySQL restarted"
          ;;
        proftpd)
          sudo /opt/lampp/lampp stopproftpd
          sudo /opt/lampp/lampp startproftpd
          echo "🔁 ProFTPD restarted"
          ;;
        *) usage ;;
      esac
      ;;
    *)
      usage
      ;;
  esac
}

# If no action provided
if [[ -z "$action" ]]; then
  usage
fi

# collect services (default to all)
services=("$@")
if [[ "${#services[@]}" -eq 0 ]]; then
  service={all}
fi

# Run the action for each requested services
for svc in "${services[@]}"; do
  handle_service "$action" "$svc"
done