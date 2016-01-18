<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*,bean.*" %>  
<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Resources</title>

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
                <!-- <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>-->
                <!-- navbar-brand is hidden on larger screens, but visible when the menu is collapsed -->
                <!--<a class="navbar-brand" href="index.html">Business Casual</a>-->
            </div>
            <!-- Collect the nav links, forms, and other content for toggling -->
      <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav">
                    <li>
                        <a href="student_profile.jsp">Profile</a>
                    </li>
                    <li>
                        <a href="student_resources.jsp">Resources</a>
                    </li>
                    <li>
                        <a href="student_notifications.jsp">Notifications</a>
                    </li>
                    <li>
                        <a href="student_due_balances.jsp">Due Balance</a>
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

<%
int priority=(int)request.getSession().getAttribute("priority");
if(priority>0)
{
%>

    <div class="container">


 <div class="row">
            <div class="box">
           
                <div class="col-lg-12">
                    
                    <!-- Book Form -->
                    <form name="student_Book_select" method="post" action="../Redirect_To_Search_Book">
                        <div class="row">
                           
                            <div class="form-group col-lg-12">
                                <input type="hidden" name="book" value="1">
                                <center><input type="submit" name="book_select" class="btn btn-default" value="Books" style="width:200px"/></center>
                            </div>
                        </div>
                    </form>
                    <!-- Book Form Ends-->
                    
                    <!-- ConferencePaper Form -->
                    <form name="student_ConferencePaper_select" method="post" action="../Conference_Retrieve">
                        <div class="row">
                           
                            <div class="form-group col-lg-12">
                                <input type="hidden" name="conference" value="1">
                                <center><input type="submit" name="conference_select" class="btn btn-default" value="Conference Papers" style="width:200px"/></center>
                            </div>
                        </div>
                    </form>
                    <!-- ConferencePaper Form Ends-->
                    
                     <!-- Journal Form -->
                    <form name="student_Journal_select" method="post" action="../Journal_Retrieve">
                        <div class="row">
                           
                            <div class="form-group col-lg-12">
                                <input type="hidden" name="journal" value="1">
                                <center><input type="submit" name="journal_select" class="btn btn-default" value="Journals" style="width:200px"/></center>
                            </div>
                        </div>
                    </form>
                    <!-- Journal Form Ends-->
                    
                    <!-- Room Form -->
                    <form name="student_Room_select" method="post" action="../Room_Retrieve">
                        <div class="row">
                           
                            <div class="form-group col-lg-12">
                                <input type="hidden" name="room" value="1">
                                <center><input type="submit" name="room_select" class="btn btn-default" value="Rooms" style="width:200px"/></center>
                            </div>
                        </div>
                    </form>
                    <!-- Room Form Ends-->
                    
                    <!-- Camera Form -->
                    <form name="student_Camera_select" method="post" action="../Camera_Retrieve">
                        <div class="row">
                           
                            <div class="form-group col-lg-12">
                                <input type="hidden" name="camera" value="1">
                                <center><input type="submit" name="camera_select" class="btn btn-default" value="Camera" style="width:200px"/></center>
                            </div>
                        </div>
                    </form>
                    
                    <!-- Camera Form Ends-->
                    
                    <!-- MY RESOURCES STARTS-->
                    <form name="student_Camera_select" method="post" action="../My_Resources">
                        <div class="row">
                           
                            <div class="form-group col-lg-12">
                                <input type="hidden" name="camera" value="1">
                                <center><input type="submit" name="my_resources" class="btn btn-default" value="My Resources" style="width:200px"/></center>
                            </div>
                        </div>
                    </form>
                    
                    <!--MY RESOURCES ENDS-->
                </div>
                
            </div>
        </div>

    </div>
    
  <% 
  }
  else
  {
  %>
<center><b>Your account has been Suspended. Please pay your dues</b><a href="./bootstrap/student.jsp">Go Back</a></center>  
  
  <%
  System.out.println("The priority is"+session.getAttribute("priority"));
  } %>
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
