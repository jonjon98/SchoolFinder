<?php
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "REPORTS";
    $table = "Reports";

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
    if('ADD_REPORT' == $action){
        $username = $_POST['Username'];
        $message = $_POST['Message'];
        $sql = "INSERT INTO $table (Username, Message) VALUES('$username', '$message')";
        $result = $conn->query($sql);
        echo 'success';
        return;
    }


    
?>
