provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

module "vpc" {
  source = "./modules/vpc"
}

module "gitlab" {
  source    = "./modules/gitlab"
  subnet_id = module.vpc.gitlab_subnet
  image_id  = var.image_id
  public_key_path = var.public_key_path
}
