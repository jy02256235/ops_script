#!/bin/sh
mkdir -pv ~/.ssh && touch authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5ldELLenleil/9UTiWPNe5Z3pHoxCB/K9UU6jUgoHp4nAc4H5gh50tpnMAcgSHKqG3mlIZSaVkV6w3JrkY+y7Yjslvjglfp6+5whgwokuwagvi5w5uiVsHp8rsyXg0LlkHeIZMcwluQOC6C4tvDGXLqTG6XPk3Ih+ihW0Co4PLPM07lgWMnSTTpxjo258lMWOwPrLZvUziIvdHrzXDELD/SCwP/YbLAvjcL4u97MPnqy42rm/+6XUslyZp2Oq99P5+dt9lN/88Va8f+6lP6nTGQU+bqMtbEsgTiqrjU1k4poC05JRj1zB4djxwhJ+ATm/rqrMoVNDuLY/IwpAMh6x ihefe-kimi@ihefe-kimi.local" >>~/.ssh/authorized_keys
chmod 600 ~/.ssh/*
chmod 700 ~/.ssh
