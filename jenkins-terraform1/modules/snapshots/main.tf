variable "instance_id" {}

resource "aws_iam_role" "dlm_role" {
  name = "dlm-lifecycle-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = { Service = "dlm.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.dlm_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSDataLifecycleManagerServiceRole"
}

resource "aws_dlm_lifecycle_policy" "daily" {
  description        = "Daily Jenkins EBS snapshots"
  execution_role_arn = aws_iam_role.dlm_role.arn
  state              = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]

    schedule {
      name = "daily"

      create_rule {
        interval      = 24
        interval_unit = "HOURS"
      }

      retain_rule {
        count = 7
      }
    }

    target_tags = {
      Name = "jenkins-server"
    }
  }
}
