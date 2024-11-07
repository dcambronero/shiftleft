#!/bin/bash

# Variables
REPO_URL="https://github.com/tu_usuario/tu_repositorio"
FILE_PATH="curl-7.79.0.tar.bz2"
DEST_DIR="curl-7.79.0"

# Descargar el archivo desde el repositorio
curl -L "$REPO_URL/raw/main/$FILE_PATH" -o "$FILE_PATH"

# Verificar si la descarga fue exitosa
if [ $? -ne 0 ]; then
  echo "Error al descargar el archivo $FILE_PATH"
  exit 1
fi

# Crear el directorio de destino si no existe
mkdir -p "$DEST_DIR"

# Extraer el archivo en el directorio de destino
tar -xjf "$FILE_PATH" -C "$DEST_DIR" --strip-components=1

# Verificar si la extracción fue exitosa
if [ $? -ne 0 ]; then
  echo "Error al extraer el archivo $FILE_PATH"
  exit 1
fi

# Eliminar el archivo descargado para limpiar
rm "$FILE_PATH"

echo "El archivo $FILE_PATH ha sido descargado y extraído en el directorio $DEST_DIR"
