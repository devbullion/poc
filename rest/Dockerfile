# Use an official lightweight Python image from Docker Hub
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /rest_api

# Copy the requirements file
COPY requirements.txt .

# Install any dependencies specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code to the container
COPY . /rest_api

# Expose port 5000 (the default port for Flask)
EXPOSE 8080

# Set environment variables for Flask (optional)
ENV FLASK_APP=test_flask.py
ENV FLASK_ENV=production

# Run the application
CMD ["python", "test_flask.py", "--host=0.0.0.0"]