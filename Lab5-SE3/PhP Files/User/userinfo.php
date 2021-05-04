
<?php
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "USER";
    $table = "UserInfo";

    $action = $_POST['action'];

    $conn = new mysqli($servername, $username, $password, $dbname);
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
    if('GET_ALL' == $action){
        $dbdata = array();
        $sql = "SELECT* FROM $table";
        $result = $conn->query($sql);
       
        if ($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
                $dbdata[]=$row;
            }
            echo json_encode($dbdata);
        } else {
            echo "error";
        }
        $conn->close();
        return;
    }
    if('ADD_USER' == $action){
        $username = $_POST['Username'];
        $password = $_POST['Password'];
        $email= $_POST['Email'];
        $sql = "INSERT INTO $table (Username, Password, Email) VALUES('$username', '$password','$email')";
        $result = $conn->query($sql);
        echo 'success';
        return;
    }
    if('GET_EMAIL' == $action){
        $dbdata = array();
        $username = $_POST['Username'];
        $sql = "SELECT Email FROM $table WHERE Username = '$username'";
        $result = $conn->query($sql);
        if ($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
                $dbdata[]=$row;
            }
            echo json_encode($dbdata);
        } else {
            echo "error";
        }
        return;
    }
    if('GET_POSTAL' == $action){
        $dbdata = array();
        $username = $_POST['Username'];
        $sql = "SELECT PostalCode FROM $table WHERE Username = '$username'";
        $result = $conn->query($sql);
        if ($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
                $dbdata[]=$row;
            }
            echo json_encode($dbdata);
        } else {
            echo "error";
        }
        return;
    }
    if('UPDATE_PASSWORD' == $action){
        $username = $_POST['Username'];
        $password = $_POST['Password'];
        $sql = "UPDATE $table SET Password = '$password' WHERE Username = '$username'";
        echo "$username";
        if ($conn->query($sql) === TRUE) {
            echo "success";
        } else {
            echo "error";
        }
        $conn->close();
        return;
    }
    if('UPDATE_EMAIL' == $action){
        $username = $_POST['Username'];
        $email = $_POST['Email'];
        $sql = "UPDATE $table SET Email = '$email' WHERE Username = '$username'";
        if ($conn->query($sql) === TRUE) {
            echo "success";
        } else {
            echo "error";
        }
        $conn->close();
        return;
    }
    if('UPDATE_POSTAL_CODE' == $action){
        $username = $_POST['Username'];
        $postal = $_POST['PostalCode'];
        $sql = "UPDATE $table SET PostalCode = '$postal' WHERE Username = '$username'";
        if ($conn->query($sql) === TRUE) {
            echo "success";
        } else {
            echo "error";
        }
        $conn->close();
        return;
    }
    if('UPDATE_UNITS' == $action){
        $username = $_POST['Username'];
        $units = $_POST['Units'];
        $sql = "UPDATE $table SET Units = '$units' WHERE Username = '$username'";
        if ($conn->query($sql) === TRUE) {
            echo "success";
        } else {
            echo "error";
        }
        $conn->close();
        return;
    }
    if('DELETE_USER' == $action){
        $username = $_POST['Username'];
        $sql = "DELETE FROM $table WHERE Username = '$username'";
        $result=$conn->query($sql);
        if ($conn->query($sql) === TRUE) {
            echo "success";
        } else {
            echo "error";
        }
        $conn->close();
        return;
    }
    
?>
