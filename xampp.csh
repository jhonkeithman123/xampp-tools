#!/bin/csh -f

set action = "$1"
shift

if ("$action" == "") then
  echo "Usage: xampp {start|stop|restart|status} {all|apache|mysql|proftpd} [more services...]"
  exit 1
endif

# netstat wrapper using ss if needed
which netstat >/dev/null 2>&1
if ($status != 0) then
  which ss >/dev/null 2>&1
  if ($status == 0) then
    set TMPDIR = `mktemp -d`
    cat > "$TMPDIR/netstat" <<'EOF'
#!/bin/sh
ss -nltup "$@" 2>/dev/null
EOF
    chmod +x "$TMPDIR/netstat"
    setenv PATH "${TMPDIR}:$PATH"
    # No easy trap cleanup in portable csh script
  else
    echo "Warning: netstat not found and ss not available; XAMPP may warn."
  endif
endif

if ($#argv == 0) then
  set services = (all)
else
  set services = ($argv)
endif

foreach svc ($services)
  switch ($action)
    case start:
      switch ($svc)
        case all:    sudo /opt/lampp/lampp start; breaksw
        case apache: sudo /opt/lampp/lampp startapache; breaksw
        case mysql:  sudo /opt/lampp/lampp startmysql; breaksw
        case proftpd: sudo /opt/lampp/lampp startproftpd; breaksw
        default: echo "Unknown service: $svc"; exit 1; breaksw
      endsw
      breaksw
    case stop:
      switch ($svc)
        case all:    sudo /opt/lampp/lampp stop; breaksw
        case apache: sudo /opt/lampp/lampp stopapache; breaksw
        case mysql:  sudo /opt/lampp/lampp stopmysql; breaksw
        case proftpd: sudo /opt/lampp/lampp stopproftpd; breaksw
        default: echo "Unknown service: $svc"; exit 1; breaksw
      endsw
      breaksw
    case status:
      switch ($svc)
        case all:    sudo /opt/lampp/lampp status; breaksw
        case apache: sudo /opt/lampp/lampp statusapache; breaksw
        case mysql:  sudo /opt/lampp/lampp statusmysql; breaksw
        case proftpd: sudo /opt/lampp/lampp statusproftpd; breaksw
        default: echo "Unknown service: $svc"; exit 1; breaksw
      endsw
      breaksw
    case restart:
      switch ($svc)
        case all:
          sudo /opt/lampp/lampp stop
          sudo /opt/lampp/lampp start
          breaksw
        case apache:
          sudo /opt/lampp/lampp stopapache
          sudo /opt/lampp/lampp startapache
          breaksw
        case mysql:
          sudo /opt/lampp/lampp stopmysql
          sudo /opt/lampp/lampp startmysql
          breaksw
        case proftpd:
          sudo /opt/lampp/lampp stopproftpd
          sudo /opt/lampp/lampp startproftpd
          breaksw
        default: echo "Unknown service: $svc"; exit 1; breaksw
      endsw
      breaksw
    default:
      echo "Unknown action: $action"; exit 1
  endsw
end