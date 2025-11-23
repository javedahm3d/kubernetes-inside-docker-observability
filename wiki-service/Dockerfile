FROM python:3.13-slim

WORKDIR /app

# Install curl for healthcheck support
RUN apt-get update && apt-get install -y curl && apt-get clean

# Copying dependency files
COPY pyproject.toml poetry.lock* /app/

# Installing poetry
RUN pip install --no-cache-dir poetry

# Installing dependencies
RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi --no-root

# copying the rest of project code
COPY . /app

EXPOSE 8000

# Start the API
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
