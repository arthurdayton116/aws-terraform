// https://aws.amazon.com/blogs/security/how-to-help-lock-down-a-users-amazon-ec2-capabilities-to-a-single-vpc/
// https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_boundaries.html
//  aws sts decode-authorization-message --encoded-message message

resource "aws_iam_policy" "minecraft_ec2" {
  name        = "${local.resource_prefix}-minecraft-ec2"
  description = "Policy for ec2 for minecraft user"
  policy      = data.aws_iam_policy_document.minecraft_ec2.json
}

data "aws_iam_policy_document" "minecraft_ec2" {
  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "iam:*",
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = ["ec2:*", ]
    resources = [
      "*"
    ]
  }

}

resource "aws_iam_policy" "minecraft_policy_boundary" {
  name        = "${local.resource_prefix}-minecraft-boundary"
  description = "Policy for max permissions by minecraft user"
  policy      = data.aws_iam_policy_document.boundary.json
}

data "aws_iam_policy_document" "boundary" {
  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "iam:*",
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid = "NonResourceBasedPermissionsEc2"
    actions = ["ec2:Describe*",
      "ec2:ImportKeyPair",
      "ec2:CreateKeyPair",

      "ec2:AssociateAddress",
      "ec2:DeleteNetworkAcl",
      "ec2:DeleteNetworkAclEntry",
      "ec2:DeleteRoute",
      "ec2:DeleteRouteTable",

      //        "ec2:DescribeSecurityGroups",
      //        "ec2:DescribeSecurityGroupReferences",
      //        "ec2:DescribeStaleSecurityGroups",
      //        "ec2:DescribeVpcs",
      //        "ec2:DescribeSubnets",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateSecurityGroup",
      "ec2:DeleteSecurityGroup",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:UpdateSecurityGroupRuleDescriptionsIngress",
      "ec2:UpdateSecurityGroupRuleDescriptionsEgress"
    ]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    actions = ["ec2:*"
      //            "ec2:RebootInstances",
      //            "ec2:StopInstances",
      //            "ec2:TerminateInstances",
      //            "ec2:StartInstances",
      //            "ec2:AttachVolume",
      //            "ec2:DetachVolume",
      //      "ec2:RunInstances"
    ]

    resources = [
      "*"
    ]

    //    condition {
    //      test     = "StringLike"
    //      variable = "ec2:InstanceType"
    //
    //      values = [
    //        "t2.micro",
    //        "t2.small",
    //        "t2.medium",
    //        "t3.micro",
    //        "t3.small",
    //        "t3.medium",
    //      ]
    //    }
  }
}

//resource "aws_iam_policy" "ec2_non_resource_based_policy" {
//  name        = "${local.resource_prefix}-ec2-non-resource-based"
//  description = "Policy for ec2 non resource based permissions"
//  policy      = data.aws_iam_policy_document.NonResourceBasedPermissions.json
//}
//
//data "aws_iam_policy_document" "NonResourceBasedPermissions" {
//  version = "2012-10-17"
//
//  statement {
//    sid = "NonResourceBasedPermissionsEc2"
//    actions = ["ec2:Describe*",
//      "ec2:ImportKeyPair",
//      "ec2:CreateKeyPair",
//      "ec2:CreateSecurityGroup",
//      "ec2:AssociateAddress",
//      "iam:GetInstanceProfiles",
//    "iam:ListInstanceProfiles"]
//    effect    = "Allow"
//    resources = ["*"]
//  }
//
////  statement {
////    sid       = "IAMPassroleToInstance"
////    actions   = ["iam:PassRole"]
////    effect    = "Allow"
////    resources = ["arn:aws:iam::793219755011:instance-profile/vpclockdown2"]
////  }
//
//  statement {
//    sid = "EC2VpcNonresourceSpecificActions"
//    actions = ["ec2:DeleteNetworkAcl",
//      "ec2:DeleteNetworkAclEntry",
//      "ec2:DeleteRoute",
//      "ec2:DeleteRouteTable",
//      "ec2:DescribeSecurityGroups",
//      "ec2:ApplySecurityGroupsToClientVpnTargetNetwork",
//      "ec2:UpdateSecurityGroupRuleDescriptionsIngress",
//      "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
//      "ec2:AuthorizeSecurityGroupEgress",
//      "ec2:AuthorizeSecurityGroupIngress",
//      "ec2:RevokeSecurityGroupEgress",
//      "ec2:RevokeSecurityGroupIngress",
//    "ec2:DeleteSecurityGroup"]
//    effect    = "Allow"
//    resources = ["*"]
////    condition {
////      test     = "StringEquals"
////      values   = [local.vpc_arn]
////      variable = "ec2:vpc"
////    }
//  }
//
//
//
//
//
//  statement {
//    sid = "NonResourceBasedPermissionsElb"
//    actions = [
//      "elasticloadbalancing:DescribeLoadBalancers"
//    ]
//    effect    = "Allow"
//    resources = ["*"]
//  }
//
//  statement {
//    sid = "NonResourceBasedPermissionsHealth"
//    actions = [
//      "health:Describe*"
//    ]
//    effect    = "Allow"
//    resources = ["*"]
//  }
//
//  statement {
//    sid = "AllowInstanceActions"
//    actions = [
//      "ec2:RebootInstances",
//      "ec2:StopInstances",
//      "ec2:TerminateInstances",
//      "ec2:StartInstances",
//      "ec2:AttachVolume",
//      "ec2:DetachVolume"
//    ]
//    effect    = "Allow"
//    resources = ["arn:aws:ec2:${local.region}:${var.aws_account_number}:instance/*"]
////    condition {
////      test     = "StringEquals"
////      values   = ["arn:aws:iam::793219755011:instance-profile/vpclockdown2"]
////      variable = "ec2:InstanceProfile"
////    }
//
//    //    condition {
//    //            test     = "StringLike"
//    //            variable = "ec2:InstanceType"
//    //
//    //            values = [
//    //              "t2.micro",
//    //              "t2.small",
//    //              "t2.medium",
//    //              "t3.micro",
//    //              "t3.small",
//    //              "t3.medium",
//    //            ]
//    //          }
//
//  }
//
//  statement {
//    sid = "EC2RunInstances"
//    actions = [
//      "ec2:RunInstances"
//    ]
//    effect    = "Allow"
//    resources = ["arn:aws:ec2:${local.region}:${var.aws_account_number}:instance/*"]
////    condition {
////      test     = "StringEquals"
////      values   = ["arn:aws:iam::793219755011:instance-profile/vpclockdown2"]
////      variable = "ec2:InstanceProfile"
////    }
//  }
//
//  statement {
//    sid = "EC2RunInstancesSubnet"
//    actions = [
//      "ec2:RunInstances"
//    ]
//    effect    = "Allow"
//    resources = ["arn:aws:ec2:${local.region}:${var.aws_account_number}:subnet/*"]
////    condition {
////      test     = "StringEquals"
////      values   = ["arn:aws:ec2:${local.region}:${var.aws_account_number}:vpc/${local.vpc_id}"]
////      variable = "ec2:vpc"
////    }
//  }
//
//  statement {
//    sid = "RemainingRunInstancePermissions"
//    actions = [
//      "ec2:RunInstances"
//    ]
//    effect = "Allow"
//    resources = [
//      "arn:aws:ec2:${local.region}:${var.aws_account_number}:volume/*",
//      "arn:aws:ec2:${local.region}::image/*",
//      "arn:aws:ec2:${local.region}::snapshot/*",
//      "arn:aws:ec2:${local.region}:${var.aws_account_number}:network-interface/*",
//      "arn:aws:ec2:${local.region}:${var.aws_account_number}:key-pair/*",
//      "arn:aws:ec2:${local.region}:${var.aws_account_number}:security-group/*",
//      "arn:aws:ec2:${local.region}:${var.aws_account_number}:subnet/*"
//    ]
////    condition {
////      test     = "StringEquals"
////      values   = ["arn:aws:iam::793219755011:instance-profile/vpclockdown2"]
////      variable = "ec2:InstanceProfile"
////    }
//  }
//
//
//}

