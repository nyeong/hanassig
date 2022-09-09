# 키보드 레이아웃 커스텀하기 (with kmonad)

```
sudo usermod -aG input $USER
sudo groupadd uinput
sudo usermod -aG uinput $USER

echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' | sudo tee /etc/udev/rules.d/90-uinput.rules
```

```
$ mkdir ~/.config/kmonad
$ touch ~/.config/kmonad/aero13.kbd
```

```clojure
(defcfg
  input (device-file "/dev/input/by-path/platform-i8042-serio-0-event-kbd")
  output (uinput-sink "KMonad output")
)
```

- `/dev/input/by-id`: plugged-in
- `/dev/input/by-path`: internel
