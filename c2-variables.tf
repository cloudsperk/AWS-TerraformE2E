resource "aws_s3_bucket" "demo_bucket" {
  bucket = "cloudsperkdemobucket"

  tags = {
    Name        = "cloudsperkdemobucket"
    Environment = "Dev"
  }
}