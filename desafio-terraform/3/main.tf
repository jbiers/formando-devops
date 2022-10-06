resource "local_file" "name" {
  content = templatefile("alo_mundo.txt.tpl", {
    "nome" = var.nome
    "data"  = "${formatdate("DD'/'MM'/'YYYY", timestamp())}"
    "div" = var.div
    "numberlist" = range(1, 101)
  })

  filename = "alo_mundo.txt"
}