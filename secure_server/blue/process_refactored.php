<html>

<body>

<?php
    error_reporting(E_ALL);
    ini_set('display_errors','On');
    $myFile = "/tmp/request.log";
    $fh = fopen($myFile, 'a');

    fwrite($fh, "===================================\n");
    foreach ($_GET as $key => $value) {
        fwrite($fh, $key . " => " . $value . "\n");
    }

    $user = "nobody";
    $pass = "nope";
    $choice = "still no";
    $amount = 0;

    if(isset($_GET["user"]))
        $user = htmlentities($_GET["user"]);

    if(isset($_GET["pass"]))
        $pass = htmlentities($_GET["pass"]);

    if(isset($_GET["drop"]))
        $choice = htmlentities($_GET["drop"]);

    if(isset($_GET["amount"]))
        $amount = intval($_GET["amount"]);

    $mysqli = new mysqli('localhost', 'anon', 'thisisaverysecurepasswordbitch2020', 'ctf2');
    if (!$mysqli) {
        die('Could not connect: ' . $mysqli->error());
    }

    $url = "process.php?user=$user&pass=$pass&drop=balance";

    switch($choice){
        case "register":
            $stm = $mysqli->prepare("INSERT INTO users (user, pass) VALUES (?, ?)");
            $stm->bind_param("ss", $user, $pass);
            $stm->execute() or die(mysqli_error($mysqli));
            $result = $stm->get_result();
            die('<script type="text/javascript">window.location.href="' . $url . '"; </script>');
            break;

        case "balance":
            $row = checkAuth($mysqli, $user);
            if($row['pass'] != $pass){
                exit("Invalid authentication...");
            }else{
                $total = getUserBalance($mysqli, $user);

                print "<H1>Balance and transfer history for $user</H1><P>";
                print "<table border=1><tr><th>Action</th><th>Amount</th></tr>";

                $stm2 = $mysqli->prepare("SELECT * FROM transfers where user = ? LIMIT 10");
                $stm2->bind_param("s", $user);
                $stm2->execute() or die(mysqli_error($mysqli));
                $result = $stm2->get_result();

                while ($row = $result->fetch_array()) {
                    $amount = $row['amount'];
                    if ($amount < 0) {
                        $action = "Withdrawal";
                    } else {
                        $action = "Deposit";
                    }
                    print "<tr><td>" . $action . "</td><td>" . $amount . "</td></tr>";
                }
                print "<tr><td>Total</td><td>" . $total . "</td></tr></table>";
                print "Back to <A HREF='index.php'>home</A>";
            }
            break; 

        case "deposit":
            $row = checkAuth($mysqli, $user);
            if($row['pass'] != $pass){
                exit("Invalid authentication...");
            }else{
                if(gettype($amount) != "integer"){
                    exit("Need an integer for this operation...");
                }
                if($amount < 0){
                    exit("You cannot deposit a negative amount...");
                }
                if($amount === 0){
                    exit("The deposit cannot be 0");
                }
                ## Check for overflow...
                $stm = $mysqli->prepare("INSERT INTO transfers (user,amount) values (?, ?)");
                $stm->bind_param("si", $user, $amount);
                $stm->execute() or die(mysqli_error($mysqli));
                $result = $stm->get_result();

                die('<script type="text/javascript">window.location.href="' . $url . '"; </script>');
            }

            break;

        case "withdraw":
            $row = checkAuth($mysqli, $user);
            if($row['pass'] != $pass){
                exit("Invalid authentication...");
            }else{
                if(gettype($amount) != "integer"){
                    exit("Need an integer for this operation...");
                }
                if($amount < 0){
                    exit("You cannot withdraw a negative amount...");
                }

                $total = getUserBalance($mysqli, $user);
                if($total == 0){
                    exit("Impossible to make a withdrawal. No money currently in the account.");
                }
                if($total < $amount){
                    exit("Not enough money for withdrawal...");
                }

                $amount = $amount * -1;

                $stm = $mysqli->prepare("INSERT INTO transfers (user,amount) values (?, ?)"); //Check how to remove money
                $stm->bind_param("si", $user, $amount);
                $stm->execute() or die(mysqli_error($mysqli));
                $result = $stm->get_result();

                die('<script type="text/javascript">window.location.href="' . $url . '"; </script>');
            }
            break;

        default:
            exit("Nice you got to this page. Unfortunately there is nothing here lol. Try again!");
      
    }

    # Log data for scoring
    $query = "SELECT * FROM transfers";
    $result = $mysqli->query($query);
    fwrite($fh, "TRANSFERS\n");
    while ($row = $result->fetch_array()) {
        fwrite($fh, $row['user'] . " " . $row['amount'] . "\n");
    }
    
    $query = "SELECT * FROM users";
    $result = $mysqli->query($query);
    fwrite($fh, "USERS\n");
    while ($row = $result->fetch_array()) {
        fwrite($fh, $row['user'] . " " . $row['pass'] . "\n");
    }


    function checkAuth($mysqli, $user){
        $stm = $mysqli->prepare("SELECT pass FROM users WHERE user = ?");
        $stm->bind_param("s", $user);
        $stm->execute() or die(mysqli_error($mysqli));
        $result = $stm->get_result();
        $row = $result->fetch_array();

        return $row;
    }

    function getUserBalance($mysqli, $user){
        $stm = $mysqli->prepare("SELECT SUM(amount) AS total FROM transfers where user = ? ");
        $stm->bind_param("s", $user);
        $stm->execute() or die(mysqli_error($mysqli));
        $result = $stm->get_result();

        $row = $result->fetch_array();
        $total = $row['total'];  
        
        return $total;
    }

?>
</body>

</html>
