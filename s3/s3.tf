locals {
  s3_folders = flatten([
    for country, cities in var.countries: [
      for city, activities in cities: [
      for activity in activities: "${country}/${city}/Activities/${activity}"
      ]
    ]
  ])

  s3_general = flatten([
    for country, cities in var.countries: country
  ])

  s3_country_general = flatten([
    for country, cities in var.countries: country
  ])

  s3_city_general = flatten([
    for country, cities in var.countries: [
    for city, activity in cities: "${country}/${city}"
    ]
  ])
}

resource "aws_s3_bucket" "iscore-media" {
  bucket              = "iscore-media"
  object_lock_enabled = true
}

resource "aws_s3_bucket" "iscore-users" {
  bucket              = "iscore-users"
  object_lock_enabled = true
}

resource "aws_s3_bucket" "iscore-api-binary" {
  bucket              = "iscore-api-binary"
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

resource "aws_s3_object" "s3_folders" {
  for_each = toset(local.s3_folders)
  bucket   = aws_s3_bucket.iscore-media.id
  acl      = "public-read"
  key      = "${aws_s3_object.countries-top-level.key}/${each.key}/"
  source   = "/dev/null"
}

resource "aws_s3_object" "s3_general" {
  for_each = toset(local.s3_general)
  bucket   = aws_s3_bucket.iscore-media.id
  acl      = "public-read"
  key      = "${aws_s3_object.countries-top-level.key}/${each.key}/General/"
  source   = "/dev/null"
}

resource "aws_s3_object" "country_general" {
  for_each = toset(local.s3_country_general)
  bucket = aws_s3_bucket.iscore-media.id
  key    = "${aws_s3_object.countries-top-level.key}/${each.key}/General/${each.key}"
  source = "media/countries/${each.key}/general/${each.key}"
  etag = filemd5("media/countries/${each.key}/general/${each.key}")
}

resource "aws_s3_object" "city_general" {
  for_each = toset(local.s3_city_general)
  bucket = aws_s3_bucket.iscore-media.id
  key    = "${aws_s3_object.countries-top-level.key}/${split("/",each.key)[0]}/${split("/",each.key)[1]}/${split("/",each.key)[1]}"
  source = "media/countries/${split("/",each.key)[0]}/cities/${split("/",each.key)[1]}/general/${split("/",each.key)[1]}"
  etag = filemd5("media/countries/${split("/",each.key)[0]}/cities/${split("/",each.key)[1]}/general/${split("/",each.key)[1]}")
}

resource "aws_s3_object" "activities_general" {
  for_each = toset(local.s3_folders)
  bucket = aws_s3_bucket.iscore-media.id
  key    = "${aws_s3_object.countries-top-level.key}/${split("/",each.key)[0]}/${split("/",each.key)[1]}/Activities/${split("/",each.key)[3]}/${split("/",each.key)[3]}"
  source = "media/countries/${split("/",each.key)[0]}/cities/${split("/",each.key)[1]}/activities/${split("/",each.key)[3]}/${split("/",each.key)[3]}"
  etag = filemd5("media/countries/${split("/",each.key)[0]}/cities/${split("/",each.key)[1]}/activities/${split("/",each.key)[3]}/${split("/",each.key)[3]}")
}