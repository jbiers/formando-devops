# Desafio Kubernetes

1 - com uma unica linha de comando capture somente linhas que contenham "erro" do log do pod `serverweb` no namespace `meusite` que tenha a label `app: ovo`.

    kubectl logs -l app=ovo -n meusite serverweb | grep erro

2 - crie o manifesto de um recurso que seja executado em todos os nós do cluster com a imagem `nginx:latest` com nome `meu-spread`, nao sobreponha ou remova qualquer taint de qualquer um dos nós.

3 - crie um deploy `meu-webserver` com a imagem `nginx:latest` e um initContainer com a imagem `alpine`. O initContainer deve criar um arquivo /app/index.html, tenha o conteudo "HelloGetup" e compartilhe com o container de nginx que só poderá ser inicializado se o arquivo foi criado.

4 - crie um deploy chamado `meuweb` com a imagem `nginx:1.16` que seja executado exclusivamente no node master.

   Para rodar pods no node master, é necessário remover o taint NoSchedule. Usei o seguinte comando:
    
    kubectl taint nodes kind-control-plane node-role.kubernetes.io/control-plane:NoSchedule-
   
   Além disso, adicionei ao node master o label de *role=control-plane*, para poder referenciá-lo posteriormente:
   
    kubectl label nodes kind-control-plane role=control-plane
   
   Então, criei um arquivo de nome *meu-web.yaml* com o seguinte conteúdo:
   
    apiVersion: apps/v1
    kind: Deployment
    metadata:
        labels:
            app: meu-web
         name: meu-web
    spec:
        replicas: 3
        selector:
            matchLabels:
                app: meu-web
        template:
          metadata:
            labels:
              app: meu-web
          spec:
            nodeSelector:
              role: control-plane
            containers:
            - image: nginx:1.16
              name: nginx
     
   E por fim, criei o deployment usando as especificações do arquivo
     
      kubectl create -f meu-web.yaml

5 - com uma unica linha de comando altere a imagem desse pod `meuweb` para `nginx:1.19` e salve o comando aqui no repositorio.

    kubectl set image deployments meu-web nginx=nginx:1.19

6 - quais linhas de comando para instalar o ingress-nginx controller usando helm, com os seguintes parametros;

    helm repository : https://kubernetes.github.io/ingress-nginx

    values do ingress-nginx : 
    controller:
      hostPort:
        enabled: true
      service:
        type: NodePort
      updateStrategy:
        type: Recreate

7 - quais as linhas de comando para: 

   criar um deploy chamado `pombo` com a imagem de `nginx:1.11.9-alpine` com 4 réplicas
   
   ```
   kubectl create deployment --image=nginx:1.11.9-alpine -r 3 pombo
   ```
   
   alterar a imagem para `nginx:1.16` e registre na annotation automaticamente
   
   ```
   kubectl set image deployments pombo nginx=1.16 --record
   ```
   
   alterar a imagem para 1.19 e registre novamente
   
   ```
   kubectl set image deployments pombo nginx=1.19 --record
   ```
   
   imprimir a historia de alterações desse deploy
   
   ```
   kubectl rollout history deployment pombo 
   ```
   
   voltar para versão 1.11.9-alpine baseado no historico que voce registrou.
   
   ```
   kubectl rollout undo deployment pombo --to-revision=1
   ```
   
   criar um ingress chamado `web` para esse deploy


8 - linhas de comando para; 

    criar um deploy chamado `guardaroupa` com a imagem `redis`;
    criar um serviço do tipo ClusterIP desse redis com as devidas portas.

9 - crie um recurso para aplicação stateful com os seguintes parametros:

    - nome : meusiteset
    - imagem nginx 
    - no namespace backend
    - com 3 réplicas
    - disco de 1Gi
    - montado em /data
    - sufixo dos pvc: data


10 - crie um recurso com 2 replicas, chamado `balaclava` com a imagem `redis`, usando as labels nos pods, replicaset e deployment, `backend=balaclava` e `minhachave=semvalor` no namespace `backend`.

11 - linha de comando para listar todos os serviços do cluster do tipo `LoadBalancer` mostrando tambem `selectors`.

12 - com uma linha de comando, crie uma secret chamada `meusegredo` no namespace `segredosdesucesso` com os dados, `segredo=azul` e com o conteudo do texto abaixo.

```bash
   # cat chave-secreta
     aW5ncmVzcy1uZ2lueCAgIGluZ3Jlc3MtbmdpbngtY29udHJvbGxlciAgICAgICAgICAgICAgICAg
     ICAgICAgICAgICAgTG9hZEJhbGFuY2VyICAgMTAuMjMzLjE3Ljg0ICAgIDE5Mi4xNjguMS4zNSAg
     IDgwOjMxOTE2L1RDUCw0NDM6MzE3OTQvVENQICAgICAyM2ggICBhcHAua3ViZXJuZXRlcy5pby9j
     b21wb25lbnQ9Y29udHJvbGxlcixhcHAua3ViZXJuZXRlcy5pby9pbnN0YW5jZT1pbmdyZXNzLW5n
     aW54LGFwcC5rdWJlcm5ldGVzLmlvL25hbWU9aW5ncmVzcy1uZ
```

13 - qual a linha de comando para criar um configmap chamado `configsite` no namespace `site`. Deve conter uma entrada `index.html` que contenha seu nome.

14 - crie um recurso chamado `meudeploy`, com a imagem `nginx:latest`, que utilize a secret criada no exercicio 11 como arquivos no diretorio `/app`.

15 - crie um recurso chamado `depconfigs`, com a imagem `nginx:latest`, que utilize o configMap criado no exercicio 12 e use seu index.html como pagina principal desse recurso.

16 - crie um novo recurso chamado `meudeploy-2` com a imagem `nginx:1.16` , com a label `chaves=secretas` e que use todo conteudo da secret como variavel de ambiente criada no exercicio 11.

17 - linhas de comando que;

  crie um namespace`cabeludo`
  
  ```
    kubectl create namespace cabeludo
  ```
    
   um deploy chamado `cabelo` usando a imagem `nginx:latest`
   
   ```
    kubectl create deployment cabelo --image nginx:latest
   ```
    
   uma secret chamada `acesso` com as entradas `username: pavao` e `password: asabranca
   
   ```
    kubectl create secret generic acesso --from-literal=username=pavao --from-literal=password=asabranca
    ```

18 - crie um deploy `redis` usando a imagem com o mesmo nome, no namespace `cachehits` e que tenha o ponto de montagem `/data/redis` de um volume chamado `app-cache` que NÂO deverá ser persistente.

19 - com uma linha de comando escale um deploy chamado `basico` no namespace `azul` para 10 replicas.

20 - com uma linha de comando, crie um autoscale de cpu com 90% de no minimo 2 e maximo de 5 pods para o deploy `site` no namespace `frontend`.

21 - com uma linha de comando, descubra o conteudo da secret `piadas` no namespace `meussegredos` com a entrada `segredos`.

22 - marque o node o nó `k8s-worker1` do cluster para que nao aceite nenhum novo pod.
    
    kubectl taint node k8s-worker1 true:NoSchedule

23 - esvazie totalmente e de uma unica vez esse mesmo nó com uma linha de comando.

    kubectl drain k8s-worker1

24 - qual a maneira de garantir a criaçao de um pod ( sem usar o kubectl ou api do k8s ) em um nó especifico.

25 - criar uma serviceaccount `userx` no namespace `developer`. essa serviceaccount só pode ter permissao total sobre pods (inclusive logs) e deployments no namespace `developer`. descreva o processo para validar o acesso ao namespace do jeito que achar melhor.

26 - criar a key e certificado cliente para uma usuaria chamada `jane` e que tenha permissao somente de listar pods no namespace `frontend`. liste os comandos utilizados.

27 - qual o `kubectl get` que traz o status do scheduler, controller-manager e etcd ao mesmo tempo

    kubectl get componentstatuses
