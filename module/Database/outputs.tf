# This is outputs file for the Database module 

output "Host" {
  value = aws_db_instance.maindatabase.endpoint
}

output "dbname" {
  value = aws_db_instance.maindatabase.db_name
}

output "Username" {
  value = aws_db_instance.maindatabase.username
}

output "Password" {
  value = aws_db_instance.maindatabase.password
}

output "Port" {
  value = aws_db_instance.maindatabase.port
}

output "Name" {
  value = aws_db_instance.maindatabase.db_name
}

output "Identifier" {
  value = aws_db_instance.maindatabase.identifier
}