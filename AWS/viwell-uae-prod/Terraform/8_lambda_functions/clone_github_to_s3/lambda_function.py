import os
import boto3
from datetime import datetime
import requests
import json

session = boto3.session.Session()
client = session.client(
    service_name='secretsmanager',
    region_name="me-central-1"
)
s3_client = session.client(service_name='s3')
def get_secret():
    try:
        get_secret_value_response = client.get_secret_value(
            SecretId='github'
        )
    except Exception as e:
        raise Exception("Error while retrieving secret: " + str(e))
    else:
        if 'SecretString' in get_secret_value_response:
            secret = get_secret_value_response['SecretString']
        else:
            secret = base64.b64decode(get_secret_value_response['SecretBinary'])

    secret_dict = json.loads(secret)
    return secret_dict

# usage
secrets = get_secret()
bucket_name = secrets['BUCKET_NAME']
#github_username = secrets['GITHUB_USERNAME']
github_token = secrets['GITHUB_TOKEN']
github_organization = secrets['GITHUB_ORGANIZATION']


def get_repos(org, token):
    headers = {'Authorization': f'token {token}'}
    url = f'https://api.github.com/orgs/{org}/repos'
    response = requests.get(url, headers=headers)
    return [repo['name'] for repo in response.json()]

def get_branches(org, repo, token):
    headers = {'Authorization': f'token {token}'}
    url = f'https://api.github.com/repos/{org}/{repo}/branches'
    response = requests.get(url, headers=headers)
    
    backup_branches = ['test', 'develop', 'main', 'master', 'staging']
    branch_names = [branch['name'] for branch in response.json()]

    # Only return branch names that are in the backup_branches list
    return [branch for branch in branch_names if branch in backup_branches]

def download_and_zip_branch(org, repo, branch, token):
    headers = {'Authorization': f'token {token}'}
    zip_url = f'https://api.github.com/repos/{org}/{repo}/zipball/{branch}'
    response = requests.get(zip_url, headers=headers)

    directory = f'/tmp/{repo}_{branch}'
    if not os.path.exists(directory):
        os.makedirs(directory)

    zip_file_path = f'{directory}/{repo}_{branch}.zip'
    with open(zip_file_path, 'wb') as f:
        f.write(response.content)
    
    return zip_file_path

def lambda_handler(event, context):
    repos = get_repos(github_organization, github_token)
    
    for repo_name in repos:
        branches = get_branches(github_organization, repo_name, github_token)
        for branch_name in branches:
            zip_file_path = download_and_zip_branch(github_organization, repo_name, branch_name, github_token)
        
            # upload the zip to S3
            date_string = datetime.now().strftime('%Y-%m-%d')
            s3_key = f'{repo_name}/{repo_name}_{branch_name}_{date_string}.zip'
            s3_client.upload_file(zip_file_path, bucket_name, s3_key)
        
            # clean up the temp directory
            os.remove(zip_file_path)

    return {
        'statusCode': 200,
        'body': f'Successfully backed up all repos and branches to S3'
    }
