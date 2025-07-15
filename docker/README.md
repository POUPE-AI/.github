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
    ```

2. **Configure o Google OAuth2 (Opcional)**

    Se quiser usar login social com Google:
    
    - Acesse [Google Cloud Console](https://console.cloud.google.com/apis/credentials)
    - Configure OAuth consent screen
    - Crie credenciais OAuth 2.0
    - Adicione esta Redirect URI:
      ```
      http://localhost:8080/realms/poupe-ai/broker/google/endpoint
      ```
    - Cole o Client ID e Client Secret no arquivo `.env`

3. **Inicie os Contêineres**

    Execute:
    ```sh
    docker-compose up -d
    ```

4. **Acesse os Serviços**

    - **Keycloak Admin Console**: `http://localhost:8080/admin` (Usuário: KEYCLOAK_ADMIN e Senha: KEYCLOAK_ADMIN_PASSWORD)
    
    - **Kong Admin GUI**: `http://localhost:8002`
    
    - **Finances Service**: Acessível via Kong em `http://localhost:8000/finances`
    - **Reports Service**: Acessível via Kong em `http://localhost:8000/reports`

## Estrutura

- `docker-compose.yml`: Define todos os serviços.
- `.env`: Arquivo com as variáveis de ambiente.
- `/keycloak/themes`: Contém os temas customizados para as telas de login e registro do Poupe.AI.
- `/keycloak/realms`: Contém as configurações do realm "poupe-ai" que é importado na inicialização.
- `/kong/kong.yaml`: Contém a configuração declarativa do Kong.
- `/kong/plugins`: Contém o plugin customizado "jwt-header-injector" para o Kong. 