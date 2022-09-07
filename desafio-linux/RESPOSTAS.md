# Desafio Linux

## 1. Kernel e Boot loader

A chave aqui é o acesso físico ao host. Assim podemos acessar o recovery mode do Linux.

Para isso, é necessário reiniciar o sistema e pressionar TAB para acessar o menu GRUB, selecionando então o recovery mode. Foi necessário pressionar a tecla E no meno GRUB para editar o parâmetro `rhgb quiet` para `d.break enforcing=0` e então iniciar o boot.

Então, rodei os seguintes comandos para que o sysroot filesystem fosse remontado com o modo read/write e então acessar o sysroot.

```
mount -o remount,rw /sysroot
chroot /sysroot
```

Com as permissões atuais, seria possível redefinir a senha do usuário root com o comando `passwd`, mas o desafio pedia que o usuário vagrant tivesse acesso aos comandos de root usando `sudo`.Portanto adicionei o user vagrant ao grupo `wheel`, que permite exatamente isso.

```
usermod -aG wheel vagrant
```

Em seguida só foi necessário rebootar a máquina e acessar o modo normal do sistema.

## 2. Usuários

### 2.1 Criação de usuários

Primeiro criei um grupo de nome getup com o GID=2222
```
groupadd -g 2222 getup
```

Depois criei o usuário getup com UID=1111 e tendo o grupo recém criado como seu grupo primário.
```
useradd -u 1111 -g 2222 getup
```

Adicionei o usuério getup também ao grupo bin
```
usermod -aG bin getup
```

Para permitir o uso de `sudo` sem senha, editei o arquivo /etc/sudoers com o comando `visudo`e adicionei a seguinte linha: `getup ALL=(ALL) NOPASSWD: ALL`.

## 3. SSH

### 3.1 Autenticação confiável

Retirei o acesso ao SSH por senha e garanti o acesso por par de chaves ao editar o arquivo de configurações do SSH por meio do comando `sudo vi /etc/ssh/sshd_config`. No arquivo, editei as duas variáveis abaixo:

```
PasswordAuthentication no
PubKeyAuthentication: yes
```

Em seguida reiniciei o serviço com o comando `sudo systemctl restart sshd`.

### 3.2 Criação de chaves

Em minha máquina local executei o comando `ssh-keygen -t ecdsa` para gerar uma chave do tipo ECDSA. Em seguida enviei a chave pública para a máquina virtual (especificamente o usuário vagrant), pelo comando `ssh-copy-id -i id_ecdsa.pub vagrant@192.168.100.50`.

Então foi posssível acessar a VM com `ssh vagrant@192.168.100.50`.

### 3.3 Análise de logs e configurações ssh

A chave do arquivo id_rsa-desafio-linux-devel.gz.b64 estava criptografada em base64, e foi preciso descriptografá-la com o comando `base64 -d id_rsa-desafio-linux-devel.gz.b64 > id_rsa-desafio-linux-devel.gz`. O arquivo agora estava apenas compactado. Descompactei com o comando `gunzip id_rsa-desafio-linux-devel.gz`.

Em seguida foi preciso alterar as permissões da chave para de forma a deixá-las mais restritivas `chmod 400 id_rsa-desafio-linux-devel`. Ao tentar conectar na VM com o comando `ssh -i id_rsa-desafio-linux-devel devel@192.168.100.50`, não funcionou. Fui então verificar os logs do serviço sshd na VM `tail -f /var/log/secure`, e a mensagem de erro dizia que a chave estava em um formato inválido.

Conforme a dica falava sobre separadores de linha de outro sistema, utilizei o comando `cat -e id_rsa-desafio-linux-devel` para exibir o conteúdo do arquivo incluindo os separadores de linha. Assim descobri que eram do tipo utilizado em sistemas Windows e fiz a conversão com o comando `dos2unix id_rsa-desafio-linux-devel`. Então, a conexão SSH funcionou.

## 4. Systemd

Ao rodar o comando `sudo systemctl start nginx`, recebi uma mensagem de erro. Ao investigar mais com `systemctl status nginx.service`, recebi uma mensagem mais detalhada que dizia `nginx: [emerg] invalid number of arguments in "root" directive in /etc/nginx/nginx.conf:45`. Percebi que existia um problema na linha 45 do arquivo nginx.conf. Ao abrir o arquivo com o vim, ficou claro que se tratava da falta de um ; para marcar o fim da linha.

Tentei iniciar o nginx.service novamente, e encotrei dessa vez o erro `nginx: invalid option: "B”`. Abri então o arquivo /lib/systemd/system/nginx.service e removi a palavra extra que havia sido colocada.

Dessa vez o nginx foi inicializado com sucesso, mas o curl retornava o erro `Failed to connect to 127.0.0.1 port 80: Connection refused`, indicando que o nginx estava rodando em uma porta diferente da padrão para o protocolo HTTP. Acessando o nginx.conf, confirmei a suspeita, pois as seguintes linhas estavam presentes:

```
listen       90 default_server;
listen       [::]:90 default_server;
```

Ao alterar para a porta padrão (80), e reiniciar o serviço, o comando curl exibiu com sucesso a seguinte mensagem: `Duas palavrinhas pra você: para, béns!`.

## 5. SSL

### 5.1 Criação de certificados

Adicionei o  hostname desafio.local e www.desafio.local no arquivo /etc/hosts.

Criei uma chave RSA chamada CA.key para a Certified Authority
```
openssl genrsa -out CA.key -des3 2048
```

Gerei uma CA local com o comando
```
openssl req -x509 -sha256 -new -nodes -days 3650 -key CA.key -out CA.pem
```

Criei um arquivo localhost.ext contendo o descrito abaixo:
```
authorityKeyIdentifier = keyid,issuer
basicConstraints = CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = localhost
DNS.2 = desafio.local
DNS.3 = www.desafio.local
IP.1 = 127.0.0.1
```

Gerei outra chave para ser usada com o certificado
```
openssl genrsa -out localhost.key -des3 2048
```

Gerei o csr com
```
openssl req -new -key localhost.key -out localhost.csr
```

Por fim gerei o certificado usando todas as informações criadas anteriormente, e também descriptografei a chave
```
openssl x509 -req -in localhost.csr -CA CA.pem -CAkey CA.key -CAcreateserial -days 3650 -sha256 -extfile localhost.ext -out localhost.crt
openssl rsa -in localhost.key -out localhost.decrypted.key
```

Temos, por fim, nossa chave de nome localhost.decrypted.key e o certificado localhost.crt.

### 5.2 Uso de certificados

Editei o conteúdo o /etc/nginx/nginx.conf para conter as configurações abaixo
```
server {
        listen       443 ssl default_server;
        listen       80;
        server_name  desafio.local;
        root         /usr/share/nginx/html;

        ssl_certificate "/etc/ssl/desafio.local/localhost.crt";
        ssl_certificate_key "/etc/ssl/desafio.local/localhost.decrypted.key";


        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        location / {
        }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }
```

Agora, após reiniciar o serviço do nginx, o comando curl pode ser executado com a flag -k para garantir que o self-signed certificate seja aceito.
```
curl -k https://www.desafio.local
```

## 6. Rede

### 6.1 Firewall

Comando ping funcionou perfeitamente.

### 6.2 HTTP

```
HTTP/2 200 
date: Wed, 07 Sep 2022 20:33:51 GMT
content-type: application/json
content-length: 89
server: gunicorn/19.9.0
hello: world
access-control-allow-origin: *
access-control-allow-credentials: true

{
  "Content-Length": "89", 
  "Content-Type": "application/json", 
  "hello": "world"
}
```

## Logs

Criei o arquivo `/etc/logrotate.d/nginx` e adicionei a ele as seguintes configurações, de forma a rotacionar os logs semanalmente com compressão de arquivos e guardá-los por 52 semanas:

```
/var/log/nginx/*.log {
        weekly
        missingok
        rotate 52
        compress
        delaycompress
        create 0640 root adm
        sharedscripts
}
```

O comando `sudo logrotate -f /etc/logrotate.d/nginx` permitiu forçar uma rotação para garantir que estava tudo funcionando como desejado.

## 7. Filesystem

### 7.1 Expandir partição LVM

Aumentei o tamanho da partição /dev/sdb1 com o fdisk. Em seguida atualizei o tamanho do LV e com `resize2fs` expandi o filesystem.

### 7.2 Criar partição LVM

Com fdisk criei a partição /dev/sdb2 com tipo LVM. Criei um VG correspondente e formatei com mkfs.ext4.

### 7.3 Criar partição XFS

Executei dois comandos:
```
yum install xfsprogs

mkfs.xfs /dev/sdc
```
