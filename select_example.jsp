<%@page language="java" %>
<%@page import="java.util.*" %>
<%@page import="java.sql.*" %>
<%@page import="com.mysql.jdbc.*" %>

<%
     
      try {

         java.sql.Connection con = null;
         String url = "";

	 String signin_username = request.getParameter("signin-username");
	 String signin_password = request.getParameter("signin-password");

	 out.println("signin_username: " + signin_username);
	 out.println("signin_password: " + signin_password);


	 String query = "select * from astrauss.users_t"; 
	 

	 //open sql:
         Class.forName("com.mysql.jdbc.Driver").newInstance();
         url = "jdbc:mysql://localhost:3306/astrauss";
         con = DriverManager.getConnection(url, "astrauss", "happy95");
         java.sql.Statement stmt = con.createStatement();
         
	 //executes the query:
	 java.sql.ResultSet rs = stmt.executeQuery(query);

	 String user_id = ""; 

	 //loop through result set until there is no more data
      while(rs.next())
	  {
		user_id = rs.getString("user_id");
		out.println("userid: " + user_id);
	  } //end while

      } catch (Exception e) {
         out.println(e);
      }
%>


