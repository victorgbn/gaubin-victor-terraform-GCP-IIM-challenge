# cloud_storage.tf

# Define bucket
resource "google_storage_bucket" "my_bucket" {
  name = "iim-victorgaubin-tpnote-bucket"
  location = "us-central1"
}

# Access
resource "google_storage_bucket_iam_policy" "my_bucket_policy" {
  bucket = google_storage_bucket.my_bucket.name

  # Permissions
  binding {
    role    = "roles/storage.objectViewer"
    members = ["serviceAccount:victor@iim-victorgaubin-tpnote.iam.gserviceaccount.com"]
  }
}
