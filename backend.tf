terraform {
 backend "gcs" {
   bucket  = "c786497ec5e162b4-bucket-tfstate" #here you should put your bucket name that was generated from your backend storage folder in your output list.
   prefix  = "terraform/state"
 }
}