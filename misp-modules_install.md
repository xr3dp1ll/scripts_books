# :rocket:  automat script install misp-module

## Install misp-modules & install misp-modules.service
```bash
cd /var/www && sudo mkdir -p /var/www/.config && sudo chown -R www-data:www-data /var/www/.config \
&& echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc \
&& sudo -u www-data virtualenv -p python3 /var/www/MISP/venv \
&& curl -sSL https://install.python-poetry.org | python3 - \
&& sudo -H -u www-data /var/www/MISP/venv/bin/pip install setuptools==65.5.1 \
&& sudo -H -u www-data /var/www/MISP/venv/bin/pip install misp-modules[all] \
&& sudo tee /etc/systemd/system/misp-modules.service > /dev/null <<EOF
[Unit]
Description=MISP modules
After=network.target

[Service]
Type=simple
User=www-data
Group=www-data
ExecStart=/var/www/MISP/venv/bin/misp-modules -l 127.0.0.1
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF
```

## Enable service  & start & check status
```bash
sudo systemctl daemon-reexec 
sudo systemctl daemon-reload
sudo systemctl enable --now misp-modules.service
sleep 5 && sudo systemctl status misp-modules.service
```
