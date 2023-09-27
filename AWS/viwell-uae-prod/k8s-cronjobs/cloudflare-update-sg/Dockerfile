# Use an official Python runtime as a parent image
#FROM python:3.8-slim-buster
FROM amazon/aws-cli:latest
# Install AWS CLI
#RUN pip install --no-cache-dir awscli
#RUN apt-get update -y && apt-get install curl -y
COPY update_security_group.sh /update_security_group.sh
RUN chmod +x /update_security_group.sh
ENTRYPOINT ["/update_security_group.sh"]
