import boto3

# Setup AWS S3 client
session = boto3.Session(
    # aws_session_token=SESSION_TOKEN,  # if applicable
    region_name='us-east-1'
)
s3 = session.client('s3')

BUCKET_NAME = 'production-viwell-media'

# Mapping from file extensions to content types
content_type_mapping = {
    '.jpg': 'image/jpeg',
    '.jpeg': 'image/jpeg',
    '.png': 'image/png',
    '.gif': 'image/gif',
    '.bmp': 'image/bmp',
    '.mp3': 'audio/mpeg'  # added mp3
}

def is_image(key):
    return any(key.lower().endswith(ext) for ext in ['.jpg', '.jpeg', '.png', '.gif', '.bmp'])

def is_audio(key):
    return key.lower().endswith('.mp3')

def get_content_type(key):
    for ext, content_type in content_type_mapping.items():
        if key.lower().endswith(ext):
            return content_type
    return None

def main():
    paginator = s3.get_paginator('list_objects_v2')
    page_iterator = paginator.paginate(Bucket=BUCKET_NAME)

    for page in page_iterator:
        if 'Contents' in page:
            for obj in page['Contents']:
                key = obj['Key']
                if is_image(key) or is_audio(key):
                    # Get the current content type
                    response = s3.head_object(Bucket=BUCKET_NAME, Key=key)
                    current_content_type = response['ContentType']

                    # Get the correct content type based on the file extension
                    correct_content_type = get_content_type(key)

                    if current_content_type != correct_content_type:
                        print(f"Changing content type for {key} from {current_content_type} to {correct_content_type}")
                        copy_source = {'Bucket': BUCKET_NAME, 'Key': key}
                        s3.copy_object(Bucket=BUCKET_NAME, CopySource=copy_source, Key=key, ContentType=correct_content_type, MetadataDirective='REPLACE')

if __name__ == "__main__":
    main()