PART A – THEORY QUESTIONS

1. What is an IP Address?
An IP (Internet Protocol) address is a logical address assigned to a device on a network. It identifies the device and helps data reach the correct destination.

2. Why does every device require an IP Address?
Every device needs an IP address so it can be identified on a network, send data, and receive data from other devices.

3. What is IPv4?
IPv4 (Internet Protocol version 4) is a widely used addressing system that identifies devices using a 32-bit address.

4. How many bits are present in an IPv4 address?
An IPv4 address contains 32 bits.

5. What are Octets in an IPv4 address?
An IPv4 address is divided into four groups of 8 bits. Each 8-bit group is called an octet.

6. What is the valid range of each IPv4 octet?
Each octet can have a decimal value from 0 to 255, inclusive.

7. Differentiate between Public IP and Private IP.
A public IP address is globally routable on the Internet and is used to identify a network or device to other Internet systems. A private IP address is used inside a local network and is not directly routable across the public Internet. 

8. Give three examples of Private IP ranges.
The three IPv4 private address ranges are:
- 10.0.0.0/8 — 10.0.0.0 to 10.255.255.255
- 172.16.0.0/12 — 172.16.0.0 to 172.31.255.255
- 192.168.0.0/16 — 192.168.0.0 to 192.168.255.255

9. Who assigns a Public IP Address?
An Internet Service Provider (ISP) typically assigns a public IP address to a customer's Internet connection. In cloud environments, a cloud provider can allocate or associate public IP addresses with cloud resources.

10. What is DHCP and why is it used?
DHCP (Dynamic Host Configuration Protocol) automatically provides network configuration to devices. It reduces manual configuration and helps prevent address conflicts.

11. What information does DHCP automatically provide to devices?
DHCP can provide:
 IP address
 Default gateway
 DNS server addresses

12. What is a Default Gateway?
A default gateway is the router or next-hop device that a computer sends traffic to when the destination is outside its local network.

13. What role does a Router play in a network?
A router connects different networks and forwards packets between them. A home router commonly connects a local network to the ISP and may also perform NAT and provide DHCP.

14. Explain how a device accesses a website using ISP services.
A device first uses DNS to find the website's IP address. It checks whether that destination is on its local network. If it is not local, the device sends the traffic to its default gateway (usually the router). The router forwards it through the ISP and across the Internet to the destination server. The server's response returns through the network to the device. HTTPS encrypts the web session.


15. Why is IP Addressing important in DevOps and Cloud environments?
IP addressing allows servers, virtual machines, containers, and Kubernetes workloads to communicate. DevOps engineers use IP addresses and network ranges to configure VPCs, subnets, routing, firewalls/security groups, load balancers, service communication, and troubleshooting.


PART C – NETWORK ANALYSIS
Scenario 1
Laptop IP: 172.22.166.253

Answer: It is a Private IP address. 

Scenario 2
Mobile receives: 172.22.166.253 after connecting to Wi-Fi.

Answer: The address was most likely assigned by the network's DHCP server, commonly built into the Wi-Fi router. DHCP automatically leases an available IP address and can also provide the subnet mask, default gateway, and DNS server.

Scenario 3
Server IP: 157.51.214.124

Answer: This address is not in any of the three standard private IPv4 ranges, so it is a public IPv4 address. Internet users may be able to reach it directly if the address is routed to the server and the firewall/security rules and service configuration allow access. A public IP alone does not guarantee that a service is reachable.

Scenario 4
Laptop cannot access websites outside the local network.

Answer: Check the default gateway/router first. Confirm that the laptop has the correct default route and can reach the router. Also check the router's Internet connection, DNS configuration, and firewall rules. The gateway forwards traffic from the local network to external networks.

Scenario 5
A DevOps Engineer deploys an EC2 Instance, Docker Container and Kubernetes Pod. Why does each require an IP Address?

Answer: Each needs network addressing so it can send and receive traffic:
- EC2 Instance: Uses an IP address to communicate with other cloud resources and, when configured, external networks.
- Docker Container: Uses an IP address on its container network to communicate with other containers and services.
- Kubernetes Pod: Gets an IP address so workloads and cluster networking can route traffic to the Pod. Services provide stable access to changing Pod instances.
The exact networking model and whether addresses are private or public depend on the cloud and cluster configuration.