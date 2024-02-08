variable "prefix" {
  type    = string
  default = "demoprojm2024"
}
variable "location" {
  type    = string
  default = "westeurope"
}
variable "admin_pass" {
  type      = string
  sensitive = true
}
