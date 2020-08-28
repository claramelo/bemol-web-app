# Setup da Aplicação

Para rodar esse projeto você deve ter uma conta na [AWS](https://aws.amazon.com/pt/), no [CicleCi](https://circleci.com/vcs-authorize/), no [DockerHub](https://hub.docker.com/) e gerar um tokn de acesso no GitHub

## Configurando a AWS

Neste projeto usaremos a AWS como nossa plataforma de cloud, portanto precisamos criar um usuário que deve ter permissão para criar e destruir recursos na plataforma.
Após criar sua conta acesse o [IAM](https://console.aws.amazon.com/iam/home?#/users) e [crie um usuário](https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/id_users_create.html#id_users_create_console), este usuário
não precisa ter acesso ao console e precisa possuar a permissão de Administrador, procure por 'AdministratorAccess' na etapa de atribuição de permissões. Ao final do
cadastro salve o arquivo .csv que contém as seguintes crendenciais `AWS_ACCESS_KEY_ID` e `AWS_SECRET_ACCESS_KEY`.

Acesse o [S3](https://s3.console.aws.amazon.com/s3/home?region=us-east-1#) e crie um bucket chamado `bemol-infrastructure`, este bucket guardará o arquivo de estado do terraform.

## Configurando o [DockerHub](https://hub.docker.com/)

Apenas crie uma conta na plataforma e salve o seu usuário e senha.

## Criando o token de acesso no Github
Siga este [tutorial](https://docs.github.com/pt/github/authenticating-to-github/creating-a-personal-access-token) para criar um token de acesso ao Github e selecione apenas a opção repo.

## Configurando o CircleCi

Utilizaremo o CircleCi como ferramenta de CI/CD. Realize o cadastro associando o github em que o projeto será clonado e crie um [contexto](https://circleci.com/docs/2.0/contexts/#creating-and-using-a-context) com o seguinte nome `common-credentials`. Um contexto é uma
funcionalidade do circleci que nos pemite compartilhar variáveis entre diferentes projetos. Você deve criar as seguintes variáveis dentro deste contexto:
``` 
AWS_ACCESS_KEY_ID=<Chave de acesso da AWS>
AWS_SECRET_ACCESS_KEY=<Secret da chave de acesso da AWS>		
DOCKER_PASS=<Senha do Dockerhub>	
DOCKER_USER=<Usuário do Dockerhub>	
GITHUB_TOKEN=<Token do Github>	
REPO_OWNER=<Seu usuário no GitHub>
```
De acordo com a arquitetura proposta, é necessário forncer uma chave ssh para viabilizar o acesso do Circleci à máquina `deploy-swarm` dentro da nossa arquitetura da AWS. Para isso copie chave que está neste [repositório](https://github.com/claramelo/bemol-teste-infra-tools/blob/master/ansible/keys/circle-ci-key.pem)
e adicione-a ao CircleCi, sem o nome no host. Para realizar essa tarefa siga o seguinte [tutorial](https://circleci.com/docs/2.0/add-ssh-key/) a partir do segundo passo.

Adicione os seguintes repositórios a sua conta do Github [bemol-teste-infra-tools](https://github.com/claramelo/bemol-teste-infra-tools) e [bemol-web-app](https://github.com/claramelo/bemol-web-app). Acesse o repositório web-app e altere na linha 5 do arquivo `docker-compose.production.yml`
o nome da imagem docker trocando `mclaramelo` pelo seu usuário do DockerHub.

Após ter feitos essas mudanças, acesse o CircleCi na aba de projetos e configure primeiro o projeto bemol-teste-infra-tools, para que este possa gerar as imagens docker que serão utilizadas para
provisionar a infraestrutura da aplicação, basta clicar em `Setup project`, depois em `Use exiting config` e por último clique em `Start building`. Após as imagens swarm-cluster-provider e provision-infra serem adicionadas ao Dockerhub, realize o mesmo processo para
o projeto bemol-web-app. Acompanhe a execução dos jobs pelo painel do CircleCi, o último passo do CI desse projeto é o deploy.

Quando o deploy estiver concluído acesse o apainel de EC2 da aws, na região da virginia `us-east-1`, e acesse o ip publico das máquinas com o prefixo bemol-swarm-worker na porta 8080
