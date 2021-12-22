provider "aws" {
 region = var.region
}

resource "aws_s3_bucket" "my_site" {
 bucket = "s3-my-site"
  website {
   index_document = "index.html"
   error_document = "error.html"
 }
}

resource "aws_s3_bucket_policy" "site_policy" {
 bucket = aws_s3_bucket.my_site.id
 policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.my_site.id}/*"
        }
    ]
}
EOF
}

resource "aws_s3_bucket_object" "folder_tree" {
  bucket = aws_s3_bucket.my_site.id
  content_type = "text/html"
  key = each.value
  for_each = fileset("/home/giten/ccv/", "*")
  source = "/home/giten/ccv/${each.value}"
}

resource "aws_s3_bucket_object" "css" {
  bucket = aws_s3_bucket.my_site.id
  content_type = "text/css"
  for_each = fileset("/home/giten/ccv/css/", "*")
  key    = "/css/${each.value}"
  source = "/home/giten/ccv/css/${each.value}"
}

resource "aws_s3_bucket_object" "images_svg" {
  bucket = aws_s3_bucket.my_site.id
  content_type = "image/svg+xml"
  for_each = fileset("/home/giten/ccv/images/", "*.svg")
  key    = "/images/${each.value}"
  source = "/home/giten/ccv/images/${each.value}"
}

resource "aws_s3_bucket_object" "images_png" {
  bucket = aws_s3_bucket.my_site.id
  content_type = "image/png"
  for_each = fileset("/home/giten/ccv/images/", "*.png")
  key    = "/images/${each.value}"
  source = "/home/giten/ccv/images/${each.value}"
}

resource "aws_s3_bucket_object" "images_jpg" {
  bucket = aws_s3_bucket.my_site.id
  content_type = "image/jpeg"
  for_each = fileset("/home/giten/ccv/images/", "*.jpg")
  key    = "/images/${each.value}"
  source = "/home/giten/ccv/images/${each.value}"
}

resource "aws_s3_bucket_object" "js" {
  bucket = aws_s3_bucket.my_site.id
  content_type = "application/javascript"
  for_each = fileset("/home/giten/ccv/js/", "*")
  key    = "/js/${each.value}"
  source = "/home/giten/ccv/js/${each.value}"
}

resource "aws_s3_bucket_object" "fonts" {
  bucket = aws_s3_bucket.my_site.id
  content_type = "application/javascript"
  for_each = fileset("/home/giten/ccv/fonts/", "*")
  key    = "/fonts/${each.value}"
  source = "/home/giten/ccv/fonts/${each.value}"
}
