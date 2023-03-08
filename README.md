# Script de Backup Diário do PostgreSQL para Amazon S3

Este é um script de backup diário do PostgreSQL para o Amazon S3 que faz backup de todos os bancos de dados e verifica se o arquivo de backup é íntegro antes de enviá-lo para o S3. Este script pode ser facilmente configurado para ser executado diariamente usando o cron.

## Requisitos

Antes de começar a usar este script, você precisará ter o seguinte:

- PostgreSQL instalado e configurado corretamente
- Um usuário com permissão para fazer backup de todos os bancos de dados
- O utilitário `pg_dump` instalado
- O utilitário `pg_restore` instalado
- A ferramenta AWS CLI instalada e configurada com as credenciais corretas

## Instalando aws-cli no Debian/Ubuntu

1. Atualizar a lista de pacotes
    ```bash
    sudo apt-get update

2. Instalar o pacote awscli
    ```bash
    sudo apt-get install awscli

3. Verificar se o aws-cli foi instalado com sucesso
    ```bash
    aws --version
    
## Instalando aws-cli no RHEL/CentOS

1. Atualizar a lista de pacotes
    ```bash
    sudo yum update

2. Instalar o pacote awscli
    ```bash
    sudo yum install awscli

3. Verificar se o aws-cli foi instalado com sucesso
    ```bash
    aws --version

*Obs: Lembre-se de configurar suas credenciais da AWS após a instalação do aws-cli para que você possa autenticar as solicitações ao S3. Você pode fazer isso executando o seguinte comando:*
```bash
aws configure
```

## Configuração

1. Clone este repositório em seu sistema de backup local:

   ```bash
   git clone https://github.com/g-roliveira/postgresql-backup-to-s3.git

2. Para configurar o script, abra o arquivo `backup_postgres_s3.sh` em um editor de texto e atualize as seguintes variáveis:

- `BACKUP_DIR`: o diretório no qual o backup será salvo localmente
- `BUCKET_NAME`: o nome do bucket S3 para onde o backup será enviado
- `AWS_REGION`: a região do Amazon S3 em que o bucket está localizado
- `DATABASE_USERNAME`: o nome de usuário do banco de dados para o qual o backup será feito
- `DATABASE_PASSWORD`: a senha do usuário do banco de dados
Salve as alterações no arquivo.

3. Torne o script executável:
    ```bash
    chmod +x backup_postgres_s3.sh
    
4. Agende o script para ser executado diariamente, por exemplo, usando o cron no Linux. Adicione a seguinte linha ao arquivo cron para executar o script todos os dias às 3h da manhã:
    ```bash
    0 3 * * * /caminho/para/o/script.sh >/dev/null 2>&1
    
Certifique-se de substituir /caminho/para/o/script.sh pelo caminho para o arquivo backup.sh em seu sistema.


5. Execute o script manualmente para testar o backup:
    ```bash
    ./backup_postgres_s3.sh

Isso irá executar o backup de todos os bancos de dados e enviar os arquivos de backup para o bucket S3.
