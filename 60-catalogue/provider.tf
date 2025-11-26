terraform{
    required_providers {
        aws={
             source =  "hashicorp/aws"
            version = "6.9.0"
        }
       
    }


    backend "s3"{
        bucket = "roboshop-dev-ramana"
        key = "roboshop-catalogue-state"
        region = "us-east-1"
        encrypt = true 
        use_lockfile = true

    }
}

provider "aws"{
    region = "us-east-1"
}