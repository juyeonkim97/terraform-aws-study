resource "aws_s3_bucket" "static_website_bucket" {
  bucket = "aws-s3-quest"
}

resource "aws_s3_bucket_ownership_controls" "static_website_bucket" {
  bucket = aws_s3_bucket.static_website_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "static_website_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.static_website_bucket]

  bucket = aws_s3_bucket.static_website_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "static_website_bucket" {
  bucket = aws_s3_bucket.static_website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "static_website_bucket" {
  for_each = fileset("./static/", "**")
  bucket   = aws_s3_bucket.static_website_bucket.id
  key      = each.value
  source   = "./static/${each.value}"
  etag     = filemd5("./static/${each.value}")
}
