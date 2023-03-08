#!/bin/bash

# Definindo as variáveis
BACKUP_DIR="/mnt/backups"
BUCKET_NAME="seu-bucket"
AWS_REGION="sua-regiao"
DATABASE_USERNAME="seu-usuario"
DATABASE_PASSWORD="sua-senha"

# Obter a lista de todos os bancos de dados
DATABASE_LIST=$(sudo -u postgres psql -tAc "SELECT datname FROM pg_database WHERE datistemplate = false")

# Loop para cada banco de dados
for DATABASE_NAME in $DATABASE_LIST
do
  # Definir o nome do arquivo de backup
  BACKUP_NAME="$DATABASE_NAME-$(date +'%Y-%m-%d').backup"

  # Executa o backup
  pg_dump -U $DATABASE_USERNAME -F c $DATABASE_NAME > $BACKUP_DIR/$BACKUP_NAME

  # Verifica se o backup foi criado com sucesso
  if [ $? -ne 0 ]; then
    echo "Erro ao criar backup do banco de dados $DATABASE_NAME"
    exit 1
  fi

  # Verifica se o backup é íntegro
  pg_restore --list $BACKUP_DIR/$BACKUP_NAME > /dev/null
  if [ $? -ne 0 ]; then
    echo "Backup do banco de dados $DATABASE_NAME está corrompido"
    exit 1
  fi

  # Faz upload do backup para o S3
  aws s3 cp $BACKUP_DIR/$BACKUP_NAME s3://$BUCKET_NAME/$BACKUP_NAME --region $AWS_REGION

  # Remove o backup local
  rm $BACKUP_DIR/$BACKUP_NAME
done
