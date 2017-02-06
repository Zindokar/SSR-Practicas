# - Borro la tabla
iptables -F

# - Regalas por defecto
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP

# - Permitir tráfico loopback
iptables -A INPUT -d 127.0.0.1 -s 127.0.0.1 -j ACCEPT

# - Tráfico saliente ICMP
iptables -A INPUT -p icmp --icmp-type 0 -j ACCEPT
iptables -A FORWARD -p icmp --icmp-type 0 -j ACCEPT

# - Responder ICMP red interna
iptables -A INPUT -p icmp --icmp-type 8 -d 0.110.7.0/24 -s 10.110.7.0/24 -j ACCEPT

# - Dar acceso HTTP, HTTPS y DNS
# Workstation
iptables -A FORWARD -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -p tcp --sport 80 -j ACCEPT
iptables -A FORWARD -p tcp --dport 443 -j ACCEPT
iptables -A FORWARD -p tcp --sport 443 -j ACCEPT
iptables -A FORWARD -p udp --dport 53 -j ACCEPT
iptables -A FORWARD -p udp --sport 53 -j ACCEPT
# Pasarela
iptables -A INPUT -p tcp --sport 80 -j ACCEPT
iptables -A INPUT -p tcp --sport 443 -j ACCEPT
iptables -A INPUT -p udp --sport 53 -j ACCEPT

# - Aceptar SSH/SFTP en la pasarela
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# - Permitir SSH a Neptuno: neptuno.redes.dis.ulpgc.es
# Workstation
iptables -A FORWARD -p tcp --dport 22 -d neptuno.redes.dis.ulpgc.es -j ACCEPT
iptables -A FORWARD -p tcp --sport 22 -s neptuno.redes.dis.ulpgc.es -j ACCEPT

# - Muestro la tabla
clear
iptables -L
