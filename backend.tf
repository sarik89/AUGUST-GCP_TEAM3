terraform {
 backend "gcs" {
   bucket  = "YOUR-BUCKET-NAME" #here you should put your bucket name that was generated from your backend storage folder in your output list.
   prefix  = "terraform/state"
 }
}