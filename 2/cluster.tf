#
#   EKS Cluster
#

resource "aws_eks_cluster" "eks_test" {
  name     = "eksclustertest"
  role_arn = aws_iam_role.eks_test_role.arn

  vpc_config {
    subnet_ids = ["subnet-0591c2d8bcb8b1835", 	"subnet-0a121e0a92a299939"]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks_test_role-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_test_role-AmazonEKSVPCResourceController,
  ]
}
/*
output "endpoint" {
  value = aws_eks_cluster.eks_test.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks_test.certificate_authority[0].data
}
*/


#
# IAM ROLE for EKS cluster
#

resource "aws_iam_role" "eks_test_role" {
  name = "eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_test_role-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_test_role.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "eks_test_role-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_test_role.name
}

#
#  Enabling IAM Roles for Service Accounts
#

data "tls_certificate" "eks_tls" {
  url = aws_eks_cluster.eks_test.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eksopidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_tls.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks_test.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "eksdoc_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eksopidc.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eksopidc.arn]
      type        = "Federated"
    }
  }
}
