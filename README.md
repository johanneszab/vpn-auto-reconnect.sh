# vpn-auto-reconnect.sh

A simple bash script for autoreconnect to OpenVPN via NetworkManager command-line (nmcli).

---

## Usage:

1. Clone the repository:
```bash
git clone https://github.com/johanneszab/vpn-auto-reconnect.sh.git
```

2. Change directory inside that directory:
```bash
cd vpn-auto-reconnect.sh
```

3. Make the script **executable**
```bash
chmod +x vpn-auto-reconnect.sh
```

4. Copy `vpn-config-sample.sh` to `vpn-config.sh`. Simply run
```bash
cp vpn-config-sample.sh vpn-config.sh
```

5. Configure `vpn-config.sh`. All the needed info on how to do that, is shown in the **config comments**.

6. Start monitoring VPN connection
```bash
./vpn-auto-reconnect.sh start
``` 

7. Stop the monitoring and also the VPN connection
```bash
./vpn-auto-reconnect.sh stop
```

---

## Source:

[**nmcli**](https://wiki.gnome.org/Projects/NetworkManager/nmcli)

[**Source**](http://www.gabsoftware.com/tips/automatically-reconnect-to-your-vpn-on-linux/)

[**Fork from**](https://gist.github.com/antoniy/f925ae55410a092c9e75/) with changes for nmcli v0.9.10.

Script tested on fedora 21 with airvpn (OpenVPN).

---

# vpn-toggle.sh

A simple bash script to toggle an OpenVPN connection on and off via NetworkManager command-line (mncli). You can use it instead of typing `vpn-auto-reconnect.sh start/stop`:
```bash
chmod +x vpn-toggle.sh
./vpn-toggle.sh
```
