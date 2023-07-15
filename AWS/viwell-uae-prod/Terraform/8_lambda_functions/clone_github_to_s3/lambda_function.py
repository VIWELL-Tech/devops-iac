import os
import boto3
from datetime import datetime
import subprocess
import shutil
import requests

s3_client = boto3.client('s3')
bucket_name = os.getenv('BUCKET_NAME')
github_username = os.getenv('GITHUB_USERNAME')
github_token = os.getenv('GITHUB_TOKEN')
ssh_private_key = os.getenv('SSH_PRIVATE_KEY')

def get_repos(username, token):
    headers = {'Authorization': f'token {token}'}
    url = f'https://api.github.com/users/{username}/repos'
    response = requests.get(url, headers=headers)
    return [repo['name'] for repo in response.json()]

def clone_and_zip_repo(repo_name, username):
    # create .ssh directory
    if not os.path.exists("/tmp/.ssh"):
        os.makedirs("/tmp/.ssh")
    
    # write private key to .ssh directory
    with open("/tmp/.ssh/id_rsa", 'w') as f:
        f.write(ssh_private_key)
    os.chmod("/tmp/.ssh/id_rsa", 0o600)
    
    # clone the repository
    git_url = f'git@github.com:{username}/{repo_name}.git'
    clone_dir = f'/tmp/{repo_name}'
    subprocess.check_call(['git', 'clone', git_url, clone_dir])
    
    # zip the directory
    zip_file_path = f'/tmp/{repo_name}.zip'
    shutil.make_archive(clone_dir, 'zip', clone_dir)
    
    return zip_file_path

def lambda_handler(event, context):
    repos = get_repos(github_username, github_token)
    
    for repo_name in repos:
        zip_file_path = clone_and_zip_repo(repo_name, github_username)
        
        # upload the zip to S3
        date_string = datetime.now().strftime('%Y-%m-%d')
        s3_key = f'{repo_name}_{date_string}.zip'
        s3_client.upload_file(zip_file_path, bucket_name, s3_key)
    
        # clean up the temp directory
        shutil.rmtree(f'/tmp/{repo_name}')
        os.remove(zip_file_path)
        os.remove("/tmp/.ssh/id_rsa")

    return {
        'statusCode': 200,
        'body': f'Successfully backed up all repos to S3'
    }
