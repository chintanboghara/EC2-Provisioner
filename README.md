# EC2 Provisioner Shell Script

This script automates the creation of an Amazon EC2 instance using the AWS CLI. It handles AWS CLI installation, instance creation, and provides the instance's public IP upon completion.

## Features

- Checks for and installs AWS CLI v2 on Debian-based systems
- Validates required parameters before execution
- Creates an EC2 instance with specified configurations
- Waits for the instance to reach the "running" state
- Retrieves and displays the public IP address of the instance

## Prerequisites

- An AWS account with appropriate IAM permissions
- An existing AWS key pair for SSH access
- Security groups configured to allow necessary traffic (e.g., SSH)
- Debian-based Linux system (for AWS CLI installation via apt)

## Installation

1. **Clone the repository** or download the script
2. **Make the script executable**:
   ```bash
   chmod +x ec2_Provisioner.sh
   ```
3. **Configure AWS credentials** using:
   ```bash
   aws configure
   ```

## Configuration

Edit the following variables in the script before running:

| Variable               | Description                                                                 |
|------------------------|-----------------------------------------------------------------------------|
| `AMI_ID`               | Amazon Machine Image ID (e.g., Amazon Linux 2 AMI)                         |
| `INSTANCE_TYPE`        | EC2 instance type (default: t2.micro)                                      |
| `KEY_NAME`             | Name of your existing EC2 key pair                                         |
| `SUBNET_ID`            | VPC Subnet ID where the instance will launch                               |
| `SECURITY_GROUP_IDS`   | Space-separated list of security group IDs                                 |
| `INSTANCE_NAME`        | Name tag for the EC2 instance                                              |

**Note**: Replace all placeholder values (e.g., `your-key-pair-name`, `subnet-12345678`) with your actual AWS resource identifiers.

## Usage

Run the script with:
```bash
./ec2_Provisioner.sh
```

**Example Output**:
```
Creating EC2 instance with parameters:
AMI: ami-0c55b159cbfafe1f0
...
Instance i-1234567890abcdef created successfully.
Public IP address: 203.0.113.45
```

## Security Considerations

- Always protect your AWS credentials
- Ensure security groups only allow necessary inbound traffic
- Delete test instances when no longer needed

## Troubleshooting

- **"Invalid AMI ID"**: Verify the AMI exists in your region
- **"UnauthorizedOperation"**: Check IAM permissions for EC2 resource creation
- **AWS CLI installation issues**: Ensure you have `curl` and `unzip` installed
- **Instance creation failure**: Verify subnet and security group IDs are correct

## Cleanup

Delete the created instance through:
1. AWS Console → EC2 → Instances
2. Select instance → Instance state → Terminate
