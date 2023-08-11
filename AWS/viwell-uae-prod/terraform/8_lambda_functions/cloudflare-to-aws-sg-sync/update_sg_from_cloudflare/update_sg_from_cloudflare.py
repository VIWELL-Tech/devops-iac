import json
import boto3
import requests
import os

# Fetch SECURITY_GROUP_IDS from environment variable and convert it into a list
SECURITY_GROUP_IDS = os.environ['SECURITY_GROUP_ID'].split(',')
REGION_NAME = os.environ['REGION_NAME']  # adjust as needed

def lambda_handler(event, context):
    # Fetch the current list of Cloudflare IP ranges
    response = requests.get('https://www.cloudflare.com/ips-v4')
    ips_v4 = response.text.split("\n")[:-1]

    response = requests.get('https://www.cloudflare.com/ips-v6')
    ips_v6 = response.text.split("\n")[:-1]

    ec2 = boto3.client('ec2', region_name=REGION_NAME)
    
    # Create new ingress rules based on Cloudflare IP ranges
    ip_permissions = [
        {'IpProtocol': 'tcp', 'FromPort': 80, 'ToPort': 80, 'IpRanges': [{'CidrIp': ip} for ip in ips_v4]},
        {'IpProtocol': 'tcp', 'FromPort': 443, 'ToPort': 443, 'IpRanges': [{'CidrIp': ip} for ip in ips_v4]},
        {'IpProtocol': 'tcp', 'FromPort': 80, 'ToPort': 80, 'Ipv6Ranges': [{'CidrIpv6': ip} for ip in ips_v6]},
        {'IpProtocol': 'tcp', 'FromPort': 443, 'ToPort': 443, 'Ipv6Ranges': [{'CidrIpv6': ip} for ip in ips_v6]}

    ]

    # Loop over each security group ID
    for sg_id in SECURITY_GROUP_IDS:
        # Get the current ingress rules
        sg = ec2.describe_security_groups(GroupIds=[sg_id])
        current_rules = sg['SecurityGroups'][0]['IpPermissions']

        # Remove all current ingress rules
        if current_rules:
            ec2.revoke_security_group_ingress(GroupId=sg_id, IpPermissions=current_rules)

        # Add new ingress rules
        ec2.authorize_security_group_ingress(GroupId=sg_id, IpPermissions=ip_permissions)

