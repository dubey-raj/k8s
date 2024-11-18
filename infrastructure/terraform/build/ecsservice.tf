### Create Amazon ECS task definition and service

# Create Amazon ECS task definition
resource "aws_ecs_task_definition" "ecs-task-definition" {
  family                   = format("%s%s%s%s", var.Prefix, "ect", var.EnvCode, "mswebapp")
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecstaskexec.arn

  container_definitions = jsonencode([
    {
      name                   = "mswebapp" #${var.application}
      image                  = var.ImageTag
      cpu                    = 256
      memory                 = 512
      essential              = true
      readonlyRootFilesystem = true
      portMappings = [
        {
          containerPort = 8080
          protocol      = "tcp"
        }
      ]
      logconfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "${aws_cloudwatch_log_group.log_group.name}",
          awslogs-region        = "${var.Region}",
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

# Create Amazon ECS task service
resource "aws_ecs_service" "ecs-service" {
  name            = format("%s%s%s%s", var.Region, "iar", var.EnvCode, "svcmswebapp")
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs-task-definition.arn
  launch_type     = "FARGATE"
  desired_count   = 2
  propagate_tags  = "TASK_DEFINITION"


  network_configuration {
    subnets         = [aws_subnet.priv_subnet_01.id, aws_subnet.priv_subnet_02.id]
    security_groups = [aws_security_group.app01.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb-target-group.arn
    container_name   = "mswebapp"
    container_port   = 8080
  }

  tags = {
    Name  = format("%s%s%s%s", var.Region, "iar", var.EnvCode, "svcmswebapp")
    rtype = "ecsservice"
  }
}