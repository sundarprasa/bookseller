<html>
<head>
  <title>Book Query</title>
</head>
<body>
  <h1>Academy E-Bookstore</h1>
  <h3>Choose Author(s):</h3>
  <form method="get">
	  <input type="checkbox" name="author" value="Tolstoy">Tolstoy<br>
	  <input type="checkbox" name="author" value="Shakespear">Shakespear<br>
	  <input type="checkbox" name="author" value="Agatha">Agatha Christie<br>
	  <input type="checkbox" name="author" value="Rowling">J K Rowling<br><br>
	  <input type="submit" value="List the Books and Price"><br>
  </form>
 
  <%
    String[] authors = request.getParameterValues("author");
    if (authors != null) {
  %>
  <%@ page import = "java.sql.*" %>
  <%
      // build the jdbc url

      // Read RDS connection information from the environment
      String dbName = System.getProperty("RDS_DB_NAME");
      String userName = System.getProperty("RDS_USERNAME");
      String password = System.getProperty("RDS_PASSWORD");
      String hostname = System.getProperty("RDS_HOSTNAME");
      String port = System.getProperty("RDS_PORT");
      String jdbcUrl = "jdbc:mysql://" + hostname + ":" +
        port + "/" + dbName + "?user=" + userName + "&password=" + password;

      // Load the JDBC driver
      try {
        System.out.println("Loading driver...");
        Class.forName("com.mysql.jdbc.Driver");
        System.out.println("Driver loaded!");
      } catch (ClassNotFoundException e) {
        throw new RuntimeException("Cannot find the driver in the classpath!", e);
      }

      Connection conn = null;
      Statement setupStatement = null;
      Statement readStatement = null;
      ResultSet resultSet = null;
      ResultSet rset = null;
      String results = "";
      int numresults = 0;
      String statement = null; 


      conn = DriverManager.getConnection(jdbcUrl);

      readStatement = conn.createStatement();
 
      String sqlStr = "SELECT * FROM books WHERE author IN (";
      sqlStr += "'" + authors[0] + "'";  // First author
      for (int i = 1; i < authors.length; ++i) {
         sqlStr += ", '" + authors[i] + "'";  // Subsequent authors need a leading commas
      }
      sqlStr += ") AND qty > 0 ORDER BY author ASC, title ASC";
 
      // for debugging
      System.out.println("Query statement is " + sqlStr);
      rset = readStatement.executeQuery(sqlStr);
  %>

      <hr>
      <form method="get" action="order.jsp">
        <table border=1 cellpadding=5>
          <tr>
            <th>Order</th>
            <th>Author</th>
            <th>Title</th>
            <th>Price</th>
            <th>Qty</th>
          </tr>
  <%
      while (rset.next()) {
        int id = rset.getInt("book_id");
  %>
          <tr>
            <td><input type="checkbox" name="id" value="<%= id %>"></td>
            <td><%= rset.getString("author") %></td>
            <td><%= rset.getString("title") %></td>
            <td>$<%= rset.getInt("price") %></td>
            <td><%= rset.getInt("qty") %></td>
          </tr>
  <%
      }
  %>
        </table>
        <br>
        <input type="submit" value="Order">
        <input type="reset" value="Clear">
      </form>
      <a href="<%= request.getRequestURI() %>"><h3>Back</h3></a>
  <%
      rset.close();
      readStatement.close();
      conn.close();
    }
  %>
</body>
</html>
