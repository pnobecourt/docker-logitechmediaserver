# logitechmediaserver

This is a Debian-based Logitech Media Server Docker image.

Create workdirs :

     mkdir -p /path/to/your/squeezebox/volume/squeeze /path/to/your/squeezebox/volume/squeeze/prefs /path/to/your/squeezebox/volume/squeeze/logs /path/to/your/squeezebox/volume/squeeze/cache /path/to/your/squeezebox/volume/playlists

Create container :

    docker run -d \
               --init \
               --restart always \
               --name logitechmediaserver \
               --hostname logitechmediaserver \
               -p 3483:3483/tcp
               -p 3483:3483/udp
               -p 5353:5353/tcp
               -p 5353:5353/udp
               -p 9000:9000/tcp
               -p 9005:9005/tcp
               -p 9010:9010/tcp
               -p 9090:9090/tcp
               -v /etc/timezone:/etc/timezone:ro \
               -v /etc/localtime:/etc/localtime:ro \
               -v /path/to/your/squeezebox/volume/squeeze/prefs:/srv/squeezebox/prefs:rw \
               -v /path/to/your/squeezebox/volume/squeeze/logs:/srv/squeezebox/logs:rw \
               -v /path/to/your/squeezebox/volume/squeeze/cache:/srv/squeezebox/cache:rw \
               -v /path/to/your/squeezebox/volume/playlists:/srv/playlists:rw \
               -v <audio-dir>:/your/music/dir:ro \ # you can add multiple audio dirs if you want, just add another -v <audio-dir-n>:/another/audio/dir:ro
               -u $( id -u <the-user-you-want> ):$( id -g <the-user-you-want> ) \ # or -u $( id -u $USER ):$( id -g $USER ) or -u <the-uid-you-want>:<the-gid-you-want>
               barbak/logitechmediaserver

Or docker-compose :

    version: "3.6"
    services:
        # Logitechmediaserver - LogitechMediaServer server
        logitechmediaserver:
            container_name: logitechmediaserver
            hostname: logitechmediaserver
            image: barbak/logitechmediaserver
            restart: always
            ports:
                - "3483:3483/tcp"
                - "3483:3483/udp"
                - "5353:5353/tcp"
                - "5353:5353/udp"
                - "9000:9000/tcp"
                - "9005:9005/tcp"
                - "9010:9010/tcp"
                - "9090:9090/tcp"
            volumes:
                - /etc/timezone:/etc/timezone:ro
                - /etc/localtime:/etc/localtime:ro
                - /srv/docker/volumes/logitechmediaserver/squeezebox/prefs:/srv/squeezebox/prefs
                - /srv/docker/volumes/logitechmediaserver/squeezebox/logs:/srv/squeezebox/logs
                - /srv/docker/volumes/logitechmediaserver/squeezebox/cache:/srv/squeezebox/cache
                - /srv/docker/volumes/logitechmediaserver/squeezebox/playlists:/srv/playlists
                - /home/public/Ambiances:/srv/ambiances:ro
                - /home/public/Musique:/srv/music:ro
                - /home/public/Videos:/srv/videos:ro

The web interface runs on port 9000.

List of exposed ports : 3483/tcp 3483/udp 5353/tcp 5353/udp 9000/tcp 9005/tcp 9010/tcp 9090/tcp
