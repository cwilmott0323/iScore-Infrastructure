resource "aws_s3_bucket" "tf-state-bucket" {
  bucket = "iscore-terraform-state"
  object_lock_enabled = true

}

resource "aws_s3_bucket_policy" "block" {
  bucket = aws_s3_bucket.tf-state-bucket.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {

    principals {
      identifiers = ["*"]
      type        = "*"
    }

    effect = "Deny"
    sid = "DenyOutsideIPfromBucket"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:GetObjectVersion"
    ]

    resources = [
      aws_s3_bucket.tf-state-bucket.arn,
      "${aws_s3_bucket.tf-state-bucket.arn}/*",
    ]
    condition {
      test     = "NotIpAddress"
      values   = ["99.237.136.192/32", "24.114.57.101/32"]
      variable = "aws:SourceIp"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block-all" {
  bucket = aws_s3_bucket.tf-state-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}