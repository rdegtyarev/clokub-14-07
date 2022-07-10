// VM Group
resource "yandex_compute_instance_group" "netology-instance-group" {
  name                = "test-ig"
  service_account_id  = yandex_iam_service_account.vm-mgr.id
  deletion_protection = false

  instance_template {
    platform_id = "standard-v1"
    resources {
      memory = 2
      cores  = 2
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
        size     = 4
      }
    }
    network_interface {
      network_id = yandex_vpc_network.netology.id
      subnet_ids = ["${yandex_vpc_subnet.private.id}"]
    }

    metadata = {
      user-data = "${file("./lamp-init.yaml")}"
    }

    network_settings {
      type = "STANDARD"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-b"]
  }

  deploy_policy {
    max_unavailable = 2
    max_creating    = 2
    max_expansion   = 2
    max_deleting    = 2
  }

  load_balancer {
    target_group_name = "netology-target-lb"
  }

  depends_on = [
    yandex_resourcemanager_folder_iam_member.vm-mgr-editor
  ]
}


# public-instance (виртуальная машина на ubuntu)
resource "yandex_compute_instance" "public-instance" {
  name        = "public-instance"
  zone        = "ru-central1-a"
  platform_id = "standard-v3"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8f30hur3255mjfi3hq"
      size     = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  metadata = {
    user-data = "${file("~/meta.txt")}"
  }

}