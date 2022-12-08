terraform {
 backend "gcs" {
   bucket  = "96d1936baebd7921-bucket-tfstate" #here you should put your bucket name that was generated from your backend storage folder in your output list.
   prefix  = "terraform/state"
 }
}