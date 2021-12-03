# Examples


## ecs-fargate

1. Context 구성
```
module "ctx" {
  source = "git::https://github.com/bsp-dx/edu-terraform-aws.git?ref=tfmodule-context-v1.0.0"

  context = {
    aws_profile = "terran"
    region      = "ap-northeast-2"
    project     = "mydemo"
    environment = "Production"
    owner       = "owner@academyiac.ml"
    team        = "DX"
    cost_center = "20211129"
    domain      = "academyiac.ml"
    pri_domain  = "mydemo.local"
  }
}

```

2. VPC 구성
```
module "vpc" {
  source = "git::https://github.com/bsp-dx/edu-terraform-aws.git?ref=tfmodule-aws-vpc-v1.0.0"

  context = module.ctx.context
  cidr    = "171.2.0.0/16"

  azs = [ data.aws_availability_zones.this.zone_ids[0], data.aws_availability_zones.this.zone_ids[1] ]

  public_subnet_names  = ["pub-a1", "pub-b1"]
  public_subnets       = ["171.2.11.0/24", "171.2.12.0/24"]
  public_subnet_suffix = "pub"

  enable_nat_gateway = true
  single_nat_gateway = true

  private_subnet_names = ["pri-a1", "pri-b1"]
  private_subnets      = ["171.2.31.0/24", "171.2.32.0/24"]
  
  create_private_domain_hostzone = false

  depends_on = [module.ctx]
}

data "aws_availability_zones" "this" {
  state = "available"
}
```

3. ECS Fargate 클러스터 구성
```
module "ecs" {
  source = "git::https://github.com/bsp-dx/edu-terraform-aws.git?ref=tfmodule-aws-ecs-v1.0.0"

  context = module.ctx.context
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
  container_insights = true

  default_capacity_provider_strategy = [
    {
      capacity_provider = "FARGATE"
      weight            = 1
    }
  ]
  
  depends_on = [module.vpc]
}

```

4. ECS Service (nginx_service) 서비스 생성
```
resource "aws_ecs_service" "nginx_service" {
  name            = "nginx-service"
  cluster         = module.ecs_fargate.ecs_cluster_id
  task_definition = data.aws_ecs_task_definition.nginx.id
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    container_name   = "nginx"
    container_port   = 80
    target_group_arn = data.aws_alb_target_group.waf_tg80.arn
  }

  network_configuration {
    assign_public_ip = false
    subnets          = toset(data.aws_subnets.web.ids)
    security_groups  = [data.aws_security_group.waf-alb.id]
  }

  tags = merge(module.ctx.tags, { Name = "nginx-service" })
  
  depends_on = [module.ecs]
}
```
