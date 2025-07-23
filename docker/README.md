# Configuração do Ambiente Poupe.AI

## Como Executar

1. **Configure as Variáveis de Ambiente**

    Antes de iniciar, configure suas variáveis de ambiente no arquivo `.env` renomeando `.env.example` para `.env`.

    Exemplo:
    ```env
    # Configurações do Keycloak DB
    KEYCLOAK_DB=keycloak_db
    KEYCLOAK_DB_USER=keycloak
    KEYCLOAK_DB_PASSWORD=keycloak

    # Configurações do Finance Service DB
    FINANCE_DB=poupe_ai
    FINANCE_DB_USER=poupe_ai
    FINANCE_DB_PASSWORD=poupe_ai

    # Configurações do Keycloak Admin
    KEYCLOAK_ADMIN=admin
    KEYCLOAK_ADMIN_PASSWORD=admin

    # Google OAuth2 (Opcional)
    GOOGLE_CLIENT_ID=client_id
    GOOGLE_CLIENT_SECRET=client_secret

    # Configurações do Grafana
    GF_SECURITY_ADMIN_USER=admin
    GF_SECURITY_ADMIN_PASSWORD=admin

    # RabbitMQ Message Broker
    RABBITMQ_USER=user
    RABBITMQ_PASSWORD=password

    # Redis Cache
    REDIS_PASSWORD=password

    # Email credentials for notification service
    MAIL_USERNAME=seu-usuario-smtp
    MAIL_PASSWORD=sua-senha-smtp
    MAIL_FROM="poupeai.notificacoes@gmail.com"
    MAIL_FROM_NAME="Poupe.AI"
    MAIL_PORT=587
    MAIL_SERVER="smtp-relay.brevo.com"
    ```

2. **Obtenha e Configure a Chave Pública RSA do Keycloak**

O Kong Gateway precisa dessa chave para validar os tokens JWT gerados pelo Keycloak. Siga estes passos para obtê-la e configurá-la corretamente.

#### **Passo 1: Obtenha o Certificado do Keycloak**

1.  **Inicie os contêineres** do Keycloak, caso ainda não estejam rodando:

    ```sh
    docker-compose up -d keycloak keycloak-db
    ```

2.  **Aguarde** alguns instantes para o Keycloak iniciar completamente.

3.  **Acesse o endpoint de certificados** do seu realm. Você pode abrir o link no navegador ou usar um comando como `curl`:

    ```
    http://localhost:8080/realms/poupe-ai/protocol/openid-connect/certs
    ```

4.  **Copie o valor do certificado**. No JSON que for retornado, localize o primeiro objeto dentro do array `"keys"` que tenha `"alg": "RS256"`. Dentro deste objeto, copie o valor completo da propriedade `"x5c"`, que é uma longa string em Base64.

#### **Passo 2: Converta o Certificado para Chave Pública (PEM)**

Com o valor do `x5c` copiado, use o `openssl` no seu terminal para extrair a chave pública no formato PEM.

1.  Execute o comando abaixo, substituindo `SEU_CERTIFICADO_BASE64` pelo valor que você copiou:

    ```bash
    echo -e "-----BEGIN CERTIFICATE-----\nSEU_CERTIFICADO_BASE64\n-----END CERTIFICATE-----" | openssl x509 -pubkey -noout
    ```

2.  O resultado será a chave pública formatada, começando com `-----BEGIN PUBLIC KEY-----` e terminando com `-----END PUBLIC KEY-----`. **Copie o bloco inteiro**.

#### **Passo 3: Atualize o Arquivo de Configuração do Kong**

1.  Abra o arquivo `docker/kong/kong.yaml`.

2.  Localize a seção `consumers` e, dentro dela, o campo `rsa_public_key`.

3.  **Cole a chave PEM completa** que você gerou no passo anterior, substituindo a chave existente.

    **Atenção:** O formato YAML é sensível à indentação. A chave deve estar alinhada corretamente, conforme o exemplo abaixo. O caractere `|` indica que o valor a seguir é um bloco de texto de múltiplas linhas.

    **Exemplo de como deve ficar:**

    ```yaml
    consumers:
      - username: keycloak-consumer
        jwt_secrets:
          - key: http://localhost:8080/realms/poupe-ai
            algorithm: RS256
            rsa_public_key: |
              -----BEGIN PUBLIC KEY-----
              SUA_CHAVE_PUBLICA_GERADA_AQUI...
              E_AS_DEMAIS_LINHAS_DA_CHAVE...
              ...MANTENDO_A_INDENTACAO_CORRETA...
              -----END PUBLIC KEY-----
    ```

Após salvar o arquivo `kong.yaml` com a nova chave, o Kong estará pronto para validar os tokens quando for iniciado.

3. **Configure o Google OAuth2 (Opcional)**

    Se quiser usar login social com Google:
    
    - Acesse [Google Cloud Console](https://console.cloud.google.com/apis/credentials)
    - Configure OAuth consent screen
    - Crie credenciais OAuth 2.0
    - Adicione esta Redirect URI:
      ```
      http://localhost:8080/realms/poupe-ai/broker/google/endpoint
      ```
    - Cole o Client ID e Client Secret no arquivo `.env`

4. **Inicie os Contêineres**

    Execute:
    ```sh
    docker-compose up -d
    ```

5. **Acesse os Serviços**

    - **Keycloak Admin Console**: `http://localhost:8080/admin` (Usuário: KEYCLOAK_ADMIN e Senha: KEYCLOAK_ADMIN_PASSWORD)
    
    - **Kong Admin GUI**: `http://localhost:8002`
    
    - **Finances Service**: Acessível via Kong em `http://localhost:8000/finances`
    - **Reports Service**: Acessível via Kong em `http://localhost:8000/reports`
    - **Notification Service**: Em execução, mas sem UI. Os logs estão disponíveis no Grafana.

    - **Grafana (Logs)**: `http://localhost:3000`

    - **RabbitMQ Management**: `http://localhost:15672` (Use as credenciais do .env)

## Estrutura

- `docker-compose.yml`: Define todos os serviços.
- `.env`: Arquivo com as variáveis de ambiente.
- `/keycloak/themes`: Contém os temas customizados para as telas de login e registro do Poupe.AI.
- `/keycloak/realms`: Contém as configurações do realm "poupe-ai" que é importado na inicialização.
- `/kong/kong.yaml`: Contém a configuração declarativa do Kong.
- `/kong/plugins`: Contém o plugin customizado "jwt-header-injector" para o Kong.
- `/logging/grafana/provisioning/datasources/loki-datasource.yaml`: Contém a configuração do Loki como Data source do Grafana.
- `/logging/loki/loki-config.yaml`: Contém a configuração do Loki.
- `/logging/promtail/promtail-config.yaml`: Contém a configuração do Promtail.