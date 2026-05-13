# Architecture Details

## Components
1. **On-Premises Network (Simulated)**:
   - VPC: `192.168.0.0/16`
   - Public Subnet: `192.168.1.0/24` (VPN Server)
   - Private Subnet: `192.168.2.0/24`

2. **AWS Cloud**:
   - VPC: `10.0.0.0/16`
   - Public Subnet: `10.0.1.0/24` (Test Instance)
   - Private Subnet: `10.0.2.0/24`

3. **Connectivity**:
   - Site-to-Site VPN between VPCs.
   - Transit Gateway for inter-VPC routing.

4. **Security**:
   - Network Firewall blocking SSH traffic.
   - VPC Flow Logs stored in S3.