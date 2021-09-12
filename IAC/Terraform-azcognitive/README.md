Provisioning Azure Cognitive services with Hashicorp Terraform
Contains the Terraform configurations for provisioning Azure cognitive services 
      - Azure Anomaly Detector 
      - Azure Computer Vision
      - Azure Content Moderator
      - Azure Custom Vision
      - Azure Face API
      - Azure Form recognizer
      - Azure Immersive reader
      - Azure Language Understanding (LUIS)
      - Azure Personaliser
      - Azure QnA Maker
      - Azure Speech
      - Azure Text Analytics
      - Azure Text Translator


The Terraform commands to be executed for provisioning the services -
      Initialisation of terraform backend & plugins with the command
      Terraform init
 
Planning of the terraform workflow & resources to be provisioned - 
      Terraform plan -out="nameofyourtfplan.tfplan" 
 
Execution of resources provisioning -
      Terraform Apply "yourtfplan.tfplan"
 
Destroy of the resources once required - 
      Terraform destroy
        
