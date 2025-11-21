#!/usr/bin/env fish

set action $argv[1]
set argv (count $argv) > /dev/null; # keep $argv as rest
set services (if test (count $argv) -gt 1; echo $argv[2..-1]; else echo all; end)

function usage
  echo "Usage: xampp {start|stop|restart|status} {all|apache|mysql|proftpd} [more services...]"
  exit 1
end

if test -z "$action"
  usage
end

if not type -q netstat
  if type -q ss
    set TMPDIR (mktemp -d)
    cat > $TMPDIR/netstat <<'EOF'
#!/bin/sh
ss -nltup "$@" 2>/dev/null
EOF
    chmod +x $TMPDIR/netstat
    set -x PATH $TMPDIR $PATH
    # trap cleanup is not portable in fish script here
  else
    echo "Warning: netstat not found and ss not available; XAMPP may warn."
  end
end

for svc in $services
  switch $action
    case start
      switch $svc
        case all
          sudo /opt/lampp/lampp start
        case apache
          sudo /opt/lampp/lampp startapache
        case mysql
          sudo /opt/lampp/lampp startmysql
        case proftpd
          sudo /opt/lampp/lampp startproftpd
        case '*'
          usage
      end
    case stop
      switch $svc
        case all
          sudo /opt/lampp/lampp stop
        case apache
          sudo /opt/lampp/lampp stopapache
        case mysql
          sudo /opt/lampp/lampp stopmysql
        case proftpd
          sudo /opt/lampp/lampp stopproftpd
        case '*'
          usage
      end
    case status
      switch $svc
        case all
          sudo /opt/lampp/lampp status
        case apache
          sudo /opt/lampp/lampp statusapache
        case mysql
          sudo /opt/lampp/lampp statusmysql
        case proftpd
          sudo /opt/lampp/lampp statusproftpd
        case '*'
          usage
      end
    case restart
      switch $svc
        case all
          sudo /opt/lampp/lampp stop; sudo /opt/lampp/lampp start
        case apache
          sudo /opt/lampp/lampp stopapache; sudo /opt/lampp/lampp startapache
        case mysql
          sudo /opt/lampp/lampp stopmysql; sudo /opt/lampp/lampp startmysql
        case proftpd
          sudo /opt/lampp/lampp stopproftpd; sudo /opt/lampp/lampp startproftpd
        case '*'
          usage
      end
    case '*'
      usage
  end
end