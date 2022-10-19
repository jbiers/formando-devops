# Desafio Docker

1. Execute o comando `hostname` em um container usando a imagem `alpine`. Certifique-se que o container será removido após a execução.

2. Crie um container com a imagem `nginx` (versão 1.22), expondo a porta 80 do container para a porta 8080 do host.

3. Faça o mesmo que a questão anterior (2), mas utilizando a porta 90 no container. O arquivo de configuração do nginx deve existir no host e ser read-only no container.

4. Construa uma imagem para executar o programa abaixo:

```python
def main():
   print('Hello World in Python!')

if __name__ == '__main__':
  main()
```

5. Execute um container da imagem `nginx` com limite de memória 128MB e 1/2 CPU.

6. Qual o comando usado para limpar recursos como imagens, containers parados, cache de build e networks não utilizadas?

7. Como você faria para extrair os comandos Dockerfile de uma imagem?
