#!/bin/bash

action="$1"
service="$2"

function usage() {
  echo "Usage: xampp {start|stop|restart|status} {all|apache|mysql|proftpd}"
}

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
  restart)
    sudo /opt/lampp/lampp stop
    sudo /opt/lampp/lampp start
    echo "✅ XAMPP restarted (Apache, MySQL, ProFTPD)"
    ;;
  status)
    sudo /opt/lampp/lampp status
    ;;
  *)
    usage
    ;;
esac
