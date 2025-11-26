terraform{
    required_providers{
        aws={
            source = "hashicorp/aws"
            version = "6.9.0"
        }
    }
    backend "s3"{
        bucket = "ramana-remote-state"
        key = "state-for-vpn"
        region = "us-east-1"
        encrypt = true
        use_lockfile = true
    }
}

provider "aws"{
    region = "us-east-1"
}