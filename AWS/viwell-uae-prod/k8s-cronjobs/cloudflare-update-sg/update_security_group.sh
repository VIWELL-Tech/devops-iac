#!/bin/bash

# Ensure necessary environment variables are set
if [[ -z "$SECURITY_GROUP_ID" || -z "$AWS_REGION" ]]; then
  echo "ERROR: SECURITY_GROUP_ID and AWS_REGION must be set."
  exit 1
fi

# Fetch the Cloudflare IPs
CLOUDFLARE_IPS_V4=$(curl -s https://www.cloudflare.com/ips-v4)
CLOUDFLARE_IPS_V6=$(curl -s https://www.cloudflare.com/ips-v6)

# Add new IPv4 rules
for ip in $CLOUDFLARE_IPS_V4; do
  for port in 80 443; do
     aws ec2 authorize-security-group-ingress --group-id $SECURITY_GROUP_ID --protocol tcp --port $port --cidr "$ip" --region $AWS_REGION
  done
done

# Add new IPv6 rules
for ip in $CLOUDFLARE_IPS_V6; do
  for port in 80 443; do
	  aws ec2 authorize-security-group-ingress   --group-id $SECURITY_GROUP_ID  --ip-permissions IpProtocol=tcp,FromPort=$port,ToPort=$port,Ipv6Ranges="[{CidrIpv6="$ip"}]" --region $AWS_REGION

  done
done