tmux kill-session -t 7d2dServer
cd /usr/lib/games/steam
steamcmd +force_install_dir=/home/steam/Steam/steamapps/common/7d2d +login anonymous +app_update 294420 validate +quit
tmux new-session -d -s 7d2dServer '/home/steam/7d2dServerStart.sh'