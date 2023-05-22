resource "aws_iam_role" "eks_self_managed_node_group" {
  name               = "${var.eks_cluster_name}-${local.node_group_name}-role"
  assume_role_policy = file("${path.module}/iam_ec2_assume_role_policy.json")
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_self_managed_node_group.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_self_managed_node_group.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_self_managed_node_group.name
}

resource "aws_iam_instance_profile" "eks_self_managed_node_group" {
  name = "${var.eks_cluster_name}-${local.node_group_name}-instance-profile"
  role = aws_iam_role.eks_self_managed_node_group.name
  tags = var.tags
}


resource "aws_iam_policy" "k8_worker_policy" {
  name = "${var.eks_cluster_name}-k8-worker-policy"
  path = "/"

  policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
{
"Effect": "Allow",
"Action": [
"autoscaling:DescribeAutoScalingGroups",
"autoscaling:DescribeAutoScalingInstances",
"autoscaling:DescribeLaunchConfigurations",
"autoscaling:DescribeTags",
"autoscaling:SetDesiredCapacity",
"autoscaling:TerminateInstanceInAutoScalingGroup"
],
"Resource": "*"
},
{
"Effect": "Allow",
"Action": [
  "es:*"
],
"Resource": "*"
},
{
      "Effect": "Allow",
       "Action": [
          "ec2:DescribeTags",
          "cloudwatch:PutMetricData"
],
      "Resource": "*"
},
 {
      "Effect": "Allow",
      "Action": [
        "acm:DescribeCertificate",
        "acm:ListCertificates",
        "acm:GetCertificate"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:CreateSecurityGroup",
        "ec2:CreateTags",
        "ec2:DeleteTags",
        "ec2:DeleteSecurityGroup",
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceStatus",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:DescribeTags",
        "ec2:DescribeVpcs",
        "ec2:ModifyInstanceAttribute",
        "ec2:ModifyNetworkInterfaceAttribute",
        "ec2:RevokeSecurityGroupIngress",
        "ec2:DescribeNetworkInterfaces"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:AddTags",
        "elasticloadbalancing:CreateListener",
        "elasticloadbalancing:CreateLoadBalancer",
        "elasticloadbalancing:CreateRule",
        "elasticloadbalancing:CreateTargetGroup",
        "elasticloadbalancing:DeleteListener",
        "elasticloadbalancing:DeleteLoadBalancer",
        "elasticloadbalancing:DeleteRule",
        "elasticloadbalancing:DeleteTargetGroup",
        "elasticloadbalancing:DeregisterTargets",
        "elasticloadbalancing:DescribeListeners",
        "elasticloadbalancing:DescribeLoadBalancers",
        "elasticloadbalancing:DescribeLoadBalancerAttributes",
        "elasticloadbalancing:DescribeRules",
        "elasticloadbalancing:DescribeSSLPolicies",
        "elasticloadbalancing:DescribeTags",
        "elasticloadbalancing:DescribeTargetGroups",
        "elasticloadbalancing:DescribeTargetGroupAttributes",
        "elasticloadbalancing:DescribeTargetHealth",
        "elasticloadbalancing:DescribeListenerCertificates",
        "elasticloadbalancing:ModifyListener",
        "elasticloadbalancing:ModifyLoadBalancerAttributes",
        "elasticloadbalancing:ModifyRule",
        "elasticloadbalancing:ModifyTargetGroup",
        "elasticloadbalancing:ModifyTargetGroupAttributes",
        "elasticloadbalancing:RegisterTargets",
        "elasticloadbalancing:RemoveTags",
        "elasticloadbalancing:SetIpAddressType",
        "elasticloadbalancing:SetSecurityGroups",
        "elasticloadbalancing:SetSubnets",
        "elasticloadbalancing:SetWebACL",
        "elasticloadbalancing:AddListenerCertificates",
        "elasticloadbalancing:RemoveListenerCertificates"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:GetServerCertificate",
        "iam:ListServerCertificates",
        "iam:CreateServiceLinkedRole"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "waf-regional:GetWebACLForResource",
        "waf-regional:GetWebACL",
        "waf-regional:AssociateWebACL",
        "waf-regional:DisassociateWebACL"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "tag:GetResources",
        "tag:TagResources"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "waf:GetWebACL"
      ],
      "Resource": "*"
    },
    {
     "Effect": "Allow",
     "Action": [
       "route53:ChangeResourceRecordSets"
     ],
     "Resource": [
       "arn:aws:route53:::hostedzone/*"
     ]
   },
   {
     "Effect": "Allow",
     "Action": [
       "route53:ListHostedZones",
       "route53:ListResourceRecordSets"
     ],
     "Resource": [
       "*"
     ]
   },
   {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Action": [
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
         {
        "Action": "autoscaling:DescribeAutoScalingGroups",
        "Resource": "*",
        "Effect": "Allow"
    },
    {
        "Action": "autoscaling:AttachLoadBalancers",
        "Resource": "*",
        "Effect": "Allow"
    },
    {
        "Action": "autoscaling:DetachLoadBalancers",
        "Resource": "*",
        "Effect": "Allow"
    },
    {
        "Action": "autoscaling:DetachLoadBalancerTargetGroups",
        "Resource": "*",
        "Effect": "Allow"
    },
    {
        "Action": "autoscaling:AttachLoadBalancerTargetGroups",
        "Resource": "*",
        "Effect": "Allow"
    },
    {
        "Action": "autoscaling:DescribeLoadBalancerTargetGroups",
        "Resource": "*",
        "Effect": "Allow"
    },
    {
        "Action": "acm:GetCertificate",
        "Resource": "*",
        "Effect": "Allow"
    },
    {
        "Action": "acm:ListCertificates",
        "Resource": "*",
        "Effect": "Allow"
    },
    {
        "Action": "acm:DescribeCertificate",
        "Resource": "*",
        "Effect": "Allow"
    },
    {
        "Action": "iam:ListServerCertificates",
        "Resource": "*",
        "Effect": "Allow"
    },
    {
        "Action": "iam:GetServerCertificate",
        "Resource": "*",
        "Effect": "Allow"
    },
    {
        "Action": "cloudformation:Get*",
        "Resource": "*",
        "Effect": "Allow"
    },
    {
        "Action": "cloudformation:Describe*",
        "Resource": "*",
        "Effect": "Allow"
    },
    {
        "Action": "cloudformation:List*",
        "Resource": "*",
        "Effect": "Allow"
    },
    {
        "Action": "cloudformation:Create*",
        "Resource": "*",
        "Effect": "Allow"
    },
    {
        "Action": "cloudformation:Update*",
        "Resource": "*",
        "Effect": "Allow"
    },
    {
        "Action": "cloudformation:Delete*",
        "Resource": "*",
        "Effect": "Allow"
    },
    {
        "Effect": "Allow",
        "Action": [
            "ec2:AttachVolume",
            "ec2:DetachVolume",
            "ec2:CreateTags",
            "ec2:CreateVolume",
            "ec2:DeleteTags",
            "ec2:DeleteVolume",
            "ec2:DescribeTags",
            "ec2:DescribeVolumeAttribute",
            "ec2:DescribeVolumesModifications",
            "ec2:DescribeVolumeStatus",
            "ec2:DescribeVolumes",
            "ec2:DescribeInstances",
            "ec2:DescribeAccountAttributes",
            "ec2:DescribeInternetGateways"

        ],
        "Resource": [
            "*"
        ]
    },
    {
        "Effect": "Allow",
        "Action": "s3:*",
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Resource": "arn:aws:iam::190345255876:role/${var.eks_cluster_name}-windmilleye-access"
    }
]
}
EOF
}

# data "aws_iam_role" "eks_sa_role" {
#   name = "${var.eks_cluster_name}-sa-role"
# }

resource "aws_iam_policy_attachment" "k8-worker-policy-attachment" {
  name       = "k8-worker-policy-attachement"
  roles      = ["${aws_iam_role.eks_self_managed_node_group.name}"]
  policy_arn = "${aws_iam_policy.k8_worker_policy.arn}"
}