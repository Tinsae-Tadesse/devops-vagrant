<?php
require_once(__DIR__ . '/db-connect.php');

// Validate form inputs
$name = trim($_POST['name'] ?? '');
$email = trim($_POST['email'] ?? '');
$subject = trim($_POST['subject'] ?? '');
$message = trim($_POST['message'] ?? '');

if (!$name || !$email || !$subject || !$message) {
    die("All fields are required.");
}

// Use prepared statement to prevent SQL injection
$stmt = $conn->prepare("INSERT INTO contact_messages (name, email, subject, message) VALUES (?, ?, ?, ?)");
$stmt->bind_param("ssss", $name, $email, $subject, $message);

if ($stmt->execute()) {
    echo "Thank you for your message!";
} else {
    echo "Error: " . $stmt->error;
}

$stmt->close();
$conn->close();
?>

