// Создаем сервис аккаунт для создания s3
resource "yandex_iam_service_account" "str-sa" {
  folder_id = var.yc_folder_id
  name      = "str-sa"
}

// Назначаем поликтиу storage.editor
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.yc_folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.str-sa.id}"
}

// Создаем Static Access Keys для этого сервис аккаунта
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.str-sa.id
  description        = "static access key for object storage"
}

// Создаем сервис аккаунт для создания группы ВМ
resource "yandex_iam_service_account" "vm-mgr" {
  name        = "vm-mgr"
  description = "service account to manage VMs"
}

// Назначаем поликтиу editor
resource "yandex_resourcemanager_folder_iam_member" "vm-mgr-editor" {
  folder_id = var.yc_folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.vm-mgr.id}"
}
