#!/bin/bash
set -ex
declare -r DOMAIN_NAME=$1

# Terraform can't manage domains. This gets the nameservers off the hosted zone and sets them as the nameservers for the domain
NS1=$(terraform show --json | jq --raw-output '.values.root_module.resources[] | select(.address == "aws_route53_zone.website_r53_zone") | .values.name_servers[0]')
NS2=$(terraform show --json | jq --raw-output '.values.root_module.resources[] | select(.address == "aws_route53_zone.website_r53_zone") | .values.name_servers[1]')
NS3=$(terraform show --json | jq --raw-output '.values.root_module.resources[] | select(.address == "aws_route53_zone.website_r53_zone") | .values.name_servers[2]')
NS4=$(terraform show --json | jq --raw-output '.values.root_module.resources[] | select(.address == "aws_route53_zone.website_r53_zone") | .values.name_servers[3]')
aws --region us-east-1 route53domains update-domain-nameservers --domain-name "$DOMAIN_NAME" --nameservers Name="$NS1" Name="$NS2" Name="$NS3" Name="$NS4"
