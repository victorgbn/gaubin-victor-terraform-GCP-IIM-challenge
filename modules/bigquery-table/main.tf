# bigquery-table.tf

# Define the BigQuery table
resource "google_bigquery_table" "my_table" {
  dataset_id = var.dataset_id
  table_id   = var.table_name

  schema = <<EOF
[
  {
    "name": "Gender",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "firstname",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "lastname",
    "type": "STRING",
    "mode": "NULLABLE"
  }
]
EOF

  depends_on = [google_bigquery_dataset.my_dataset]
}

# Define the BigQuery dataset
resource "google_bigquery_dataset" "my_dataset" {
  dataset_id               = var.dataset_id
  friendly_name            = "My dataset"
  default_table_expiration_ms = "3600000"
}
