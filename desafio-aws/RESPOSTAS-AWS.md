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

Para criar uma cópia da instância, é necessário primeiro criar uma AMI (Amazon Machine Image) dessa máquina. Então, basta fazer o launch de uma instância a partir da mesma AMI, no mesmo VPC e utilizando o mesmo Security Group. 

![image](https://user-images.githubusercontent.com/85142222/192918072-d9d60ae3-b57e-428b-8d9e-9491468ac080.png)

Ela estará em outra Availability Zone dentro da mesma Region, e alterei o arquivo **/var/www/html/index.html** de cada uma para não só a região, mas também a AZ de cada uma.

![image](https://user-images.githubusercontent.com/85142222/192918118-7daf673d-e145-4184-996a-e6962b8689b1.png)

Em seguida, criei um Load Balancer selecionando ambas as Availability Zones usadas pelo VPC (us-east-1a e us-east-1b). O seu security group deve permitir entradas do tipo HTTP na porta 80 vindas de qualquer lugar, e saídas para o grupo de segurança das instâncias.

![image](https://user-images.githubusercontent.com/85142222/192918376-adb7b68d-f7ee-4c22-a812-49ff6048b7fc.png)
![image](https://user-images.githubusercontent.com/85142222/192918390-ebafc627-1ef6-412a-b026-cfdfe3722c40.png)

O target group do Load Balancer deve apontar para as duas instâncias criadas, também na porta 80.

É necessário permitir acesso do grupo de segurança do load balancer às EC2, alterando o Security Group delas da seguinte maneira:

![image](https://user-images.githubusercontent.com/85142222/192918506-9222944b-6d6f-47f1-a8db-77053e7fb347.png)

Enfim, temos os dois Targets do Load Balancer saudáveis e funcionando corretamente.

![Screenshot from 2022-09-28 21-45-17](https://user-images.githubusercontent.com/85142222/192919609-c22e313b-c06a-47fb-bdc5-28f44e43c9b9.png)


## 6 - Segurança

Foi necessário retirar a inbound rule das instâncias que permite entradas de qualquer lugar da internet. Manter apenas entradas HTTP vindas do Security Group do Load Balancer.

![image](https://user-images.githubusercontent.com/85142222/192917594-5d1bbf43-26ec-4679-8189-0e0b7e3db13b.png)
