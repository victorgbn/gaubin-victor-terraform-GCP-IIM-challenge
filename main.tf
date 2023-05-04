provider "google" {
  credentials = file("keys/iim-victorgaubin-tpnote-707d8d79e812.json")
  version = "3.5.0"
  project     = "iim-victorgaubin-tpnote"
  region      = "us-central1"
  zone        = "us-central1-c"
}

module "cloud-storage" {
  source = "./modules/cloud-storage"

  bucket_name = "iim-victorgaubin-tpnote-bucket"
  bucket_location = "us-central1"
}

module "cloud-functions" {
  source = "./modules/cloud-functions"
  
  function_name = "iim-victorgaubin-tpnote-function-getRandomUser"
  runtime       = "nodejs12"
  trigger       = "http"
  code_path     = "web/getRandomUser.js"
}

variable "dataset_id" {
  type = string
  default = "iim-victorgaubin-tpnote-dataset-id"
}

module "bigquery-table" {
  source = "./modules/bigquery-table"

  table_name = "iim-victorgaubin-tpnote-database-user"
  schema     = [  {    "name": "Gender",    "type": "STRING"  },  {    "name": "firstname",    "type": "STRING"  },  {    "name": "lastname",    "type": "STRING"  }]
  location   = "us"
}

module "stackdriver" {
  source = "./modules/stackdriver"
  
  dashboard_name = "dashboard"
  services       = ["cloud-storage", "cloud-functions", "bigquery-table"]
}