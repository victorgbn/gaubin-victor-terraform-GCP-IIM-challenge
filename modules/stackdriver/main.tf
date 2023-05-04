resource "google_logging_metric" "my_metric" {
  name        = "my-metric"
  description = "My metric description"
  filter      = "resource.type = gce_instance AND severity>=ERROR"

  value_extractor {
    extractors {
      key          = "module"
      value_regex  = "^(.*?)$"
      value_format = "$1"
    }
    extractors {
      key          = "message"
      value_regex  = "^(.*)$"
      value_format = "$1"
    }
  }
}

resource "google_logging_sink" "my_sink" {
  name = "my-sink"
  destination = "bigquery.googleapis.com/projects/${var.project_id}/datasets/${var.dataset_id}"

  filter = "resource.type=gce_instance"
  include_children = true
  writer_identity = "serviceAccount:${google_service_account.my_service_account.email}"

  # Metadata
  bigquery_options {
    use_partitioned_tables = true
    # Time partitioning configuration
    partition_expiration_ms = "15552000000" # 180 days
    partition_key {
      type = "TIME"
      # Use log timestamp
      field = "timestamp"
    }
    # Define table schema
    schema = <<-JSON
      [
        {"name": "module", "type": "STRING", "mode": "REQUIRED"},
        {"name": "message", "type": "STRING", "mode": "REQUIRED"}
      ]
    JSON
  }
}

# Grant IAM permission to sink logs to BigQuery
resource "google_project_iam_member" "my_sink_bigquery_iam" {
  project = var.project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_logging_sink.my_sink.writer_identity}"
}
