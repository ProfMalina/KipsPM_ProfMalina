resource "yandex_vpc_network" "gitlab_network" {
  name = "gitlab-network"
  labels = {
    tags = "gitlab-network"
  }
}

resource "yandex_vpc_subnet" "gitlab_subnet" {
  name = "gitlab"
  labels = {
    tags = "gitlab"
  }
  network_id     = yandex_vpc_network.gitlab_network.id
  v4_cidr_blocks = ["192.168.0.0/24"]
}
