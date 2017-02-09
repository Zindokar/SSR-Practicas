# - Borro la tabla
iptables -F

# - Reglas por defecto
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP

# - Acepto establecidas y relacionadas
iptables -A FORWARD -m state --state ESTABLISHED, RELATED -j ACCEPT

# - Permitir tráfico loopback
iptables -A INPUT -i lo -j ACCEPT

# - Tráfico saliente ICMP
iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
iptables -A FORWARD -i eth0 -o eth1 -p icmp --icmp-type echo-reply -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -p icmp --icmp-type echo-request -j ACCEPT 

# - Responder ICMP red interna
iptables -A INPUT -p icmp -s 10.110.7.0/24 -j ACCEPT

# - Dar acceso HTTP, HTTPS, DNS y Campus Virtual
# Pasarela
iptables -A INPUT -p tcp -m multiport --sport 53,80,443,8443 -j ACCEPT
# Workstation
iptables -A FORWARD -p tcp -m multiport --dport 53,80,443,8443 -m --state NEW -j ACCEPT

# - Aceptar SSH/SFTP en la pasarela desde red interna
iptables -A INPUT -p tcp --dport 22 -d 10.110.7.0/24 -m --state NEW -j ACCEPT

# - Permitir SSH a Neptuno: neptuno.redes.dis.ulpgc.es
# Workstation
iptables -A FORWARD -p tcp --dport 22 -d 10.110.1.24 -m --state NEW -j ACCEPT
iptables -A FORWARD -p tcp --dport 22 -d 10.110.1.24 -j LOG
iptables -A FORWARD -p tcp --sport 22 -s 10.110.1.24 -j LOG
