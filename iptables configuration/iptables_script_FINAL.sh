# - Borro la tabla
iptables -F
iptables -t nat -F

# - Regla NAT para Proxy
iptables -t nat -A PREROUTING -p tcp -i eth1 -m multiport --dports 80 -j REDIRECT --to-port 3128

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
iptables -A OUTPUT -p tcp -m multiport --dports 22,25,53,80,143,443,445,4222,8443 -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p udp -m multiport --dports 53,445 -m state --state NEW -j ACCEPT

# - INPUT
iptables -A INPUT -i lo -m state --state NEW -j ACCEPT
iptables -A INPUT -p tcp --dport 3128 -m state --state NEW -j ACCEPT
iptables -A INPUT -i eth1 -s 10.110.7.0/24 -p icmp -m state --state NEW -j ACCEPT
iptables -A INPUT -i eth1 -s 10.110.7.0/24 -p tcp --dport 22 -m state --state NEW -j ACCEPT
iptables -A INPUT -p udp --dport 53 -m state --state NEW -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -i eth1 -s 10.110.7.0/24 -m state --state NEW -j ACCEPT

# - FORWARD
iptables -A FORWARD -p icmp -i eth1 -o eth0 -s 10.110.7.0/24 -m state --state NEW -j ACCEPT
iptables -A FORWARD -p tcp --dport 4222 -m state --state NEW -j LOG --log-prefix "SSH in da house:"
iptables -A FORWARD -p tcp -m multiport --dports 22,25,143,445,4222,8443 -m state --state NEW -j ACCEPT
iptables -A FORWARD -p udp -m multiport --dports 53,445 -m state --state NEW -j ACCEPT

