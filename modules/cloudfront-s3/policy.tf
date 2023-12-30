data "aws_iam_policy_document" "cloudfront" {
  statement {
    sid = "AllowCloudFrontServicePrincipal"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.cloudfront.arn}/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }

}
