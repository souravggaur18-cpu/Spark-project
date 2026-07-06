from pyspark.sql import SparkSession
from pyspark.sql.functions import col, round

# Create a SparkSession
spark = SparkSession.builder.appName("TipsDataset").getOrCreate()

print("SparkSession created successfully!")

# Load the tips.csv dataset into a Spark DataFrame
# The file path assumes the CSV is in the same directory as the script inside the container
tips_df = spark.read.csv('/app/tips (1).csv', header=True, inferSchema=True)

tips_df.printSchema()

# Create a new column 'Tip_percentage'
tips_df = tips_df.withColumn(
    "Tip_percentage",
    round((col("tip") / col("total_bill")) * 100, 2)
)

# Display the DataFrame with the new column (optional, for verification inside container logs)
tips_df.show(10)

# Save the dataframe in parquet format
tips_df.write.mode("overwrite").parquet("/app/tips_output.parquet")

print("DataFrame saved to /app/tips_output.parquet")

# Stop the SparkSession
spark.stop()