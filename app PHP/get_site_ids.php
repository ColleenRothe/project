 <?php 
 		 //modified from usmp/client/maintenance_form.php
          include('./constants.php');
          // Create connection
          $conn = new mysqli($servername, $username, $password, $dbname); //note: these variables are stored in ../constants.php
          // Check connection
          if ($conn->connect_error) {
              die("Connection failed: " . $conn->connect_error);
          } 
          $sql = "SELECT distinct SITE_ID FROM SITE_INFORMATION";
          $result = $conn->query($sql);
          $conn->close(); 

		  $temp = array();
          
          //echo '<option value="0">--</option>';
          if ($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
            	array_push($temp, $row['SITE_ID']);
            
            }
          }
          sort($temp);
          $data = array($temp);
          
          echo json_encode($data);
?>


<!-- 
 <?php 
 		 //modified from usmp/client/maintenance_form.php
          include('./constants.php');
          // Create connection
          $conn = new mysqli($servername, $username, $password, $dbname); //note: these variables are stored in ../constants.php
          // Check connection
          if ($conn->connect_error) {
              die("Connection failed: " . $conn->connect_error);
          } 
          $sql = "SELECT distinct SITE_ID FROM SITE_INFORMATION";
          $result = $conn->query($sql);
          
          echo '<option value="0">~~</option>';
          if ($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
               echo '<option value="'.$row['SITE_ID'].'">'.$row['SITE_ID'].'</option>';
            }
          }
          $conn->close(); 
?>
 -->

