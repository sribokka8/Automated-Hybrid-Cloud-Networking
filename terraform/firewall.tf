# AWS Network Firewall to block SSH
resource "aws_networkfirewall_rule_group" "block_ssh" {
  name        = "block-ssh"
  capacity    = 100
  type        = "STATEFUL"
  rule_group {
    rules_source {
      stateful_rule {
        action = "DROP"
         header {
          destination      = "ANY"
          destination_port = "22"
          direction        = "ANY"
          protocol         = "TCP"
          source           = "0.0.0.0/0"
          source_port      = "ANY"
        }
        rule_option {
          keyword = "sid"
          settings = ["1"]
        }
      }
    }
  }
}


resource "aws_networkfirewall_firewall_policy" "firewall_policy" {
  name = "block-ssh-policy"
  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.block_ssh.arn
    }
  }
}