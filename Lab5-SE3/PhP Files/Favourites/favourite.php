<?php
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "FAVOURITES";
    $table = "Favourites";

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
    if('GET_FAVOURITES_USER' == $action){
        $dbdata = array();
        $username = $_POST['Username'];
        $sql = "SELECT* FROM $table WHERE Username = '$username' ";
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
    if('ADD_FAVOURITES' == $action){
        $username = $_POST['Username'];
        $schoolName = $_POST['SchoolName'];
        $sql = "INSERT INTO $table (Username, SchoolName) VALUES('$username', '$schoolName')";
        $result = $conn->query($sql);
        echo 'success';
        return;
    }

    if('DELETE_FAV' == $action){
        $username = $_POST['Username'];
        $schoolName = $_POST['SchoolName'];
        $sql = "DELETE FROM $table WHERE SchoolName = '$schoolName' AND Username = '$username'";
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