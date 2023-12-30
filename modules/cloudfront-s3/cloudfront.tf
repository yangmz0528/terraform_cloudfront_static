data "aws_cloudfront_cache_policy" "s3_cache_policy" {
  name = "Managed-CachingOptimized"
}


resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    # Attribute "bucket_regional_domain_name" from your s3 bucket and use here
    domain_name              = aws_s3_bucket.cloudfront.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id                = "s3origin" # Must be same value as line 20
  }


  enabled             = true
  comment             = "" # Add a description regarding your cloudfront environment here
  default_root_object = "index.html"


  default_cache_behavior {
    cache_policy_id        = data.aws_cloudfront_cache_policy.s3_cache_policy.id
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "s3origin" # Must be same value as line 9
    viewer_protocol_policy = "allow-all"
  }


  # You will need to update this “viewer_certificate” block IF you are planning to use ACM
  viewer_certificate {
    cloudfront_default_certificate = true
  }


  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
}


resource "aws_cloudfront_origin_access_control" "oac" {
  # You can prefix it with your s3 bucket name(e.g. YourBucketName-oac)
  name                              = "${aws_s3_bucket.cloudfront.id}-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
