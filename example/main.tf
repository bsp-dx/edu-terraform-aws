module "ctx" {
  source  = "../tfmodule-context"

  context = {
    aws_profile  = "terran"
    region       = "ap-northeast-2"
    region_alias = "an2"
    project      = "melonops"
    environment  = "Production"
    owner        = "symple@bespinglobal.com"
    team         = "DX"
    cost_center  = "20211210"
    domain       = "simitsme.ml"
    pri_domain   = "melonops.in"
  }

}