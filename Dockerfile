# Use a base image with Java (required for Spark)
FROM eclipse-temurin:11-jre



# Install Python, pip, and venv tools
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    wget \
    tar \
    gzip \
    && rm -rf /var/lib/apt/lists/*

# Create a virtual environment and put it in the PATH
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install PySpark inside the virtual environment
RUN pip install --no-cache-dir pyspark


# Download and extract Spark (Fixed the SPSPARK_VERSION typo here)
RUN wget https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz -O /tmp/spark.tgz \
    && tar -xvf /tmp/spark.tgz -C /opt \
    && mv /opt/spark-${SPARK_VERSION}-bin-hadoop3 ${SPARK_HOME} \
    && rm /tmp/spark.tgz

# Create a directory for the application
WORKDIR /app

# Copy the Spark application script
COPY spark_app.py .

# Copy the data file. Ensure 'tips (1).csv' is in the same directory as the Dockerfile when you build the image.
COPY "tips (1).csv" .

# Define the command to run the Spark application
CMD ["spark-submit", "spark_app.py"]




