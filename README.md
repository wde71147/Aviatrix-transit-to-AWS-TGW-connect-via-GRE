# Aviatrix-transit-to-AWS-TGW-connect-via-GRE

# I haven't found a good way yet to automatically update the subnet IDs when building the transit gateway vpc attachment to the AWS TGW, so you need to follow this workflow:
# 1) Rename AWS_TGWs.tf to AWS.TGWs.tf.hold
# 2) Run terraform plan and terraform apply
# 3) Rename AWS_TGWs.tf.hold to AWS.TGWs.tf
# 4) Update lines 27, 162, 197, and 353 with the correct subnet IDs and route table IDs for the newly created Aviatrix transit VPC.
#   - these should be the subnets and associated route tables where the gateway management interfaces live
# 5) Save AWS_TGWs.tf
# 6) Run terraform plan and terraform apply
