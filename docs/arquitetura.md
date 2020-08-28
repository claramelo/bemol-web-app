# Arquitetura

A arquitetura proposta para este desafio foi pensanda considerando a automatização do processo de provisionamento e manutenção da infraestrutura e a segurança da aplicação.

O processo de provisionamento e manutenção da infra é feito no CircleCi utilizando Terraform e Ansible, por isso foi necessário prover uma solução que não permitisse o acesso direto da ferramenta de CI/CD ao cluster, dessa forma criei uma máquina que funciona como uma ponte chamada `deploy-swarm`, a partir dela é exutada toda e qualquer interação com o cluster. 

Para garantir mais segurança foram criados security-groups que delimitam o acesso aos recursos da aws, protejendo a aplicação de acessos externos que não sejam as requisições a aplicação na porta 8080, conexões ssh com a máquina `deploy-swarm` e conexões entre os elementos do cluster.

A imagem abaixo ilustra o funcionamento da arquitetura proposta:

![Arquitetura](/docs/arquitetura.png)

