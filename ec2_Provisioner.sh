#!/bin/bash
set -euo pipefail

check_awscli() {
    if ! command -v aws &> /dev/null; then
        echo "AWS CLI is not installed." >&2
        return 1
    fi
}

install_awscli() {
    echo "Installing AWS CLI v2 on Debian-based system..."
    
    # Update package list and install dependencies
    sudo apt-get update && sudo apt-get install -y curl unzip

    # Download and install AWS CLI v2
    curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -q awscliv2.zip
    sudo ./aws/install

    # Verify installation
    if ! aws --version &> /dev/null; then
        echo "AWS CLI installation failed." >&2
        exit 1
    fi

    # Clean up
    rm -rf awscliv2.zip ./aws
}

wait_for_instance() {
    local instance_id="$1"
    echo "Waiting for instance $instance_id to be in running state..."

    while true; do
        state=$(aws ec2 describe-instances --instance-ids "$instance_id" \
            --query 'Reservations[0].Instances[0].State.Name' --output text)
        if [[ "$state" == "running" ]]; then
            echo "Instance $instance_id is now running."
            break
        fi
        sleep 10
    done
}

get_instance_public_ip() {
    local instance_id="$1"
    echo "Retrieving public IP address..."
    public_ip=$(aws ec2 describe-instances --instance-ids "$instance_id" \
        --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
    echo "Public IP address: $public_ip"
}

validate_parameters() {
    if [[ -z "$AMI_ID" ]]; then
        echo "Error: AMI_ID must be set." >&2
        exit 1
    fi
    if [[ -z "$KEY_NAME" ]]; then
        echo "Error: KEY_NAME must be set." >&2
        exit 1
    fi
    if [[ -z "$SUBNET_ID" ]]; then
        echo "Error: SUBNET_ID must be set." >&2
        exit 1
    fi
    if [[ -z "$SECURITY_GROUP_IDS" ]]; then
        echo "Error: SECURITY_GROUP_IDS must be set." >&2
        exit 1
    fi
}

create_ec2_instance() {
    local ami_id="$1"
    local instance_type="$2"
    local key_name="$3"
    local subnet_id="$4"
    local security_group_ids="$5"
    local instance_name="$6"

    echo "Creating EC2 instance with parameters:"
    echo "AMI: $ami_id"
    echo "Type: $instance_type"
    echo "Key Pair: $key_name"
    echo "Subnet: $subnet_id"
    echo "Security Groups: $security_group_ids"
    echo "Name: $instance_name"

    instance_id=$(aws ec2 run-instances \
        --image-id "$ami_id" \
        --instance-type "$instance_type" \
        --key-name "$key_name" \
        --subnet-id "$subnet_id" \
        --security-group-ids $security_group_ids \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance_name}]" \
        --query 'Instances[0].InstanceId' \
        --output text
    )

    if [[ -z "$instance_id" ]]; then
        echo "Failed to create EC2 instance." >&2
        exit 1
    fi

    echo "Instance $instance_id created successfully."
    wait_for_instance "$instance_id"
    get_instance_public_ip "$instance_id"
}

main() {
    # Check for AWS CLI or install it
    check_awscli || install_awscli

    # Configuration parameters - fill these in before running
    AMI_ID="ami-0c55b159cbfafe1f0"  # Example Amazon Linux 2 AMI (replace with your AMI)
    INSTANCE_TYPE="t2.micro"
    KEY_NAME="your-key-pair-name"   # Replace with your key pair name
    SUBNET_ID="subnet-12345678"     # Replace with your subnet ID
    SECURITY_GROUP_IDS="sg-12345678 sg-87654321"  # Replace with your security group IDs
    INSTANCE_NAME="Shell-Script-EC2-Demo"

    # Validate all parameters are set
    validate_parameters

    # Create EC2 instance
    create_ec2_instance "$AMI_ID" "$INSTANCE_TYPE" "$KEY_NAME" "$SUBNET_ID" "$SECURITY_GROUP_IDS" "$INSTANCE_NAME"

    echo "EC2 instance creation completed."
}

main "$@"
