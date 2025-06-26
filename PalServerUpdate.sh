tmux kill-session -t PalworldServer
cd /usr/lib/games/steam
steamcmd +force_install_dir=/home/steam/Steam/steamapps/common/PalServer +login anonymous +app_update 2394010 validate +quit
tmux new-session -d -s PalworldServer '/home/steam/PalServerStartTest.sh'