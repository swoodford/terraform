<h1 align="center"><img src="/images/terraform.png" alt="Terraform" width=214 height=60></h1>

<h2 align="center">A collection of bash shell scripts for automating various tasks with <a href="https://www.terraform.io/" target="_blank">Terraform</a>.</h2>

[![Build Status](https://travis-ci.org/swoodford/terraform.svg?branch=master)](https://travis-ci.org/swoodford/terraform)

#### [https://github.com/swoodford/terraform](https://github.com/swoodford/terraform)

## Table of contents

- [Getting Started](#getting-started)
- [What's Included](#tools-included-in-this-repo)
- [Bugs and Feature Requests](#bugs-and-feature-requests)
- [Creator](#creator)
- [Copyright and License](#copyright-and-license)

## Getting Started

### What is Terraform?

Terraform is an open source tool for infrastructure as code that enables you to safely and predictably create, change, and improve infrastructure.

[Installing Terraform](https://www.terraform.io/intro/getting-started/install.html)


## Tools included in this repo:

- **[terraform-aws-waf-iplist.sh](terraform-aws-waf-iplist.sh)** Generate a Terraform AWS WAF IPSet, WAF Rule, and WAF Web ACL resource blocks for IPs in file iplist
- **[terraform-aws-waf-pingdom.sh](terraform-aws-waf-pingdom.sh)** Generate a Terraform AWS WAF IPSet, WAF Rule, and WAF Web ACL resource blocks for Pingdom probe server IPs
- **[terraform-redact-iam-secrets.sh](terraform-redact-iam-secrets.sh)** Replaces AWS IAM Secret Keys and IAM SES SMTP Passwords with "REDACTED" in Terraform state files

## Bugs and feature requests
Have a bug or a feature request? The [issue tracker](https://github.com/swoodford/terraform/issues) is the preferred channel for bug reports, feature requests and submitting pull requests.
If your problem or idea is not addressed yet, [please open a new issue](https://github.com/swoodford/terraform/issues/new).

## Creator

**Shawn Woodford**

- <https://shawnwoodford.com>
- <https://github.com/swoodford>

## Copyright and License

Code and Documentation Copyright 2012-2018 Shawn Woodford. Code released under the [Apache License 2.0](https://github.com/swoodford/terraform/blob/master/LICENSE).
