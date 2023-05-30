# Config Sync

Run following command after clone this repo & change `SOURCE`, `DEST` & `LOGS`

```sh
sudo apt update
sudo apt install inotify-tools jq
sudo rsync -av ./file-update.sh /root/.script/file-update.sh
sudo rsync -av sync-file.service /etc/systemd/system/
```

After cloning enable this service

```sh
sudo systemctl daemon-reload
sudo systemctl enable sync-file.service
sudo systemctl is-enabled sync-file.service
```
