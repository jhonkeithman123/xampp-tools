function xampp
  set action $argv[1]
  set service $argv[2]

  switch $action
    case start
      switch $service
        case all
          sudo /opt/lampp/lampp start
        case apache
          sudo /opt/lampp/lampp startapache
        case mysql
          sudo /opt/lampp/lampp startmysql
        case proftpd
          sudo /opt/lampp/lampp startproftpd
        case '*'
          echo "Usage: xampp start {all|apache|mysql|proftpd}"
      end
    case stop
      switch $service
        case all
          sudo /opt/lampp/lampp stop
        case apache
          sudo /opt/lampp/lampp stopapache
        case mysql
          sudo /opt/lampp/lampp stopmysql
        case proftpd
          sudo /opt/lampp/lampp stopproftpd
        case '*'
          echo "Usage: xampp stop {all|apache|mysql|proftpd}"
      end
    case restart
      sudo /opt/lampp/lampp stop
      sudo /opt/lampp/lampp start
      echo "✅ XAMPP restarted (Apache, MySQL, ProFTPD)"
    case status
      sudo /opt/lampp/lampp status
    case '*'
      echo "Usage: xampp {start|stop|restart|status} {all|apache|mysql|proftpd}"
  end
end
