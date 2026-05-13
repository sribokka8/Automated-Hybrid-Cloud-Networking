# S3 Bucket Policy to allow VPC Flow Logs
resource "aws_s3_bucket_policy" "flow_logs_bucket_policy" {
  bucket = aws_s3_bucket.flow_logs_bucket.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        },
        Action = "s3:PutObject",
        Resource = "${aws_s3_bucket.flow_logs_bucket.arn}/*",
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}

# AWS VPC Flow Log (corrected)
resource "aws_flow_log" "aws_vpc_flow_log" {
  log_destination      = aws_s3_bucket.flow_logs_bucket.arn
  log_destination_type = "s3"  # Explicitly set destination type
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.aws_vpc.id
}

# On-Prem VPC Flow Log (corrected)
resource "aws_flow_log" "onprem_vpc_flow_log" {
  log_destination      = aws_s3_bucket.flow_logs_bucket.arn
  log_destination_type = "s3"  # Explicitly set destination type
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.onprem_vpc.id
}

# Add this to your data sources
data "aws_caller_identity" "current" {}