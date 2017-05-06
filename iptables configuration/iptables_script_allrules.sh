# - Borro la tabla
iptables -F

# - Reglas por defecto
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP

# - Permitir tráfico loopback
iptables -A INPUT -i lo -j ACCEPT

# - Tráfico saliente ICMP
iptables -A INPUT -p icmp -i eth0 --icmp-type echo-reply -j ACCEPT
iptables -A INPUT -p icmp -s 10.110.7.0/24 -j ACCEPT # icmp red interna
iptables -A FORWARD -i eth1 -o eth0 -p icmp --icmp-type echo-request -j ACCEPT 
iptables -A FORWARD -i eth0 -o eth1 -p icmp --icmp-type echo-reply -j ACCEPT

# - Dar acceso HTTP, HTTPS, DNS y Campus Virtual
# Pasarela
iptables -A INPUT -p tcp --sport 80 -j ACCEPT
iptables -A INPUT -p tcp --sport 443 -j ACCEPT
iptables -A INPUT -p udp --sport 53 -j ACCEPT
iptables -A INPUT -p tcp --sport 8443 -j ACCEPT
# Workstation
iptables -A FORWARD -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -p tcp --sport 80 -j ACCEPT
iptables -A FORWARD -p tcp --dport 443 -j ACCEPT
iptables -A FORWARD -p tcp --sport 443 -j ACCEPT
iptables -A FORWARD -p udp --dport 53 -j ACCEPT
iptables -A FORWARD -p udp --sport 53 -j ACCEPT
iptables -A FORWARD -p tcp --dport 8443 -j ACCEPT
iptables -A FORWARD -p tcp --sport 8443 -j ACCEPT

# - Aceptar SSH/SFTP en la pasarela desde red interna
iptables -A INPUT -p tcp --sport 22 -s 10.110.7.0/24 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -d 10.110.7.0/24 -j ACCEPT

# - Permitir SSH a Neptuno: neptuno.redes.dis.ulpgc.es
# Workstation
iptables -A FORWARD -p tcp --dport 22 -d 10.110.1.24 -j LOG --log-prefix "SSH in da house:"
iptables -A FORWARD -p tcp --dport 22 -d 10.110.1.24 -j ACCEPT
iptables -A FORWARD -p tcp --sport 22 -s 10.110.1.24 -j ACCEPT

