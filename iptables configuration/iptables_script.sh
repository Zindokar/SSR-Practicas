# - Borro la tabla
iptables -F

# - Activo logs
iptables -N LOGs

# - Reglas por defecto
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP

# - Permitir tráfico loopback
iptables -A INPUT -i lo -j ACCEPT

# - Tráfico saliente ICMP
iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
iptables -A FORWARD -p icmp --icmp-type echo-reply -j ACCEPT

# - Responder ICMP red interna
iptables -A INPUT -p icmp -s 10.110.7.0/24 -j ACCEPT

# - Dar acceso HTTP, HTTPS, DNS y Campus Virtual
# Workstation
iptables -A FORWARD -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -p tcp --sport 80 -j ACCEPT
iptables -A FORWARD -p tcp --dport 443 -j ACCEPT
iptables -A FORWARD -p tcp --sport 443 -j ACCEPT
iptables -A FORWARD -p udp --dport 53 -j ACCEPT
iptables -A FORWARD -p udp --sport 53 -j ACCEPT
iptables -A FORWARD -p tcp --dport 8443 -j ACCEPT
iptables -A FORWARD -p tcp --sport 8443 -j ACCEPT
# Pasarela
iptables -A INPUT -p tcp --sport 80 -j ACCEPT
iptables -A INPUT -p tcp --sport 443 -j ACCEPT
iptables -A INPUT -p udp --sport 53 -j ACCEPT
iptables -A INPUT -p tcp --sport 8443 -j ACCEPT

# - Aceptar SSH/SFTP en la pasarela desde red interna
iptables -A INPUT -p tcp --dport 22 -s 10.110.7.0/24 -j ACCEPT

# - Permitir SSH a Neptuno: neptuno.redes.dis.ulpgc.es
# Workstation
iptables -A FORWARD -p tcp --dport 22 -d neptuno.redes.dis.ulpgc.es -j ACCEPT
iptables -A FORWARD -p tcp --dport 22 -d neptuno.redes.dis.ulpgc.es -j LOGs
iptables -A FORWARD -p tcp --sport 22 -s neptuno.redes.dis.ulpgc.es -j ACCEPT
iptables -A FORWARD -p tcp --sport 22 -s neptuno.redes.dis.ulpgc.es -j LOGs

# - Muestro la tabla
clear
iptables -L -v
