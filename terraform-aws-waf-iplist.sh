#!/usr/bin/env bash

# This script will generate a Terraform AWS WAF IPSet, WAF Rule, and WAF Web ACL resource blocks
# in a single Terraform file from a list of IPv4 IPs in a file called iplist.
# This can be used to easily whitelist IPs in an AWS WAF Web ACL.

# Requires wget, perl

# Set Variables
FriendlyName="Allow From IP List"


# Do not modify these variables!
TerraformResourceName=$(echo "$FriendlyName" | tr '[:upper:]' '[:lower:]' | tr -s ' ' '_' | tr -s '.' '_')
MetricName=$(echo "$FriendlyName" | sed 's/[^a-z  A-Z]//g' | tr -d '[:space:]')
OutputFileName="aws_waf_$TerraformResourceName.tf"

# Debug Mode
DEBUGMODE="0"


# Functions


# Pause
function pause(){
	read -n 1 -s -p "Press any key to continue..."
	echo
}

# Check Command
function check_command(){
	for command in "$@"
	do
	    type -P $command &>/dev/null || fail "Unable to find $command, please install it and run this script again."
	done
}

# Completed
function completed(){
	echo
	HorizontalRule
	tput setaf 2; echo "Completed!" && tput sgr0
	tput setaf 2; echo "$1" && tput sgr0
	HorizontalRule
	echo
}

# Fail
function fail(){
	tput setaf 1; echo "Error: $*" && tput sgr0
	exit 1
}

# Horizontal Rule
function HorizontalRule(){
	echo "============================================================"
}

# Get Pingdom IPv4 IPs
# https://help.pingdom.com/hc/en-us/articles/203682601-How-to-get-all-Pingdom-probes-public-IP-addresses
function IPs(){
	if [[ $DEBUGMODE = "1" ]]; then
		echo "function IPs"
	fi
	cat iplist | sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 | uniq > iplisttemp

	TOTALIPS=$(cat iplisttemp | wc -l | tr -d ' ')

	if ! [ "$TOTALIPS" -gt "0" ]; then
		fail "Unable to get list of IPs."
	fi
	echo
	HorizontalRule
	echo "Total IPs: "$TOTALIPS
	HorizontalRule
	echo
}

# Build the Terraform resource blocks
function buildTF(){
	if [[ $DEBUGMODE = "1" ]]; then
		echo "function buildTF"
	fi
	echo
	HorizontalRule
	echo "Building Terraform Resources..."
	HorizontalRule
	echo
	(
	cat << EOP
resource "aws_waf_ipset" "$TerraformResourceName" {
  name = "$FriendlyName"

  ip_set_descriptors = [
EOP
	) > temp1
	if [[ $DEBUGMODE = "1" ]]; then
		echo built temp1
	fi
	rm -f temp2

	START=1
	for (( COUNT=$START; COUNT<=$TOTALIPS; COUNT++ ))
	do
	iplist=$(nl iplisttemp | grep -w [^0-9][[:space:]]$COUNT | cut -f 2)
	(
	cat << EOP
      { type = "IPV4", value = "$iplist/32" },
EOP
	) >> temp2
	done

	if [[ $DEBUGMODE = "1" ]]; then
		echo built temp2
	fi

	# Remove the last comma to close JSON array
	cat temp2 | sed '$ s/.$//' > temp3
	if [[ $DEBUGMODE = "1" ]]; then
		echo built temp3
	fi

	(
	cat << 'EOP'
    ]
}

EOP
	) > temp4

	if [[ $DEBUGMODE = "1" ]]; then
		echo built temp4
	fi
	rm -f temp5

	(
	cat << EOP
resource "aws_waf_rule" "$TerraformResourceName" {
  depends_on  = ["aws_waf_ipset.$TerraformResourceName"]
  name        = "$FriendlyName"
  metric_name = "$MetricName"

  predicates {
    data_id = "\${aws_waf_ipset.$TerraformResourceName.id}"
    negated = false
    type    = "IPMatch"
  }
}

resource "aws_waf_web_acl" "$TerraformResourceName" {
  depends_on  = ["aws_waf_ipset.$TerraformResourceName", "aws_waf_rule.$TerraformResourceName"]
  name        = "$FriendlyName"
  metric_name = "$MetricName"

  default_action {
    type = "BLOCK"
  }

  rules {
    action {
      type = "ALLOW"
    }

    priority = 1
    rule_id  = "\${aws_waf_rule.$TerraformResourceName.id}"
    type     = "REGULAR"
  }
}
EOP
	) >> temp5

	if [[ $DEBUGMODE = "1" ]]; then
		echo built temp5
	fi

	cat temp1 temp3 temp4 temp5 > "$OutputFileName"
	if [[ $DEBUGMODE = "1" ]]; then
		echo "built $OutputFileName"
	fi

}

# Run the script and call functions

# Check for required applications
check_command wget perl

IPs

buildTF

# Cleanup temp files
if ! [[ $DEBUGMODE = "1" ]]; then
	rm -f temp1 temp2 temp3 temp4 temp5 iplisttemp
fi

completed "Terraform WAF Resource file: $OutputFileName"
