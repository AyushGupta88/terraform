# Simply specify the family to find the latest ACTIVE revision in that family.
data "aws_ecs_task_definition" "application" {
  task_definition = aws_ecs_task_definition.application.family
}

resource "aws_ecs_cluster" "foo" {
  name = "foo"
}

resource "aws_ecs_task_definition" "frontend" {
  family = "frontend"

  container_definitions = <<DEFINITION
[
  {
    "cpu": 128,
    "essential": true,
    "image": "nginx:latest",
    "memory": 128,
    "memoryReservation": 64,
    "name": "frontend"
  }
]
DEFINITION
}

resource "aws_ecs_service" "frontend" {
  name          = "frontend"
  cluster       = aws_ecs_cluster.ecscluster.id
  desired_count = 1

  # Track the latest ACTIVE revision
  task_definition = "${aws_ecs_task_definition.application.family}:${max(aws_ecs_task_definition.frontend.revision, data.aws_ecs_task_definition.application.revision)}"