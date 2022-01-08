output "ccv_URL" {
  value = aws_s3_bucket.ccv.website_endpoint
}

output "rd_ccv_URL" {
  value = aws_s3_bucket.rd_ccv.website_endpoint
}

output "domains_names" {
  value = var.domains
}