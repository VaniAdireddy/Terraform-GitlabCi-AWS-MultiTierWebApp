#!/bin/bash

# Update the system and install necessary software
sudo su root
dnf update -y
dnf install -y httpd php php-mysqli mariadb105

# Start Apache and enable it on boot
systemctl start httpd
systemctl enable httpd

# Set correct permissions for the web directory
sudo chmod -R 755 /var/www/html

# Create dbinfo.inc with database connection info
mkdir -p /var/www/html/inc
cat > /var/www/html/inc/dbinfo.inc << EOL
<?php
define('DB_SERVER', '${DB_HOST}');
define('DB_USERNAME', '${DB_USER}');
define('DB_PASSWORD', '${DB_PASSWORD_PARAM}');
define('DB_DATABASE', '${DB_NAME}');
?>
EOL

# Create the web application page
cat > /var/www/html/index.php << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Management System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
        }
        header {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            text-align: center;
        }
        main {
            max-width: 800px;
            margin: 20px auto;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        form {
            margin-bottom: 20px;
            padding: 15px;
            background-color: #eaf7ea;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }
        label {
            font-weight: bold;
        }
        input[type="text"], button {
            margin: 5px 0;
            padding: 10px;
            width: calc(100% - 20px);
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        button {
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
        }
        button:hover {
            background-color: #45a049;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
    </style>
</head>
<body>
    <header>
        <h1>Employee Management System</h1>
    </header>
    <main>
        <h2>Add New Employee</h2>
        <form method="POST" action="index.php">
            <label for="name">Name:</label>
            <input type="text" id="name" name="name" required>
            <label for="address">Address:</label>
            <input type="text" id="address" name="address" required>
            <button type="submit">Add Employee</button>
        </form>
        
        <h2>Employee Directory</h2>
        <table>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Address</th>
            </tr>
            <?php
            // Include database info
            include "inc/dbinfo.inc";

            // Enable error reporting
            ini_set('display_errors', 1);
            error_reporting(E_ALL);

            // Connect to the MySQL database
            $connection = mysqli_connect(DB_SERVER, DB_USERNAME, DB_PASSWORD);
            if (mysqli_connect_errno()) {
                echo "<tr><td colspan='3'>Failed to connect to MySQL: " . mysqli_connect_error() . "</td></tr>";
                exit();
            }

            // Select the database
            $database = mysqli_select_db($connection, DB_DATABASE);
            if (!$database) {
                echo "<tr><td colspan='3'>Error selecting database.</td></tr>";
                exit();
            }

            // Ensure EMPLOYEES table exists
            VerifyEmployeesTable($connection, DB_DATABASE);

            // Add employee to database
            if ($_SERVER["REQUEST_METHOD"] == "POST") {
                $name = mysqli_real_escape_string($connection, $_POST['name']);
                $address = mysqli_real_escape_string($connection, $_POST['address']);
                if (!empty($name) && !empty($address)) {
                    AddEmployee($connection, $name, $address);
                }
            }

            // Retrieve and display employees
            $result = mysqli_query($connection, "SELECT * FROM EMPLOYEES");
            while ($row = mysqli_fetch_assoc($result)) {
                echo "<tr><td>" . $row['ID'] . "</td><td>" . $row['NAME'] . "</td><td>" . $row['ADDRESS'] . "</td></tr>";
            }

            // Clean up
            mysqli_free_result($result);
            mysqli_close($connection);

            // Create EMPLOYEES table if it doesn't exist
            function VerifyEmployeesTable($connection, $dbName) {
                $query = "CREATE TABLE IF NOT EXISTS EMPLOYEES (
                    ID INT AUTO_INCREMENT PRIMARY KEY,
                    NAME VARCHAR(100) NOT NULL,
                    ADDRESS VARCHAR(255) NOT NULL
                )";
                if (!mysqli_query($connection, $query)) {
                    echo "<tr><td colspan='3'>Error creating table: " . mysqli_error($connection) . "</td></tr>";
                }
            }

            // Add a new employee
            function AddEmployee($connection, $name, $address) {
                $query = "INSERT INTO EMPLOYEES (NAME, ADDRESS) VALUES ('$name', '$address')";
                if (!mysqli_query($connection, $query)) {
                    echo "<tr><td colspan='3'>Error adding employee: " . mysqli_error($connection) . "</td></tr>";
                }
            }
            ?>
        </table>
    </main>
</body>
</html>
EOF

echo "Application setup completed successfully!!"