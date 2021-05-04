<?php
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "COMMENTS";
    $table = "Comments";

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
    if('GET_COMMENT_SCHOOL' == $action){
        $dbdata = array();
        $schoolName = $_POST['SchoolName'];
        $sql = "SELECT* FROM $table WHERE SchoolName = '$schoolName'";
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
    if('ADD_COMMENT' == $action){
        $username = $_POST['Username'];
        $schoolName = $_POST['SchoolName'];
        $rating = $_POST['Rating'];
        $message= $_POST['Message'];
        $sql = "INSERT INTO $table (Username, SchoolName, Rating, Message) VALUES('$username', '$schoolName','$rating', '$message')";
        $result = $conn->query($sql);
        echo 'success';
        return;
    }
    if('GET_AVG_RATING' == $action){
        $dbdata = array();
        $schoolName = $_POST['SchoolName'];
        $sql = "SELECT AVG(Rating) FROM $table WHERE SchoolName = '$schoolName'";
        $result = $conn->query($sql);
        if ($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
                $dbdata[]=$row;
            }
            echo json_encode($dbdata[0]);
        } else {
            echo "error";
        }
        return;
    }
    if('GET_NO_5' == $action){
        $schoolName = $_POST['SchoolName'];
        $sql = "SELECT COUNT(Rating) FROM $table WHERE SchoolName = '$schoolName' AND Rating=5";
        $result = $conn->query($sql);
        echo 'success';
        return;
    }
    if('GET_NO_4' == $action){
        $schoolName = $_POST['SchoolName'];
        $sql = "SELECT COUNT(Rating) FROM $table WHERE SchoolName = '$schoolName' AND Rating=4";
        $result = $conn->query($sql);
        echo 'success';
        return;
    }
    if('GET_NO_3' == $action){
        $schoolName = $_POST['SchoolName'];
        $sql = "SELECT COUNT(Rating) FROM $table WHERE SchoolName = '$schoolName' AND Rating=3";
        $result = $conn->query($sql);
        echo 'success';
        return;
    }
    if('GET_NO_2' == $action){
        $schoolName = $_POST['SchoolName'];
        $sql = "SELECT COUNT(Rating) FROM $table WHERE SchoolName = '$schoolName' AND Rating=2";
        $result = $conn->query($sql);
        echo 'success';
        return;
    }
    if('GET_NO_1' == $action){
        $schoolName = $_POST['SchoolName'];
        $sql = "SELECT COUNT(Rating) FROM $table WHERE SchoolName = '$schoolName' AND Rating=1";
        $result = $conn->query($sql);
        echo 'success';
        return;
    }
?>
