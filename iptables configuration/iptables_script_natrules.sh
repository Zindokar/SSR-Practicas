# - Borro las tablas
iptables -F
iptables -t nat -F

# - Reglas por defecto
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# - Acepto establecidas y relacionadas
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

# - OUTPUT
iptables -A OUTPUT -o lo -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p icmp -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p tcp -m multiport --dports 80,443,8443 -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -m state --state NEW -j ACCEPT

# - INPUT
iptables -A INPUT -i lo -m state --state NEW -j ACCEPT
iptables -A INPUT -i eth1 -s 192.168.120.0/24 -p icmp -m state --state NEW -j ACCEPT
iptables -A INPUT -i eth1 -s 192.168.120.0/24 -p tcp --dport 22 -m state --state NEW -j ACCEPT

# - FORWARD
iptables -A FORWARD -p icmp -i eth1 -o eth0 -s 192.168.120.0/24 -m state --state NEW -j ACCEPT
iptables -A FORWARD -p tcp -m multiport --dports 80,443,8443 -m state --state NEW -j ACCEPT
iptables -A FORWARD -p udp --dport 53 -m state --state NEW -j ACCEPT
iptables -A FORWARD -p tcp --dport 22 -d 10.110.1.24 -m state --state NEW -j LOG --log-prefix "SSH in da house:"
iptables -A FORWARD -p tcp --dport 22 -d 10.110.1.24 -m state --state NEW -j ACCEPT

# - Postrouting, redirijo workstation a internet
iptables -t nat -A POSTROUTING -o eth0 -j SNAT --to 10.110.1.7

# - Prerouting, redirijo internet a workstation puerto 80
iptables -t nat -A PREROUTING -p tcp -d 10.110.1.7 --dport 80 -j DNAT --to 192.168.120.2:80

