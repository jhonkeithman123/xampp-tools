# xampp-tools

copy the desired file and paste it in ".local/bin/"

ex.
    cd xampp-tools
    ls - to see the file names
    cp xampp-tools.sh ~/.local/bin/xampp-tools
    chmod +x ~/.local/bin/xampp-tools
    echo "set PATH $PATH ~/.local/bin" > (~/.bashrc = bash / ~/.config/fish/config.fish = fish)
    xampp start all