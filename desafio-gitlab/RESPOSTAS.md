# Desafio GitLab

## Deploy de um site estático no GitLab Pages.

### Primeira Parte (passos 01 ao 06)

Criei uma conta no Gitlab. Adicionei minha chave pública para conexões SSH. Nessa conta, criei o repositório público "desafio-gitlab" e clonei-o em meu computador com o comando:

```
git clone git@gitlab.com:juliabiersuriano/desafio-gitlab.git
```

Movi a pasta /public, disponibilizada nesse repositório, para dentro do recém criado "desafio-gitlab". Fiz então o primeiro commit, e enviei-o para o repositório remoto.

```
git add .
git commit -m "added website files"
git push
```

Mudei o texto da página inicial **index.html** para "Desafio GitLab - Dev", como mostra a imagem abaixo:

![Screenshot from 2022-10-12 15-10-33](https://user-images.githubusercontent.com/85142222/195427901-bfdfbb08-e328-493a-b8e2-9d630de4455b.png)

Em seguida, fiz o commit dessa mudança e enviei também para o repositório remoto. Até o momento, o histórico da branch *main*, é o seguinte:

![Screenshot from 2022-10-12 15-12-04](https://user-images.githubusercontent.com/85142222/195428159-1371c768-7abf-4c3c-b504-56cce418a4d3.png)

Com o comando `git checkout -b "feature"`, criei uma nova branch de nome **feature**, onde alterei o texto do **index.html**, como mostra a imagem:

![Screenshot from 2022-10-12 15-14-00](https://user-images.githubusercontent.com/85142222/195428662-fecb8309-f728-4f7b-9721-65390bfa5f02.png)

Ao fazer o commit dessa mudança, o histórico da branch **feature** ficou assim:

![Screenshot from 2022-10-12 15-15-35](https://user-images.githubusercontent.com/85142222/195428798-f1a21568-1e06-4047-9724-7057c53f2149.png)

Ao final da primeira parte, o estado do repositório é este:

![Screenshot from 2022-10-12 15-04-58](https://user-images.githubusercontent.com/85142222/195428913-5b6dd118-c381-49b2-b3f9-2246aeef9f45.png)

### Segunda Parte (passos 07 ao 11)

Para criar o pipeline no GitLab CI, criei o arquivo **.gitlab-ci.yml** na branch main, com os seguintes conteúdos:

![Screenshot from 2022-10-12 15-49-10](https://user-images.githubusercontent.com/85142222/195434668-f5fe15bc-5b72-4741-b9f3-3fa9bb572fde.png)

Fazendo o commit do arquivo recém criado e dando o push para o repositório remoto, o job é executado automaticamente. Em primeiro momento, ele falha, pois não havia feito a validação do cartão de crédito no GitLab. Após fazer isso, o job finaliza com sucesso e a página está disponível em https://juliabiersuriano.gitlab.io/desafio-gitlab/:

![Screenshot from 2022-10-12 15-56-24](https://user-images.githubusercontent.com/85142222/195436027-86ef2a7d-1054-4b29-a99d-acd8b5e69be2.png)

![Screenshot from 2022-10-12 15-58-34](https://user-images.githubusercontent.com/85142222/195436155-fd300f84-b37c-4e00-a980-343fe5eadd99.png)

Logo após fazer a merge da branch **feature** com a **main**, o job é executado novamente, fazendo o deploy das alterações.

![Screenshot from 2022-10-12 16-00-20](https://user-images.githubusercontent.com/85142222/195436787-3662ba32-1ad0-4869-9f79-21a1a4bff344.png)

![Screenshot from 2022-10-12 16-00-48](https://user-images.githubusercontent.com/85142222/195436895-a0ec79b3-c696-4daa-b34e-4cee1c32e4b8.png)

