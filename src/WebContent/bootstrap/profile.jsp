<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>My Profile</title>
    <!-- Bootstrap Core CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="css/business-casual.css" rel="stylesheet">
    <!-- Fonts -->
    <link href="http://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,800italic,400,300,600,700,800" rel="stylesheet" type="text/css">
    <link href="http://fonts.googleapis.com/css?family=Josefin+Slab:100,300,400,600,700,100italic,300italic,400italic,600italic,700italic" rel="stylesheet" type="text/css">
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>
<body>
    <div class="brand">Welcome Student</div>
    <!-- Navigation -->
    <nav class="navbar navbar-default" role="navigation">
        <div class="container">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <!-- navbar-brand is hidden on larger screens, but visible when the menu is collapsed -->
                <a class="navbar-brand" href="index.html">Business Casual</a>
            </div>
            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav">
                    <li>
                        <a href="profile.jsp">Profile</a>
                    </li>
                    <li>
                        <a href="resources.jsp">Resources</a>
                    </li>
                    <li>
                        <a href="notifications.jsp">Notifications</a>
                    </li>
                    <li>
                        <a href="due_balances.jsp">Due Balance</a>
                    </li>
                    <li>
                        <a href="logout.jsp">Logout</a>
                    </li>
                </ul>
            </div>
            <!-- /.navbar-collapse -->
        </div>
        <!-- /.container -->
    </nav>



<!-- *******************************  Start Your Editing here ************************************ -->

    <div class="container">
 <div class="row">
            <div class="box">
                <div class="col-lg-12">
                    <hr>
                    <h2 class="intro-text text-center">User
                        <strong>Profile</strong>
                    </h2>
                    <hr>
                   
                    <form role="form" name="user_profile" action="Update_Profile" method="post">
                        <div class="row">
                            <div class="form-group col-lg-4">
                                <label>First Name</label>
                                <input type="text" class="form-control">
                        
                            <br>
                                <label>Last Name</label>
                                <input type="text" class="form-control">
                            <br>
                                <label>Date Of Birth</label>
                                <input type="date" class="form-control">
                            
                            <br>
                            	<label>Gender</label>
                                <select class="form-control">
                                <option value="">Select</option>
                                <option value="male">Male</option>
                                <option value="female">Female</option>
                                </select>
                            </div>
                            <div class="form-group col-lg-4">
                                <label>City</label>
                                <input type="text" class="form-control">
                            
                            <br>
                                <label>Street</label>
                                <input type="text" class="form-control">
                            <br>
                            
                                <label>Postcode</label>
                                <input type="text" class="form-control">
                            
                            <br>
                            
                                <label>Nationality</label>
                                <input type="text" class="form-control">
                            
                            <br>
                            </div>
                            <div class="form-group col-lg-4">
                                <label>Contact Number</label>
                                <input type="text" class="form-control">
                            
                            <br>
                            
                                <label>Alternate Contact</label>
                                <input type="text" class="form-control">
                            
                            <br>
                            
                                <label>Department</label>
                                <input type="text" class="form-control">
                            
                            <br>
                                <label>State</label>
                                <input type="text" class="form-control">
                            </div>
                            <br>
                       
               
                            <div class="form-group col-lg-12">
                                <input type="hidden" name="user_profile" value="update_details">
                                <button type="submit" class="btn btn-default">Update Profile</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

    </div>
    <!-- /.container -->

  	
<!-- ********************************** Edit upto this position ************************************* -->  	
  	
  	<footer>
        <div class="container">
            <div class="row">
                <div class="col-lg-12 text-center">
                    <p>Copyright &copy; NCSU Libraries 2015</p>
                </div>
            </div>
        </div>
    </footer>

    <!-- jQuery -->
    <script src="js/jquery.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="js/bootstrap.min.js"></script>

</body>

</html>
