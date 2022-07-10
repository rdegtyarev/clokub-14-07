terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.76.0"
    }
  }
}

variable "yc_folder_id" {
  type        = string
  description = "Yandex Cloud folder id"
}
