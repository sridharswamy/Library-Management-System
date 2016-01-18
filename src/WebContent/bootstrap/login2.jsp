<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>LOGIN PAGE</title>

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

    <div class="brand">LIBRARY MANAGEMENT SYSTEM</div>

    <!-- Navigation -->
    <nav class="navbar navbar-default" role="navigation">
        <div class="container">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <!--<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>-->
                <!-- navbar-brand is hidden on larger screens, but visible when the menu is collapsed -->
                <!--  <a class="navbar-brand" href="index.html">Business Casual</a>-->
            </div>
            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav">
                  
                    <li>
                        <a href="login2.jsp">Login</a>
                    </li>              
                </ul>
            </div>
            
            <!-- /.navbar-collapse -->
        </div>
        
        <!-- /.container -->
    </nav>

    <div class="container">

        <div class="row">
            <div class="box">
            
            <table border="0" width="100%">
            <tr>
            <td>
            
              <!-- Student Login -->
                <div class="col-lg-12">
                    <hr>
                    <h2 class="intro-text text-center">Student
                        <strong>Login</strong>
                    </h2>
                    <hr>
                                               
                 <div>  
          
                <form action="../Student_Login_Servlet" method="post">
                        <div class="row">
                        
                        <center><table>
                            <tr>
                            <td><div class="form-group col-lg-4">
                            <label>Username</label>
                            <input type="text" class="form-control" name="username" style="width: 300px;">
                            </div></td>
                            </tr>
                            
                            <tr>
                            <td><div class="form-group col-lg-4">
                                <label>Password</label>
                                <input type="password" class="form-control" name="userpass" style="width: 300px;">
                            </div></td>
                             </tr>
                             
                             <tr>                           
                            <td><div class="form-group col-lg-12">                                
                                <center><input type="submit" name="submit1" class="btn btn-default" value="Login"></center>
                            </div></td>
                            </tr>
                            </table></center>
                        </div>
                    </form>                
               </div>
                                    
                              
                
                </div>
    <!----------- Student Login Ends -------------->
    
              
              
              
    <!----------- Faculty Login Starts ------------> 
              
                
                    <div class="col-lg-12">
                    <hr>
                    <h2 class="intro-text text-center">Faculty
                        <strong>Login</strong>
                    </h2>
                    <hr>
                                               
                    
                <form role="form" action="../Faculty_Login_Servlet" method="post">
                        <div class="row">
                        
                        <center><table>
                            <tr>
                            <td><div class="form-group col-lg-4">
                            <label>Username</label>
                            <input type="text" class="form-control" name="username" style="width: 300px;">
                            </div></td>
                            </tr>
                            
                            <tr>
                            <td><div class="form-group col-lg-4">
                                <label>Password</label>
                                <input type="password" class="form-control" name="userpass" style="width: 300px;">
                            </div></td>
                             </tr>
                             
                             <tr>                           
                            <td><div class="form-group col-lg-12">                                
                                <center><input type="submit" name="submit1" class="btn btn-default" value="Login"></center>
                            </div></td>
                            </tr>
                            </table></center>
                        </div>
                    </form>                
                                                 
                     </div>          
               
                 
                 </div>            
                
              <!-- Faculty Login Ends -->  
              </td>
              </tr>
              </table>
           
                
        </div>

    </div>
    </div>
    <!-- /.container -->

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
