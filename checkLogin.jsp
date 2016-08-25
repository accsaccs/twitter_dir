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
	 	
	 	String signinError = "";

		out.println("signin_username: " + signin_username);
		out.println("signin_password: " + signin_password);


		String query = "select * from astrauss.users_t where user_name='" + signin_username + "' and pwd='" + signin_password + "'"; 
	 

		//open sql:
		Class.forName("com.mysql.jdbc.Driver").newInstance();
		url = "jdbc:mysql://localhost:3306/astrauss";
		con = DriverManager.getConnection(url, "astrauss", "happy95");
		java.sql.Statement stmt = con.createStatement();
         
		//executes the query:
		java.sql.ResultSet rs = stmt.executeQuery(query);

		String user_id = ""; 

		//loop through result set until there is no more data
		if(rs.next())
		{
			user_id = rs.getString("user_id");
			session.setAttribute("user_num", user_id);
			response.sendRedirect("twitterHome.jsp?");
		} //end while
	  	else
	  	{
	  		signinError = "Username or Password is incorrect";
	  		
	  		//fail
			response.sendRedirect("login.jsp?signinMsg=" + signinError);   
	  	}
		
	  
      } //close try 
      
      catch (Exception e) 
      {
         out.println(e);
      }
%>


