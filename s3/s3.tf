resource "aws_s3_bucket" "iscore-media" {
  bucket = "iscore-media"
  object_lock_enabled = true

}

#resource "aws_s3_bucket_policy" "block" {
#  bucket = aws_s3_bucket.iscore-images.id
#  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
#}

#data "aws_iam_policy_document" "allow_access_from_another_account" {
#  statement {
#
#    principals {
#      identifiers = ["*"]
#      type        = "*"
#    }
#
#    effect = "Deny"
#    sid = "DenyOutsideIPfromBucket"
#
#    actions = [
#      "s3:ListBucket",
#      "s3:GetBucketLocation",
#      "s3:PutObject",
#      "s3:GetObject",
#      "s3:ListBucket",
#      "s3:GetObjectVersion"
#    ]
#
#    resources = [
#      aws_s3_bucket.iscore-media.arn,
#      "${aws_s3_bucket.iscore-media.arn}/*",
#    ]
#    condition {
#      test     = "NotIpAddress"
#      values   = ["18.67.39.0/8"]
#      variable = "aws:SourceIp"
#    }
#  }
#}

#resource "aws_s3_bucket_public_access_block" "block-all" {
#  bucket = aws_s3_bucket.iscore-media.id
#
#  block_public_acls       = true
#  block_public_policy     = true
#  ignore_public_acls      = true
#  restrict_public_buckets = true
#}

resource "aws_s3_object" "global" {
  bucket = aws_s3_bucket.iscore-media.id
  acl    = "public-read"
  key    = "Global/"
  source = "/dev/null"
}

resource "aws_s3_object" "countries-top-level" {
  bucket = aws_s3_bucket.iscore-media.id
  acl    = "public-read"
  key    = "Countries/"
  source = "/dev/null"
}

resource "aws_s3_object" "countries" {
  for_each   = toset(var.countries)
  bucket = aws_s3_bucket.iscore-media.id
  acl    = "public-read"
  key    = "${aws_s3_object.countries-top-level.key}/${each.key}/"
  source = "/dev/null"
}