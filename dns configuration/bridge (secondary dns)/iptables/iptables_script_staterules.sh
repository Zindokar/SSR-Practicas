# - Borro la tabla
iptables -F

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
iptables -A OUTPUT -p tcp -m multiport --dports 53,80,443,8443 -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -m state --state NEW -j ACCEPT

# - INPUT
iptables -A INPUT -i lo -m state --state NEW -j ACCEPT
iptables -A INPUT -i eth1 -s 10.110.7.0/24 -p icmp -m state --state NEW -j ACCEPT
iptables -A INPUT -i eth1 -s 10.110.7.0/24 -p tcp --dport 22 -m state --state NEW -j ACCEPT
iptables -A INPUT -p udp --dport 53 -m state --state NEW -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -i eth1 -s 10.110.7.0/24 -m state --state NEW -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT

# - FORWARD
iptables -A FORWARD -p icmp -i eth1 -o eth0 -s 10.110.7.0/24 -m state --state NEW -j ACCEPT
iptables -A FORWARD -p tcp -m multiport --dports 80,443,8443 -m state --state NEW -j ACCEPT
iptables -A FORWARD -p udp --dport 53 -m state --state NEW -j ACCEPT
iptables -A FORWARD -p tcp --dport 22 -d 10.110.1.24 -m state --state NEW -j LOG --log-prefix "SSH in da house:"
iptables -A FORWARD -p tcp --dport 22 -d 10.110.1.24 -m state --state NEW -j ACCEPT

