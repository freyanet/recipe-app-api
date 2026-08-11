# Define la imagen base de partida, en este caso es la imagen oficial de Python 3.9 basada en Alpine Linux 3.13:
FROM python:3.9-alpine3.13 
 
LABEL maintainer="freyanet" 

# Establece variables de entorno permanentes dentro del contenedor.
ENV PYTHONUNDBUFFERED=1

# Copiar archivos o carpetas desde tu maquina local al interior de la imagen:
COPY ./recipe-app-api/requirements.txt /tmp/requirements.txt 
COPY ./recipe-app-api/requirements.dev.txt /tmp/requirements.dev.txt
COPY ./recipe-app-api/app /app

# Fija el directorio de trabajo dentro del contenedor para los comandos siguientes:
WORKDIR /app 

# Indica los puertos de red que el contenedor escuchara en tiempo de ejecucion.
EXPOSE 8000 

ARG DEV=false

# Ejecutoa comandos de consola durante la fase de construccion.
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then \
        /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user
