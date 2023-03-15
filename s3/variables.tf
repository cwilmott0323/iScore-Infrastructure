variable "countries" {
  type = map(map(list(string)))
  description = "List of countries to create folders for"
}