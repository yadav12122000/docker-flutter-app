# mydockerun

Flutter with docker using Docker API. 

## Getting Started

This project will integrate docker with our application.

## Steps to follow:

1. Start the docker service
2. Edit the configuration file  /usr/lib/systemd/system/docker.service  file and edit "ExecStart" line.
with content "-H tcp://your_client_ip:any_port"
![Screenshot (397)](https://user-images.githubusercontent.com/69167025/129798052-2dfd20ee-3d28-4811-aaf7-11501e31159b.png)

3. Reload the daemon : systemctl daemon-reload
4. Then restart the docker service: systemctl restart docker
5. Install httpd and start httpd service
6. Create a file in /var/www/cgi-bin/filename.py
7. ![Screenshot (399)](https://user-images.githubusercontent.com/69167025/129798684-0aa7af16-9d0c-4912-90d5-a226e69eb78b.png)
8. Restart the httpd service.
9. Use the API's to connect with docker and httpd and enjoy the services.
