## Deploying a nomad cluster in AWS

This is a project to blable and talk about what's being connected

## Tools required

- Terraform
- Nomad cli
- httpie
- An AWS account 

### Steps to create the cluster in AWS

1. `cd ./cluster-generation/development/`
1. `terraform plan` 
1. Copy output of `server_lb_ip`
1. Run `export NOMAD_ADDR=http://nomad-server-lb-773388063.us-east-1.elb.amazonaws.com:4646`.
1. Run `nomad server members`.
1. You should see something like the below output
```Name                           Address          Port  Status  Leader  Protocol  Build   Datacenter  Region
   i-027ddfb21fb56dd6d.us-east-1  192.168.101.7    4648  alive   true    2         0.12.7  us-east-1a  us-east-1
   i-0ffc3d1f70af328fa.us-east-1  192.168.102.60   4648  alive   false   2         0.12.7  us-east-1b  us-east-1
   i-0973c66fd29763def.us-east-1  192.168.103.183  4648  alive   false   2         0.12.7  us-east-1c  us-east-1```
```
1. Run `cd ../../services`
1. Run `nomad plan load_balancer.nomad`.
1. Run `nomad run load_balancer.nomad`.
1. Last line's output should look like this `==> Evaluation "b450ced8" finished with status "complete"`
1. Run `./gradlew jib -Pversion=1.0`
1. Run `nomad run movies.nomad`
1. Run `http http://nomad-server-lb-773388063.us-east-1.elb.amazonaws.com/movies/`
1. Open your browser 

1. Run `cd ../../cluster-generation/development`
1. `terraform destroy`
