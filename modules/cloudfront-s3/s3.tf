resource "aws_s3_bucket" "cloudfront" {
  bucket = "mingzi-sctp4-terraform-cloudfront"

  tags = {
    Name        = "${var.prefix}-bucket"
    Environment = "nonprod"
  }
}

resource "aws_s3_bucket_policy" "cloudfront" {
  bucket = aws_s3_bucket.cloudfront.id
  policy = data.aws_iam_policy_document.cloudfront.json
}