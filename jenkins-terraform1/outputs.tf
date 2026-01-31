output "jenkins_url" {
  value = "http://${module.ec2.eip}:8080"
}
