<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*,bean.*" %>  
<%
Room room[]=(Room[])request.getSession().getAttribute("room");
%>
<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Reserve Room</title>

    <!-- Bootstrap Core CSS -->
    <link href="./bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="./bootstrap/css/business-casual.css" rel="stylesheet">

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

    <div class="brand">Welcome</div>
    

    <!-- Navigation -->
    <nav class="navbar navbar-default" role="navigation">
        <div class="container">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <!--  <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button> -->
                <!-- navbar-brand is hidden on larger screens, but visible when the menu is collapsed -->
                <!-- <a class="navbar-brand" href="index.html">Business Casual</a>-->
            </div>
            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav">
                    <li>
                        <a href="./bootstrap/profile.jsp">Profile</a>
                    </li>
                    <li>
                        <a href="./bootstrap/resources.jsp">Resources</a>
                    </li>
                    <li>
                        <a href="./bootstrap/notifications.jsp">Notifications</a>
                    </li>
                    <li>
                        <a href="./bootstrap/due_balances.jsp">Due Balance</a>
                    </li>
                    <li>
                        <a href="./bootstrap/logout.jsp">Logout</a>
                    </li>
                </ul>
            </div>
            <!-- /.navbar-collapse -->
        </div>
        <!-- /.container -->
    </nav>

    <div class="container">

<!-- ****************** Room Checkout ************************* -->
 <div class="row">
            <div class="box">
                <div class="col-lg-12">
                    <hr>
                    <h2 class="intro-text text-center">Reserve
                        <strong>Room</strong>
                    </h2>
                    <hr>
                  <br><br>
                    <form id="room_checkout" action="Room_Checkout" method="post">
                        <div class="row">
                        	<!-- <div class="form-group col-lg-4">-->
                                <center><label>Select a Room</label></center>
                                <table style="margin:0 auto;text-align: left;">
                                <% int i=0;
            					while(i<room.length){ %>
            					<tr>
                                <td width="10%"><input type="radio" name="room_list" class="form-control" value="<%=room[i].getResource_Id() %>"></td>
                                <td width="90%"><%=room[i].getRoom_Number() %>&nbsp;&nbsp;:&nbsp;&nbsp;<%=room[i].getFloor() %> </td>
                                </tr>                                
                                <% ++i;} %>
                       
                                </table>
                            <!--  </div>-->
                            
                            <div class="form-group col-lg-12">
                                <input type="hidden" name="room_checkout" value="1">
                                <center><input type="submit" class="btn btn-default" value="Reserve Room"></center>
                            </div>

                        </div>
                    </form>
                    <br><br>
                    <form id="i_am_here" action="Student_Room_Arrival" method="post">
                    
                    <div class="row">
                        	<!-- <div class="form-group col-lg-4">-->
                                <center><label>Check Out Room</label></center>
                                <table style="margin:0 auto;text-align: left;">
                              
                       
                                </table>
                            <!--  </div>-->
                            
                            <div class="form-group col-lg-12">
                                <input type="hidden" name="room_checkout" value="1">
                                <center><input type="submit" class="btn btn-default" value="I am here"></center>
                            </div>

                        </div>
                                    
                    
                    </form>
                    
                    
                </div>
            </div>
        </div>

<!-- *********************  Room booking form ends  ****************************** -->

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