tmux kill-session -t ArkServer
cd /usr/lib/games/steam
steamcmd +force_install_dir=/home/steam/Steam/steamapps/common/7d2d +login anonymous +app_update 376030 validate +quit
tmux new-session -d -s ArkServer '/home/steam/ArkServerStart.sh'