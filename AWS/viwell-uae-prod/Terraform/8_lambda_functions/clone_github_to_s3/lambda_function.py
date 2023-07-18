import os
import boto3
import tarfile
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
    
    # Now this will return all branches of the repository
    return [branch['name'] for branch in response.json()]

def download_branch(org, repo, branch, token):
    headers = {'Authorization': f'token {token}'}
    zip_url = f'https://api.github.com/repos/{org}/{repo}/zipball/{branch}'
    response = requests.get(zip_url, headers=headers)

    safe_branch_name = branch.replace('/', '_')  # Replace '/' with '_'
    directory = f'/tmp/{repo}_{safe_branch_name}'

    if not os.path.exists(directory):
        os.makedirs(directory)

    zip_file_path = f'{directory}/{repo}_{safe_branch_name}.zip'
    with open(zip_file_path, 'wb') as f:
        f.write(response.content)
    
    return directory, zip_file_path  # Return the path of the zip file

def create_tar_file(repo, directories):
    tar_file_path = f'/tmp/{repo}.tar.gz'
    with tarfile.open(tar_file_path, 'w:gz') as tar:
        for directory in directories:
            tar.add(directory, arcname=os.path.basename(directory))
    return tar_file_path

def lambda_handler(event, context):
    repos = get_repos(github_organization, github_token)
    
    for repo_name in repos:
        branches = get_branches(github_organization, repo_name, github_token)
        directories = []
        zip_files = []  # To store the paths of zip files
        for branch_name in branches:
            directory, zip_file_path = download_branch(github_organization, repo_name, branch_name, github_token)
            directories.append(directory)
            zip_files.append(zip_file_path)  # Store the path of the zip file
        
        tar_file_path = create_tar_file(repo_name, directories)

        # upload the tar to S3
        date_string = datetime.now().strftime('%Y-%m-%d')
        s3_key = f'{repo_name}/{repo_name}_{date_string}.tar.gz'
        s3_client.upload_file(tar_file_path, bucket_name, s3_key)
        
        # clean up the temp directory
        os.remove(tar_file_path)
        for zip_file in zip_files:  # Delete the zip files
            os.remove(zip_file)
        for directory in directories:
            os.rmdir(directory)  # Now you can delete the directory as it is empty

    return {
        'statusCode': 200,
        'body': f'Successfully backed up all repos and branches to S3'
    }