# 1. Builder
FROM python:3.10-slim AS builder

# Set work directory inside container
WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy dependency file first
COPY app/backend/requirements.txt .

# Install Python dependencies into a temporary location
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# 2. Runtime
FROM python:3.10-slim

# Set work directory
WORKDIR /app

# ---- Environment settings ----
# Prevent Python from writing .pyc files
ENV PYTHONDONTWRITEBYTECODE=1
# Ensure logs are shown immediately
ENV PYTHONUNBUFFERED=1

# Hugging Face / Torch model cache (VERY IMPORTANT)
ENV TRANSFORMERS_CACHE=/models
ENV TORCH_HOME=/models

# Copy only installed dependencies from builder
COPY --from=builder /install /usr/local

# Copy application source code
COPY app/backend/ .

# Expose FastAPI port
EXPOSE 8000

# Start the application
CMD ["python", "main.py"]



#run by-
#docker build -t driveai-backend -f docker/backend/Dockerfile .
#docker run -p 8000:8000 driveai-backend
