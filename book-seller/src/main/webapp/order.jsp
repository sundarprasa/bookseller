<html>
<head>
  <title>Academy Bookstore Order Management</title>
</head>
<body>
  <h3>Thank you for ordering books </h3>
  <h4>Your Feedback, Please </h3>
  <form method="get">
    <input type="checkbox" name="feedback" value="Excellent">Excellent
    <input type="checkbox" name="feedback" value="Good">Good
    <input type="checkbox" name="feedback" value="Average">Average
    <br><br><br><input type="submit" value="Submit Feedback">
  </form>
 
  <%
  String[] feedbacks = request.getParameterValues("feedback");
  if (feedbacks != null) {
  %>
    <h3>Thank You for the Feedback</h3>
    <br> <br>
    <!--<a href="<%= request.getRequestURI() %>">BACK</a>-->
    <a href="index.jsp">BACK</a>
  <%
  }
  %>
</body>
</html>
