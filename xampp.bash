#!/bin/bash

action="$1"
service1="$2"
service2="$3"

function usage() {
  echo "Usage: xampp {start|stop|restart|status} {all|apache|mysql|proftpd} [apache|mysql|proftpd](optional)"
}

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

#* Will execute first
handle_service "$action" "$service1"

#* Then execute the second service if provided
if [[ -n "$service2" && "$action" != "start" && "$action" != "stop" ]]; then
  handle_service "$action" "$service2"
fi