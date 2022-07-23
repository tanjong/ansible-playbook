locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Service     = "devOps"
    Owner       = "dev_lab"
    environment = "Development"
    ManagedWith = "terraform"
  }
  main                    = "devlab"
  buildregion             = lower("centralus")
}