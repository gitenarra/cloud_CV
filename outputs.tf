output "site_URL" {
 value = aws_s3_bucket.ccv.website_endpoint
}

/*output "name" {
 value = aws_acm_certificate.cert.resource_record_name
}*/

output "value" {
 value = aws_acm_certificate.cert.domain_validation_options.resource_record_value
}
