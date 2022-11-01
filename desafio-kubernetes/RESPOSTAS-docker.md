# Desafio Docker

1. Execute o comando `hostname` em um container usando a imagem `alpine`. Certifique-se que o container será removido após a execução.

   ```
   docker run --rm alpine hostname
   ```

2. Crie um container com a imagem `nginx` (versão 1.22), expondo a porta 80 do container para a porta 8080 do host.

   ```
   docker container create -p 8080:80 nginx:1.22.0
   ```

3. Faça o mesmo que a questão anterior (2), mas utilizando a porta 90 no container. O arquivo de configuração do nginx deve existir no host e ser read-only no container.
   
   Tendo o arquivo *nginx.conf* definindo a porta de funcionamento como 90, crie um Dockerfile com as seguintes instruções:
  
   ```
   FROM nginx
   RUN rm /etc/nginx/conf.d/default.conf
   COPY nginx.conf /etc/nginx/
   EXPOSE 90
   ```
   
   Crie a imagem a partir desse Dockerfile
  
   ```
   docker image build .
   ```
  
   Crie o container a partir da imagem
  
   ```
   docker container create -p 8080:90 my-nginx
   ```

4. Construa uma imagem para executar o programa abaixo:

   ```python
   def main():
      print('Hello World in Python!')

   if __name__ == '__main__':
   main()
   ```
   
   Tendo o código acima salvo em um arquivo de nome *main.py*, vamos criar o Dockerfile no mesmo diretório. O conteúdo do Dockerfile será:
   
   ```
   FROM python:latest

   ADD main.py .

   CMD ["python", "./main.py"]
   ```
   
   Em seguida, vamos criar a imagem a partir desse Dockerfile, utilizando o seguinte comando:
   
   ```
   docker image build -t hello-python .
   ```
   
   Em seguida basta rodar um container a partir da imagem gerada.
   
   ```
   docker container run hello-python
   ```

5. Execute um container da imagem `nginx` com limite de memória 128MB e 1/2 CPU.
   
   ```
   docker container run -m 128m --cpus=0.5 nginx
   ```

6. Qual o comando usado para limpar recursos como imagens, containers parados, cache de build e networks não utilizadas?

   ```
   docker system prune
   ```

7. Como você faria para extrair os comandos Dockerfile de uma imagem?
   
   ```
   docker history <IMAGE_NAME>
   ```
