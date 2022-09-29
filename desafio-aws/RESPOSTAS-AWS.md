# Desafio AWS

# Preparação Inicial

## 1 - Setup de ambiente

Criação da stack ocorreu normalmente de acordo com os comandos sugeridos. Mudei apenas o nome da stack, dessa vez para **stack-desafio**.

```
export STACK_FILE="file://formandodevops-desafio-aws.json"
export STACK_NAME="stack-desafio"
aws cloudformation create-stack --region us-east-1 --template-body "$STACK_FILE" --stack-name "$STACK_NAME" --no-cli-pager
aws cloudformation wait stack-create-complete --stack-name "$STACK_NAME"
```


## 2 - Networking

O Security Group da instância não estava permitindo acessos do tipo HTTP na porta 80. Criei um novo Security Group, dessa vez com as seguintes configurações:

![image](https://user-images.githubusercontent.com/85142222/192915748-db708039-db1b-42fa-b79a-68e93522e575.png)

Após isso, pude acessar a instância por meio do protocolo HTTP normalmente.

## 3 - EC2 Access

Para acessar a EC2 por SSH, você precisa de uma *key pair*, que **não está disponível**. Pesquise como alterar a key pair de uma EC2.

Após trocar a key pair

1 - acesse a EC2:
```
ssh -i [sua-key-pair] ec2-user@[ip-ec2]
```

2 - Altere o texto da página web exibida, colocando seu nome no início do texto do arquivo ***"/var/www/html/index.html"***.



## 4 - EC2 troubleshooting

No último procedimento, A EC2 precisou ser desligada e após isso o serviço responsável pela página web não iniciou. Encontre o problema e realize as devidas alterações para que esse **serviço inicie automaticamente durante o boot** da EC2.



## 5 - Balanceamento

Crie uma cópia idêntica de sua EC2 e inicie essa segunda EC2. Após isso, crie um balanceador, configure ambas EC2 nesse balancedor e garanta que, **mesmo com uma das EC2 desligada, o usuário final conseguirá acessar a página web.**



## 6 - Segurança

Garanta que o acesso para suas EC2 ocorra somente através do balanceador, ou seja, chamadas HTTP diretamente realizadas da sua máquina para o EC2 deverão ser barradas. Elas **só aceitarão chamadas do balanceador** e esse, por sua vez, aceitará conexões externas normalmente.
