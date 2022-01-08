variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "domains" {
  type    = list
  default = [
    "dimarushchak.me",
    "www.dimarushchak.me"
  ]
}