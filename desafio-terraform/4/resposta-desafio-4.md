# Desafio Terraform

## 4. Assumindo recursos

O comando `terraform import` permite buscar informações sobre um recurso já existente no Cloud Provider. Por exemplo, utilizando o comando abaixo:

```
terraform import aws_instance.name i-abcd1234
```

Vale notar que `terraform import` não gera código, apenas atualiza o state, para que este fique
ciente da existência do recurso.

Um resource com esse nome, o mesmo AMI e instance_type deve existir previamente no root module, para evitar que os comandos "plan" e "apply" não removam a instância legada.

As informações da AMI e instance_type a serem inseridas, podem ser buscadas com o comando
`terraform state pull`, que busca o state remoto.
