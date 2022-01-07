provider "aws" {
 region = var.region
}

resource "aws_s3_bucket" "ccv" {
 bucket = var.domain
  website {
   index_document = "index.html"
   error_document = "error.html"
 }
}

resource "aws_s3_bucket" "rd_ccv" {
 bucket = "www.${var.domain}"
  website {
   redirect_all_requests_to = "https://${var.domain}" 
 }
}

resource "aws_s3_bucket_policy" "ccv_policy" {
 bucket = aws_s3_bucket.ccv.id
 policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.ccv.id}/*"
        }
    ]
}
EOF
}

resource "aws_acm_certificate" "create_cert" {
  domain_name       = aws_s3_bucket.ccv.id
  subject_alternative_names = [aws_s3_bucket.rd_ccv.id]
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "basic" {
  name = var.domain
}

resource "aws_route53_record" "cert" { 
  for_each = { 
    for dvo in aws_acm_certificate.create_cert.domain_validation_options : dvo.domain_name => { 
      name   = dvo.resource_record_name 
      record = dvo.resource_record_value 
      type   = dvo.resource_record_type 
    } 
  } 
 
  name            = each.value.name 
  records         = [each.value.record] 
  ttl             = 300 
  type            = each.value.type 
  zone_id         = data.aws_route53_zone.basic.zone_id 
}


  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.ccv.id
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }
  }  
}

resource "aws_s3_bucket_object" "folder_tree" {
  bucket = aws_s3_bucket.ccv.id
  content_type = "text/html"
  key = each.value
  for_each = fileset("/home/giten/ccv/", "*")
  source = "/home/giten/ccv/${each.value}"
}

resource "aws_s3_bucket_object" "css" {
  bucket = aws_s3_bucket.ccv.id
  content_type = "text/css"
  for_each = fileset("/home/giten/ccv/css/", "*")
  key    = "/css/${each.value}"
  source = "/home/giten/ccv/css/${each.value}"
}

resource "aws_s3_bucket_object" "images_svg" {
  bucket = aws_s3_bucket.ccv.id
  content_type = "image/svg+xml"
  for_each = fileset("/home/giten/ccv/images/", "*.svg")
  key    = "/images/${each.value}"
  source = "/home/giten/ccv/images/${each.value}"
}

resource "aws_s3_bucket_object" "images_png" {
  bucket = aws_s3_bucket.ccv.id
  content_type = "image/png"
  for_each = fileset("/home/giten/ccv/images/", "*.png")
  key    = "/images/${each.value}"
  source = "/home/giten/ccv/images/${each.value}"
}

resource "aws_s3_bucket_object" "images_jpg" {
  bucket = aws_s3_bucket.ccv.id
  content_type = "image/jpeg"
  for_each = fileset("/home/giten/ccv/images/", "*.jpg")
  key    = "/images/${each.value}"
  source = "/home/giten/ccv/images/${each.value}"
}

resource "aws_s3_bucket_object" "js" {
  bucket = aws_s3_bucket.ccv.id
  content_type = "application/javascript"
  for_each = fileset("/home/giten/ccv/js/", "*")
  key    = "/js/${each.value}"
  source = "/home/giten/ccv/js/${each.value}"
}

