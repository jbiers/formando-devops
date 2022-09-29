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

O Security Group da instância não estava permitindo acessos do tipo HTTP na porta 80. Na imagem abaixo é possível notar que permitia entradas em portas acima da 80, e vindas somente do ip 0.0.0.0. Para resolver o problema, criei um novo Security Group, dessa vez permitindo requisições à porta 80 vindas de qualquer local da internet.

![image](https://user-images.githubusercontent.com/85142222/192915748-db708039-db1b-42fa-b79a-68e93522e575.png)

Após isso, pude acessar a instância por meio do protocolo HTTP normalmente.

## 3 - EC2 Access

Primeiramente, verifiquei que no Security Group da instância não existia uma regra permitindo o recebimento de requisições na porta 22 do tipo SSH. Portanto, criei, de forma a permitir apenas que meu IP pessoal conseguisse este acesso.

Em seguida, para fazer com que a instância EC2 (vamos chamá-la de A) reconhecesse minha já existente chave "key.pem", criei uma nova instância (vamos chamá-la de B), que por padrão utiliza a chave key.pem.

Em seguida, desliguei a instância A, removi seu volume, e coloquei-o na instância B, à qual eu possuia acesso. Entrei na máquina B via SSH, e nela executei os seguintes comandos:

```
sudo mount /dev/xvdf1 /mnt
cp ~/.ssh/authorized_keys /mnt/home/ec2-user/.ssh/authorized_keys
```

Assim, montei o volume da instância A na instância B, e copiei a lista de chaves autorizadas da instância B para ele. Em seguida, desliguei a máquina B, removi o volume original da máquina A, e coloquei de volta nela. Assim, após ligá-la novamente, foi possível acessar a máquina A via SSH usando a chave key.pem:

![image](https://user-images.githubusercontent.com/85142222/192916678-2e8b73e4-e182-4d4c-a7d2-8a9596a368f0.png)

## 4 - EC2 troubleshooting

Os seguintes comandos foram rodados na instância para permitir que o serviço *httpd* fosse inicializado durante após o boot da máquina:

```
sudo systemctl enable httpd

sudo systemctl start httpd
```

Assim, mesmo após o reboot da máquina, consigo continuar a acessá-la normalmente.

![image](https://user-images.githubusercontent.com/85142222/192917428-59fe8766-e4ba-4056-9ef3-2a5715b9a6f9.png)

## 5 - Balanceamento

Crie uma cópia idêntica de sua EC2 e inicie essa segunda EC2. Após isso, crie um balanceador, configure ambas EC2 nesse balancedor e garanta que, **mesmo com uma das EC2 desligada, o usuário final conseguirá acessar a página web.**



## 6 - Segurança

Garanta que o acesso para suas EC2 ocorra somente através do balanceador, ou seja, chamadas HTTP diretamente realizadas da sua máquina para o EC2 deverão ser barradas. Elas **só aceitarão chamadas do balanceador** e esse, por sua vez, aceitará conexões externas normalmente.
