FROM mongo:5.0

# Install necessary tools and AWS CLI
RUN apt-get update -y && \
    apt-get install -y curl python3-pip && \
    pip3 install --upgrade pip && \
    pip3 install awscli

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
