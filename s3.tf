resource "aws_s3_bucket" "rilsite" {
  bucket = "s3-static-website-bucket"
}

resource "aws_s3_bucket_website_configuration" "rilsite" {
  bucket = aws_s3_bucket.rilsite.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

resource "aws_s3_bucket_public_access_block" "rilsite" {
  bucket = aws_s3_bucket.rilsite.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "rilsite_public_read" {
  bucket = aws_s3_bucket.rilsite.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "PublicReadGetObject"
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.rilsite.arn}/*"
    }]
  })

  depends_on = [aws_s3_bucket_public_access_block.rilsite]
}