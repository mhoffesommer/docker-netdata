# docker-phpservermonitor
Docker container for PHP Server Monitor (http://www.phpservermonitor.org/). 
Based upon Alpine Linux, with PHP5 FPM, MariaDB added.

## Ports
This image exposes port 80.

## Volumes
@@@

## Environment settings
@@@

## Usage

```
mkdir /var/lib/scm
chown 1000:1000 /var/lib/scm
@@@ docker run -v /var/lib/scm:/var/lib/scm -p 8080:8080 mhoffesommer/scm-manager
```
