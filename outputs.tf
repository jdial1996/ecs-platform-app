output "private_subnets" {
    value = module.ecs-cluster.private_subnets
}

output "public_subnets" {
    value = module.ecs-cluster.public_subnets
}

output "ecs_cluster_arn" {
    value = module.ecs-cluster.ecs_cluster_arn
}

output "ecs_cluster_vpc_id" {
    value = module.ecs-cluster.vpc_id
}