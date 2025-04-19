# EC2 Provisioner Shell Script

This script automates the creation of an Amazon EC2 instance using the AWS CLI. It is designed for quick setup of development or testing environments by handling AWS CLI installation, instance creation, and providing the instance's public IP upon completion.

## Features

- Automatically installs AWS CLI v2 if not already present on Debian-based systems.
- Ensures all necessary parameters are provided before proceeding.
- Creates an EC2 instance with user-specified configurations.
- Waits for the instance to reach the "running" state.
- Retrieves and displays the public IP address of the instance.

## Prerequisites

Before running the script, ensure you have the following:

- An AWS account with appropriate IAM permissions to create and manage EC2 instances.
- An existing AWS key pair for SSH access. (Create one in the AWS Console under EC2 → Key Pairs if needed.)
- Security groups configured to allow necessary traffic (e.g., SSH on port 22).
- A Debian-based Linux system (e.g., Ubuntu) for AWS CLI installation via `apt`. (The script may require modifications for other distributions.)

## Installation

1. **Clone the repository** or download the script to your local machine.
2. **Make the script executable**:
   ```bash
   chmod +x ec2_Provisioner.sh
   ```
3. **Configure AWS credentials**:
   - Run `aws configure` and provide your AWS Access Key, Secret Key, region, and output format when prompted.
   - Ensure you have your AWS credentials ready. Never hardcode or share them.

## Configuration

Before running the script, edit the following variables inside the script to match your AWS environment:

| Variable               | Description                                                                 | Example                                    |
|------------------------|-----------------------------------------------------------------------------|--------------------------------------------|
| `AMI_ID`               | Amazon Machine Image ID (must exist in your region)                         | `ami-0c55b159cbfafe1f0` (Amazon Linux 2 in us-east-1) |
| `INSTANCE_TYPE`        | EC2 instance type (default: t2.micro)                                       | `t2.micro`                                 |
| `KEY_NAME`             | Name of your existing EC2 key pair                                          | `my-key-pair`                              |
| `SUBNET_ID`            | VPC Subnet ID where the instance will launch                                | `subnet-12345678`                          |
| `SECURITY_GROUP_IDS`   | Space-separated list of security group IDs (can be a single ID)             | `sg-12345678 sg-87654321` or `sg-12345678` |
| `INSTANCE_NAME`        | Name tag for the EC2 instance                                               | `MyTestInstance`                           |

**Important**: Replace all placeholder values in the script with your actual AWS resource identifiers. You can find these in the AWS Console:
- **AMI ID**: EC2 → AMIs
- **Subnet ID**: VPC → Subnets
- **Security Group IDs**: EC2 → Security Groups
- **Key Pair Name**: EC2 → Key Pairs

## Usage

Run the script from the directory where it is located:

```bash
./ec2_Provisioner.sh
```

If the script is not in your current directory, provide the full path:

```bash
/path/to/ec2_Provisioner.sh
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

- **Protect your AWS credentials**: Never hardcode them in scripts or share them with others.
- **Configure security groups carefully**: Only allow necessary inbound traffic (e.g., SSH from trusted IP addresses).
- **Terminate instances when no longer needed**: This helps avoid unnecessary costs and keeps your environment secure.

## Troubleshooting

- **"Invalid AMI ID"**: Ensure the AMI exists in your selected region.
- **"UnauthorizedOperation"**: Verify your IAM permissions allow EC2 instance creation.
- **AWS CLI installation issues**: Ensure `curl` and `unzip` are installed on your system.
- **Instance creation failure**: Double-check that your subnet and security group IDs are correct.
- **"Instance limit exceeded"**: Check your AWS account's instance limits and request an increase if necessary.

## Cleanup

To avoid ongoing charges, terminate the instance when it is no longer needed:

1. Go to the AWS Console → EC2 → Instances.
2. Select the instance you created.
3. Choose **Instance state** → **Terminate instance**.
