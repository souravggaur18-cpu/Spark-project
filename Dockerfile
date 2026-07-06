# Use a base image with Java (required for Spark)
FROM eclipse temruin:11-jre

# Install Python and pip
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    wget \
    tar \
    gzip \
    && rm -rf /var/lib/apt/lists/*

# Install PySpark
RUN pip install pyspark

# Set environment variables for Spark
ENV SPARK_VERSION=3.5.0
ENV SPARK_HOME=/opt/spark
ENV PATH="${PATH}:${SPARK_HOME}/bin"

# Download and extract Spark
RUN wget https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz -O /tmp/spark.tgz \
    && tar -xvf /tmp/spark.tgz -C /opt \
    && mv /opt/spark-${SPSPARK_VERSION}-bin-hadoop3 ${SPARK_HOME} \
    && rm /tmp/spark.tgz

# Create a directory for the application
WORKDIR /app

# Copy the Spark application script
COPY spark_app.py .

# Copy the data file. Ensure 'tips (1).csv' is in the same directory as the Dockerfile when you build the image.
COPY "tips (1).csv" .

# Define the command to run the Spark application
CMD ["spark-submit", "spark_app.py"]
