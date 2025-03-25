# Copyright © 2022 Amazon Web Services, Inc. or its affiliates. All Rights Reserved. This AWS Content is provided subject to the terms of the AWS Customer Agreement available at http://aws.amazon.com/agreement or other written agreement between Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both."

#### (1) switch module ####
module "mwaa_switch" {
  source = "../../../"

  git_personal_access_token    = jsondecode(data.aws_secretsmanager_secret_version.github_token_secret_version.secret_string)["TOKEN"]
  source_type                  = "GITHUB"
  switch_additional_policy_arn = aws_iam_policy.mwaa_switch_policy.arn
  source_location              = var.source_location
  kill_resources_schedule      = var.kill_resources_schedule
  revive_resources_schedule    = var.revive_resources_schedule
  init_command                 = var.init_command
  kill_command                 = var.kill_command
  revive_command               = var.revive_command
  terraform_version            = var.terraform_version
  tf_backend_bucket            = var.tf_backend_bucket
  tf_backend_key               = var.tf_backend_key
}

#### (0) Switch Policy for MWAA ####
resource "aws_iam_policy" "mwaa_switch_policy" {
  name_prefix = "MWAASwitchPolicy"
  description = "A policy for MWAA operations."

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
        "Effect": "Allow",
        "Action": [
          "iam:ListRolePolicies",
          "iam:GetRole",
          "iam:GetRolePolicy",
          "iam:ListAttachedRolePolicies"
        ],
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": "airflow:*",
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "iam:CreateServiceLinkedRole"
        ],
        "Resource": "arn:aws:iam::*:role/aws-service-role/airflow.amazonaws.com/AWSServiceRoleForAmazonMWAA"
    },
    {
        "Effect": "Allow",
        "Action": [
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeSubnets",
            "ec2:DescribeVpcs",
            "ec2:DescribeRouteTables",
            "ec2:DescribeAvailabilityZones",
            "ec2:DescribeVpcClassicLink",
            "ec2:DescribeVpcClassicLinkDnsSupport",
            "ec2:DescribeVpcAttribute",
            "ec2:DescribeInternetGateways",
            "ec2:DescribeNatGateways"
        ],
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "kms:DescribeKey",
            "kms:ListGrants",
            "kms:CreateGrant",
            "kms:RevokeGrant",
            "kms:Decrypt",
            "kms:Encrypt",
            "kms:GenerateDataKey*",
            "kms:ReEncrypt*"
        ],
        "Resource": "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:key/aws/airflow"
    },
    {
        "Effect": "Allow",
        "Action": [
            "iam:PassRole"
        ],
        "Resource": "*",
        "Condition": {
            "StringLike": {
                "iam:PassedToService": "airflow.amazonaws.com"
            }
        }
    },
    {
        "Effect": "Allow",
        "Action": [
            "s3:GetEncryptionConfiguration"
        ],
        "Resource": "arn:aws:s3:::*"
    },
    {
        "Effect": "Allow",
        "Action": "ec2:CreateVpcEndpoint",
        "Resource": [
            "arn:aws:ec2:*:*:vpc-endpoint/*",
            "arn:aws:ec2:*:*:vpc/*",
            "arn:aws:ec2:*:*:subnet/*",
            "arn:aws:ec2:*:*:security-group/*"
        ]
    },
    {
        "Effect": "Allow",
        "Action": [
            "ec2:CreateNetworkInterface"
        ],
        "Resource": [
            "arn:aws:ec2:*:*:subnet/*",
            "arn:aws:ec2:*:*:network-interface/*"
        ]
    },

    {
        "Effect": "Allow",
        "Action": [
            "eks:CreateCluster",
                "eks:DescribeCluster",
                "eks:DeleteCluster",
                "eks:ListClusters",
                "eks:DescribeNodegroup",
                "eks:ListNodegroups",
                "eks:CreateNodegroup",
                "eks:DeleteNodegroup",
                "iam:CreateRole",
                "iam:DeleteRole",
                "iam:AttachRolePolicy",
                "iam:DetachRolePolicy",
                "iam:GetRole",
                "iam:ListAttachedRolePolicies",
                "iam:ListRoles",
                "ec2:CreateVpc",
                "ec2:DeleteVpc",
                "ec2:DescribeVpcs",
                "ec2:CreateSubnet",
                "ec2:DeleteSubnet",
                "ec2:DescribeSubnets",
                "ec2:CreateInternetGateway",
                "ec2:DeleteInternetGateway",
                "ec2:AttachInternetGateway",
                "ec2:DetachInternetGateway",
                "ec2:DescribeInternetGateways",
                "ec2:CreateRouteTable",
                "ec2:DeleteRouteTable",
                "ec2:DescribeRouteTables",
                "ec2:CreateRoute",
                "ec2:DeleteRoute",
                "ec2:AssociateRouteTable",
                "ec2:DisassociateRouteTable",
                "ec2:CreateNetworkAcl",
                "ec2:DeleteNetworkAcl",
                "ec2:DescribeNetworkAcls",
                "ec2:CreateNetworkAclEntry",
                "ec2:DeleteNetworkAclEntry",
                "ec2:CreateSecurityGroup",
                "ec2:DeleteSecurityGroup",
                "ec2:DescribeSecurityGroups",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:AuthorizeSecurityGroupEgress",
                "ec2:RevokeSecurityGroupIngress",
                "ec2:RevokeSecurityGroupEgress",
                "ec2:CreateTags",
                "ec2:DeleteTags",
                "ec2:DescribeTags",
                "ec2:DescribeImages",
                "ec2:DescribeRegions",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeInstanceTypes",
                "ec2:DescribeSubnetNetworkAclAssociation",
                "ec2:DescribeRouteTableAssociations",
                "ec2:DescribeRouteTableRoute",
                "ec2:DescribeNetworkAclEntries",
                "ec2:DescribeSecurityGroupRules",
                "s3:GetObject",
                "s3:PutObject",
                "s3:ListBucket",
                "s3:CreateBucket",
                "s3:DeleteBucket",
                "s3:DeleteObject"
        ],
        "Resource": "*"
    }
  ]
}
EOF  
}