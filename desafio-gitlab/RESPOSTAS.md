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

7. Crie um pipeline no GitLab CI para fazer o deploy do site estático no GitLab Pages.

8. Faça o merge da branch "feature" para a branch "main".

9. Encontre o endereço do seu site no GitLab.

10. Acesse a página inicial do seu projeto no Gitlab e verifique se o texto foi alterado.

11. Adicione no arquivo [RESPOSTAS.md](RESPOSTAS.md) o link para o seu repositório e o log do git com o histórico de commits. Envie também um screenshot da Gitlab Page criada.
