# tfmodule-context

tfmodule-context 테라폼 모듈은 클라우드 서비스 및 리소스를 정의 하는데 표준화된 네이밍 정책과 태깅 규칙을 지원 하고, 일관성있는 데이터소스 참조 모델을 제공 합니다.

## Usage

```
module "ctx" {
  source = "git::https://github.com/bsp-dx/edu-terraform-aws.git?ref=tfmodule-context-v1.0.0"

  context = {
    aws_profile = "terran"
    region      = "ap-northeast-2"
    project     = "applegoods"
    environment = "Production"
    owner       = "owner@academyiac.ml"
    team_name   = "Devops Transformation"
    team        = "DX"
    cost_center = "20211129"
    domain      = "academyiac.ml"
    pri_domain  = "applegoods.local"
  }
}
```


## Output

Context 모듈로부터 참조 할 수 있는 Output 값 입니다.

```
output "context" {
  value = module.ctx.context
}

output "tags" {
  value = module.ctx.tags
}

output "region" {
  value = module.ctx.region
}

output "region_alias" {
  value = module.ctx.region_alias
}

output "project" {
  value = module.ctx.project
}

output "environment" {
  value = module.ctx.environment
}

output "env_alias" {
  value = module.ctx.env_alias
}

output "owner" {
  value = module.ctx.owner
}

output "team" {
  value = module.ctx.team
}

output "cost_center" {
  value = module.ctx.cost_center
}

output "domain" {
  value = module.ctx.domain
}

output "pri_domain" {
  value = module.ctx.pri_domain
}

output "name_prefix" {
  value = module.ctx.name_prefix
}

output "tags_string" {
  value = module.ctx.tags_string
}

output "context_string" {
  value = module.ctx.context_string
}
```
