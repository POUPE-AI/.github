# Configuração do Keycloak com Docker


## Como Executar

1.  **Configure as Variáveis de Ambiente**

    Antes de iniciar, é necessário configurar suas credenciais.

    - Renomeie o arquivo `.env.example` para `.env` e configure as variáveis:
      ```env
      # Configurações do PostgreSQL
      POSTGRES_DB=keycloak_db
      POSTGRES_USER=keycloak
      POSTGRES_PASSWORD=password

      # Configurações do Keycloak Admin
      KEYCLOAK_ADMIN=admin
      KEYCLOAK_ADMIN_PASSWORD=admin

      # Google OAuth2 (Opcional)
      GOOGLE_CLIENT_ID=client_id
      GOOGLE_CLIENT_SECRET=client_secret
      ```

2.  **Configure o Google OAuth2 (Opcional)**

    Se quiser usar login social com Google:
    
    - Acesse [Google Cloud Console](https://console.cloud.google.com/apis/credentials)
    - Configure OAuth consent screen
    - Crie credenciais OAuth 2.0
    - Adicione esta Redirect URI:
      ```
      http://localhost:8080/realms/poupe-ai/broker/google/endpoint
      ```
    - Cole o Client ID e Client Secret no arquivo `.env`

3.  **Inicie os Contêineres**

    Com as variáveis de ambiente configuradas, execute o seguinte comando para construir e iniciar os contêineres do Keycloak e do PostgreSQL:
    ```sh
    docker-compose up -d
    ```

4.  **Acesse o Console de Administração**

    - O console do Keycloak estará disponível em: `http://localhost:8080/admin`
    - Use as credenciais de administrador (`KEYCLOAK_ADMIN` e `KEYCLOAK_ADMIN_PASSWORD`) que você definiu no arquivo `.env` para fazer login.

## Estrutura

- `docker-compose.yml`: Define os serviços `keycloak` e `postgres`.
- `.env`: Arquivo com as variáveis de ambiente.
- `/themes`: Contém os temas customizados para as telas de login e registro do Poupe.AI.
- `/realms`: Contém as configurações do realm "poupe-ai" que é importado na inicialização. 