# Сеть
resource "yandex_vpc_network" "netology" {
  name = "netology"
}

# Подсеть public
resource "yandex_vpc_subnet" "public" {
  name           = "public"
  zone           = "ru-central1-a"                # выбираем зону а
  network_id     = yandex_vpc_network.netology.id # указываем id созданного vpc
  v4_cidr_blocks = ["192.168.10.0/24"]            # указываем диапазон адресов
}

# Подсеть private
resource "yandex_vpc_subnet" "private" {
  name           = "private"
  zone           = "ru-central1-b"                         # выбираем зону b
  network_id     = yandex_vpc_network.netology.id          # указываем id созданного vpc
  v4_cidr_blocks = ["192.168.20.0/24"]                     # указываем диапазон адресов
  route_table_id = yandex_vpc_route_table.private-route.id # указываем id на таблицу маршрутизации в NAT-instance
}

# Таблица маршрутизации из private подсети в nat-instance public подсети
resource "yandex_vpc_route_table" "private-route" {
  network_id = yandex_vpc_network.netology.id
  name       = "nat-instance-route"

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.nat-instance.network_interface.0.ip_address # ссылка на локальный ip адрес созданного NAT-instance
  }
}

# NAT-instance
resource "yandex_compute_instance" "nat-instance" {
  name = "nat-instance"
  zone = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

}