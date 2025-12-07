terraform{
    required_providers {
      aws={
            source = "hashicorp/aws"
            version = "6.9.0"
      }
    }   

    backend "s3"{
        bucket = "roboshop-dev-ramana"
        key = "state-forntend-alb"
        encrypt = true
        use_lockfile = true
        region = "us-east-1"

    }
}

provider "aws"{
    region = "us-east-1"
}