# cloud-functions.tf

# Define the cloud function
resource "google_cloudfunctions_function" "my_function" {
  name        = module.cloud-functions.function_name
  description = "My cloud function"

  # Source code
  source_archive_bucket = google_storage_bucket.my_bucket.name
  source_archive_object = "web/getRandomUser.zip"

  # Runtime and Trigger
  runtime    = module.cloud-functions.runtime
  entry_point = "getRandomUser"
  trigger_http {
    allow_unauthenticated = true
  }

  # Environment variables
#   environment_variables = {
#     API_KEY = ""
#   }

  # IAM policy
  service_account_email = google_service_account.my_service_account.email
  depends_on = [google_service_account.my_service_account]
}
