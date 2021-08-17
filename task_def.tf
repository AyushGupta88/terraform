# Simply specify the family to find the latest ACTIVE revision in that family.
data "aws_ecs_task_definition" "frontend" {
  task_definition = aws_ecs_task_definition.frontend.family
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
  launch_type     = "EC2"
  //task_definition = aws_ecs_task_definition.frontend

  # Track the latest ACTIVE revision
  task_definition = "${aws_ecs_task_definition.frontend.family}:${max(aws_ecs_task_definition.frontend.revision, data.aws_ecs_task_definition.frontend.revision)}"
}