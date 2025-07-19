# Bom Hamburguer App

Este é um aplicativo móvel (Android/iOS) desenvolvido em Flutter para simular um sistema de pedidos de hambúrgueres, incluindo funcionalidades de autenticação de usuário e gerenciamento de carrinho.

## Funcionalidades

O aplicativo "Bom Hamburguer" oferece as seguintes funcionalidades principais:

1.  **Autenticação de Usuário:**
    * **Login:** Os usuários podem fazer login com credenciais armazenadas localmente.
    * **Registro:** Novos usuários podem criar uma conta, salvando suas credenciais no armazenamento local.
    * **Redefinição de Senha:** Funcionalidade para redefinir a senha de um usuário existente.
    * **Persistência:** O status de login e as credenciais do usuário são persistidos localmente usando `shared_preferences`.

2.  **Listagem de Menu:**
    * Exibe uma lista de opções de sanduíches (`X Burger`, `X Egg`, `X Bacon`) com seus respectivos preços.
    * Exibe opções de extras (`Fries`, `Soft drink`) com seus preços.

3.  **Adição ao Carrinho:**
    * Permite adicionar sanduíches e extras ao carrinho.
    * **Regra de Quantidade:** Garante que cada pedido não contenha mais de um sanduíche, uma porção de batatas fritas ou um refrigerante. Mensagens de erro são exibidas se itens duplicados forem adicionados.

4.  **Visualização do Carrinho:**
    * Exibe todos os itens selecionados pelo usuário.
    * Mostra o **Subtotal** (soma dos preços dos itens).
    * Calcula e exibe o **Desconto** aplicado.
    * Apresenta o **Total a Pagar** após o desconto.

5.  **Regras de Desconto:**
    * **20% de Desconto:** Se o cliente selecionar um sanduíche, batatas fritas e refrigerante.
    * **15% de Desconto:** Se o cliente selecionar um sanduíche e refrigerante.
    * **10% de Desconto:** Se o cliente selecionar um sanduíche e batatas fritas.

6.  **Processo de Pagamento (Simulado):**
    * Permite que o usuário "pague" o pedido, exigindo apenas o nome do cliente.
    * Não há integração com gateways de pagamento reais.
    * Após o "pagamento", o carrinho é limpo e o usuário retorna à tela inicial.

## Tecnologias Utilizadas

* **Flutter:** Framework para desenvolvimento de aplicativos móveis nativos para Android e iOS.
* **Provider:** Gerenciamento de estado simples e eficiente para a aplicação.
* **`shared_preferences`:** Para armazenamento local persistente de dados de usuário (credenciais) e status de login.
* **`uuid`:** Para geração de IDs únicos para os pedidos.

## Como Executar o Projeto

Siga os passos abaixo para configurar e executar o aplicativo em sua máquina:

1.  **Clone o repositório:**
    ```bash
    git clone <URL_DO_SEU_REPOSITORIO>
    cd bom_hamburguer
    ```
    *(Substitua `<URL_DO_SEU_REPOSITORIO>` pelo link real do seu repositório GitHub, caso já tenha um.)*

2.  **Instale as dependências:**
    Certifique-se de que todas as dependências listadas no `pubspec.yaml` estão instaladas. Execute:
    ```bash
    flutter pub get
    ```

3.  **Execute o aplicativo:**
    ```bash
    flutter run
    ```
    O aplicativo será iniciado em um emulador, simulador ou dispositivo conectado.