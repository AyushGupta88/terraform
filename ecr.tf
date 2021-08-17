resource "aws_ecr_repository" "Repo" {
    name = "frontend"
    image_tag_mutability = "MUTABLE"
    image_scanning_configuration {
        scan_on_push = false
    }
}
resource "aws_ecr_repository_policy" "demo-repo-policy" {
  repository = aws_ecr_repository.Repo.name
  policy     = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "adds full ecr access to the demo repository",
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
      }
    ]
  }
  EOF
}
output "repo_url" {
    description = "ECR repo url"
    value = aws_ecr_repository.Repo.repository_url
}