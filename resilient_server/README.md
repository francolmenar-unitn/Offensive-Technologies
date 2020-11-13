# Activities


##Red Team:

### Possible solutions for Denial Of Service
  1. SlowLoris attack => keeps the server's resource pool busy by slowly submitting requests with headers
    and never finishing.
    
     Script needs to be improved => maybe add multithreading ??
     Possible defense: reqtimeout module

  2. GoldenEye => keeps the server's connections alive by using HTTP Keep Alive + No Cache as attack vector.
    Possible defense:
        1. use hash limit in ip tables
        2. use snort rules to block Keep-Alive and No Cache

  3. apache2-utils => stress test the server with ab -c 200 -n 5000 -r <url>
    Possible defense: qos_module

  4. Traditional flooding tools like flooder or hping3
    Possible defense: hashlimit on iptables or rate_limit in snort.


##Blue Team:

### Useful defense commands
    
   1. who => checks for logged in users (in case of breaches).
   
   2. netstat -antp => check for suspicious stuff in active network connections.
        If anything is found close it with sudo kill <pid>
        
   3. netstat -la => check for currently listening and active ports in the system.
   
   4. last => checks for the record of logged in users.
   
   5. cat .bash_history => check bash activities and commands the users have run.
   
   6. crontab -l => check cron tabs for traces of reverse shells etc.
        ls -la /etc/cron.<daily, hourly, weekly> => check for time-repeat cron jobs.
        
   7. ps auxf => check for running processes. Kill everything that seems suspicious.
   
   8. cat /etc/passwd => check if suspicious user is added here.
   
   9. find / -mtime -o -ctime 1 => check for files modifies in the last day for anything suspicious.
   
   10. find / -perm -4000 -user root -type f => find suid files owned by root for suspicious activities.
   
   11. find / -perm -6000 -type f => find sigid files owned by root for suspicious acitivies.
   
   12. install chrootkit in order to detect rootkits.
            sudo apt install chrootkit
            sudo chrootkit => check if anything is out of the ordinary.
            
   13. Check log files in /var/log for anything suspicious.
            Use syslog to view log information.
            
   14. cat auth.log | less => logs for authentication attempts.
   
   15. cat kern | less => kernel logs.
   
   16. cat faillog | less => data on unsuccessful login attempts. Useful for finding knowledge on attempted
            security penetrations.
            
   17. cat cron | less => cron related messages.
   
   18. cat httpd | less => logs for apache2
   
   19. ss | grep ssh => check for active ssh connections
            If anything suspicious is found: sudo kill <pid of ssh session>

    Protection with either iptables or snort... (or both)
