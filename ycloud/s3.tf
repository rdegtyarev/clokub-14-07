// Создаем бакет S3
resource "yandex_storage_bucket" "netology-bucket-test" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "rdegtyarev-netology-bucket"

  anonymous_access_flags {
    read = true
    list = false
  }

}

// Размещаем картинку в созданном бакете
resource "yandex_storage_object" "netology-picture" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "rdegtyarev-netology-bucket"
  key        = "smile.png"
  source     = "./smile.png"

  depends_on = [
    yandex_storage_bucket.netology-bucket-test
  ]
}