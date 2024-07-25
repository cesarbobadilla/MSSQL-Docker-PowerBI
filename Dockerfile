# Use the official Microsoft SQL Server image
FROM mcr.microsoft.com/mssql/server:2022-latest
# Set environment variables for SQL Server
ENV ACCEPT_EULA=Y
ENV MSSQL_SA_PASSWORD=Pass@word
# Change to root user
USER root
# Install necessary packages and Ngrok
RUN apt-get update && \
    apt-get install -y mssql-tools unixodbc-dev && \
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc && \
    apt-get install -y wget unzip && \
    wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz && \
    tar -xvzf ngrok-v3-stable-linux-amd64.tgz && \
    mv ngrok /usr/local/bin && \
    rm ngrok-v3-stable-linux-amd64.tgz && \
    apt-get clean
# Create Ngrok configuration directory and file
RUN mkdir -p /root/.ngrok2 && \
    echo "version: 2\nauthtoken: 2gjpZ20KeQn6TLtZMH6VBEd8s7G_3R2QgNAsychmu4HNY8gw9" > /root/.ngrok2/ngrok.yml
# Expose the ports
EXPOSE 1433 4040
# Add a script to run both SQL Server and Ngrok
COPY run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh
# Start SQL Server and Ngrok using the script
CMD ["bash", "/usr/local/bin/run.sh"]
