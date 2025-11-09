variable "project_name" {
    default = "roboshop"
  
}
variable "environment" {
    default = "dev"
  
}

variable "sg_names" {
    default = [

        #database
        "mongodb","redis","mysql","rabbitmq",
        #backend
        "catalogue","user","cart","shipping","payment",
        #forntend
        "fronend",
        #bastion
        "bastion",
        #frontend loadbalancers
        "frontend-lb",
        # Backend ALB
        "backend-alb"

    ]

    
  
}

variable "zone-id" {
  default = "Z0043313JVXOCUVVVC7F"
}

variable "domain_name" {
    default = "daws86.fun"
  
}