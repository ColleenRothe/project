<?php
    require_once("./constants.php");
    
    $usr = $_POST['email'];
    $pwd = $_POST['password'];
    
   
        /*** if we are here the data is valid and we can insert it into database ***/
        $usr = filter_var($usr, FILTER_SANITIZE_STRING);
        $pwd = filter_var($pwd, FILTER_SANITIZE_STRING);
        
        /*** now we can encrypt the password ***/
        $pwd = md5( $pwd );
        
    
        try
        {
            $conn = new mysqli($servername, $username, $password, $dbname);
            
            $query = "SELECT EMAIL, PASSWORD, PERMISSIONS FROM USERS WHERE EMAIL = '$usr' AND PASSWORD = '$pwd'";
            
            
            $result = $conn->query($query);
            if(!$result || $result->num_rows <= 0)
            {
                echo "didn't work";
                $result->close();
                $conn->close();
            } //end if
            else
            {
                #echo "worked";
                $row = $result->fetch_assoc();
                #echo "permission check";
                #echo $row['PERMISSIONS'];
                $data = $row['PERMISSIONS'];
                
                echo json_encode($data);
                
                $result->close();
                $conn->close();
                
            } //end else
            
            
        } //end try
        catch(Exception $e)
        {
            echo "exception";
        }
    
    
    ?>
