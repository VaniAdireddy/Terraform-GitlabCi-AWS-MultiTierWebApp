Here's the updated version of the `README.md` with the requested module name changes:

---

# **Automated AWS Multi-Tier Web Application Architecture with Terraform and GitLab CI/CD**

---

## **Project Overview**

This project automates the provisioning of a **Multi-Tier Web Application Architecture** on AWS using **Terraform** for Infrastructure-as-Code (IaC) and **GitLab CI/CD** for seamless infrastructure deployment pipelines. 

The GitLab pipeline ensures infrastructure validation, planning, and deployment with manual approvals, adhering to best practices for controlled and automated cloud provisioning.

---

## **Architecture Details**

The infrastructure is divided into reusable Terraform modules to enhance modularity and scalability.

### **1. Network_VPC Module** 🌐  
Provision and manage the network resources:
   - **VPC** with 2 Public and 2 Private Subnets  
   - **Internet Gateway** and Route Table Associations  
   - **Security Groups**:
     - Load Balancer: Allows HTTP traffic on port 80.  
     - EC2: Allows inbound traffic from Load Balancer Security Group.  
     - RDS: Allows traffic from EC2 Security Group (port 3306).  
   - **Outputs**: VPC ID, Subnet IDs, Security Group IDs for cross-module usage.

---

### **2. WebServer Module** 💻  
Manages the compute resources and application deployment:
   - **EC2 Instances** with **Auto Scaling Group (ASG)** and Launch Templates.  
   - **Application Load Balancer (ALB)** to distribute HTTP traffic to EC2 instances.  
   - **User Data**:  
     - Leverages `app.sh` (base64-encoded) to configure and deploy the application on EC2 instances.  
   - **Outputs**: ASG Name, Security Group IDs, and ALB details.

---

### **3. Database Module** 🗄️  
Provisions the RDS database for application storage:
   - **RDS Instance**:  
     - Deployed in Private Subnets for enhanced security.  
     - Listens on **port 3306** (MySQL) with security group rules restricting access to EC2 instances.  
   - **Outputs**: Database Host, Username, Password, Port, and DB Identifier for use in the WebServer module.

---

### **4. Monitoring Module** 📊  
Integrates monitoring and alerting:
   - **CloudWatch Alarms**:  
     - Monitors **EC2 CPU utilization** and **RDS storage usage**.  
   - **SNS Notifications**:  
     - Configured to notify via email for critical CloudWatch alerts.

---

## **State Management**  
Terraform backend uses **S3 for remote state storage** and **DynamoDB for state locking** to ensure data consistency across deployments.

---

## **CI/CD Pipeline with GitLab** 🛠️  

The GitLab CI/CD pipeline automates the Terraform workflow using the following stages:

1. **Before Script**:  
   - Install required Terraform version.  
   - Run `terraform init` for module initialization.

2. **Pipeline Stages**:
   - **Terraform Validate**: Syntax and configuration validation.  
   - **Terraform Plan**: Review planned changes (no impact).  
   - **Terraform Apply** (Manual Approval): Deploy the infrastructure after approval.  
   - **Terraform Destroy** (Manual): Destroy resources when needed.

---

## **Deployment Steps** 🚀

### **Prerequisites**  
Ensure you have the following tools installed:  
   - Terraform  
   - GitLab account  
   - AWS CLI  
   - Git  

### **Clone the Repository**
```bash
git clone https://github.com/VaniAdireddy/Terraform-GitlabCi-AWS-MultiTierWebApp.git
cd Terraform-GitlabCi-AWS-MultiTierWebApp

```

### **Setup Environment Variables**
Export the following environment variables for secure authentication:
```bash
export AWS_ACCESS_KEY_ID=<your-aws-access-key>
export AWS_SECRET_ACCESS_KEY=<your-aws-secret-key>
```

### **Initialize Terraform**
```bash
terraform init
```

### **Validate the Configuration**
```bash
terraform validate
```

### **Plan the Infrastructure**
```bash
terraform plan
```

### **Deploy the Infrastructure**
```bash
terraform apply
```
*For GitLab Pipeline*: Push changes to the repository to trigger automated validation and deployment.

---

## **Key Features** 🔑

- **High Availability**:  
  - Multi-tier architecture using Auto Scaling Groups and RDS deployed in private subnets.

- **Modular Design**:  
  - Infrastructure is organized into reusable modules for **Network_VPC**, **WebServer**, **Database**, and **Monitoring**.

- **Security Best Practices**:  
  - Private Subnets for RDS, restricted Security Groups, and IAM roles.  

- **Monitoring Integration**:  
  - CloudWatch Alarms and SNS for proactive alerting.

- **CI/CD Integration**:  
  - GitLab CI/CD automates validation, planning, and provisioning.

---

## **Technologies Used** 🛠️  

- **Terraform**: Infrastructure-as-Code for AWS provisioning.  
- **AWS Services**:  
   - EC2, RDS, VPC, ASG, ALB, CloudWatch, SNS.  
- **GitLab CI/CD**: Automation for Terraform workflows.  
- **S3 & DynamoDB**: Remote state and locking for consistency.  

---

## **Challenges Faced** 🧩  
- **State Management**: Ensuring consistency using S3 and DynamoDB for locking state files.  
- **Networking**: Setting up secure private and public subnets while managing route table associations.  
- **Automation**: Implementing a controlled CI/CD pipeline with manual approvals for Terraform `apply` and `destroy`.  

---

## **Screenshots** 🖼️  

<img width="1440" alt="Screenshot 2024-12-17 at 5 42 15 PM" src="https://github.com/user-attachments/assets/3dbab1f5-1e75-48a7-9c97-a059f4ffc0fa" />
<img width="1438" alt="Screenshot 2024-12-17 at 5 59 47 PM" src="https://github.com/user-attachments/assets/8a214e19-4528-49ed-8ac9-c6c23d2cf150" />
<img width="1424" alt="Screenshot 2024-12-17 at 6 01 12 PM" src="https://github.com/user-attachments/assets/6ec06982-a022-401e-81bd-1e8cff72360a" />
<img width="1407" alt="Screenshot 2024-12-18 at 7 23 56 PM" src="https://github.com/user-attachments/assets/8d080a2e-7452-4911-a4a3-9d726a44e535" />
<img width="1430" alt="Screenshot 2024-12-17 at 6 05 10 PM" src="https://github.com/user-attachments/assets/696e7c20-9d26-4d1b-a764-61f8d02824b3" />
<img width="1432" alt="Screenshot 2024-12-17 at 6 06 14 PM" src="https://github.com/user-attachments/assets/d980d4ff-d493-4e80-9749-e7687b5c8a69" />
<img width="1169" alt="Screenshot 2024-12-17 at 6 07 26 PM" src="https://github.com/user-attachments/assets/08849676-8584-48c1-99ff-d4757a50cdcd" />
<img width="1164" alt="Screenshot 2024-12-17 at 6 07 35 PM" src="https://github.com/user-attachments/assets/918ba916-34e3-4ed1-85ef-b5198b168aad" />

---

## **How to Contribute** 🤝  
Feel free to fork the repository, submit issues, or raise pull requests to enhance this project.

---

## **Conclusion**  
This project demonstrates a fully automated, scalable, and secure AWS cloud infrastructure using Terraform and GitLab CI/CD pipelines, showcasing expertise in DevOps, Infrastructure-as-Code, and Cloud Automation.

