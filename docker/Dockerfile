FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    OMP_NUM_THREADS=1 \
    MKL_NUM_THREADS=1 \
    OPENBLAS_NUM_THREADS=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl tini libgomp1 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# deps primero (mejor cache)
COPY requirements.txt /app/requirements.txt
RUN pip install --upgrade pip && pip install -r /app/requirements.txt

# proyecto
COPY pyproject.toml MANIFEST.in /app/
COPY src /app/src
RUN pip install .

# crea usuario y /data con permisos ANTES de cambiar de usuario
RUN useradd -m appuser && install -d -o appuser -g appuser /data
VOLUME ["/data"]

USER appuser
# Copiar el app.py
COPY app.py /app/app.py

ENTRYPOINT ["/usr/bin/tini","--"]
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "5000"]