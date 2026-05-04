package cicd

default allow = true

deny[msg] {
  input.course_price < 0
  msg := "course_price must be non-negative"
}

deny[msg] {
  input.isPublished == true
  input.content_missing == true
  msg := "published course must not have missing content"
}

deny[msg] {
  input.env != "prod"
  msg := "deployment only allowed in prod environment"
}
