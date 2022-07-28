#!/bin/bash

terraform apply --auto-approve

sleep 40

terraform destroy --auto-approve