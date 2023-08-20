
Create a file terraform.tfvars which contains the GCP deployment credentilas

```
credentials_file = "bobbins-mcbobbinsface-123456-a12345689ab.json"
gcpproject       = "bobbins-mcbobbinsface-123456"
region           = "europe-west2"

$ gcloud container clusters get-credentials bobbins-gke --region europe-west2
$ terraform init; terraform plan; terraform apply 
```
