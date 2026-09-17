# ################################################################################
# ECR
# ################################################################################

resource "aws_ecr_repository" "frontend" {
  name = "std01-ex8-frontend"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "std01-ex8-frontend"
  }
}

resource "aws_ecr_repository" "backend" {
  name = "std01-ex8-backend"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "std01-ex8-backend"
  }
}
