<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<%

	String signup_firstname = request.getParameter("signup-firstname"); //suck in html ; store in java var
	String signup_lastname = request.getParameter("signup-lastname"); //suck in html ; store in java var
	String signup_email = request.getParameter("signup-email"); //suck in html ; store in java var
	String signup_handle = request.getParameter("signup-handle"); //suck in html ; store in java var
	String signup_password = request.getParameter("signup-password"); //suck in html ; store in java var
	String signup_phone = request.getParameter("signup-phone"); //suck in html ; store in java var
	
	String emptyBoxError = "";
	
	int status = 0;  //capture status after insertion attempt
	
	if(signup_firstname.length() > 0 && signup_lastname.length() > 0 && signup_email.length() > 0 && signup_handle.length() > 0  && signup_password.length() > 0  && signup_phone.length() > 0) 
	{
	
		//prepare queries to check to see if that email, handle, or phone already exists in user table
		String checkEmail = "select * from astrauss.users_t where email='" + signup_email + "'";
		String checkHandle = "select * from astrauss.users_t where user_name='" + signup_handle + "'";
		String checkPhone = "select * from astrauss.users_t where phone='" + signup_phone + "'";


		//connect to db
		java.sql.Connection conn = null;
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        String url = "jdbc:mysql://127.0.0.1/astrauss";   //location and name of database
        String userid = "astrauss";
        String password = "happy95";
        conn = DriverManager.getConnection(url, userid, password);      //connect to database
       	 
        java.sql.Statement stmt = conn.createStatement();
        java.sql.Statement stmt2 = conn.createStatement();
        java.sql.Statement stmt3 = conn.createStatement();
        //executes the query:
		java.sql.ResultSet checkEmail_rs = stmt.executeQuery(checkEmail);
		java.sql.ResultSet checkHandle_rs = stmt2.executeQuery(checkHandle);
		java.sql.ResultSet checkPhone_rs = stmt3.executeQuery(checkPhone);
		//gives error message if someone already has that email, handle, or phone
		if(checkEmail_rs.next())
		{
			String takenEmail = "That email is already registered";
			response.sendRedirect("login.jsp?signupMsg=" + takenEmail);
		} 
		else if(!signup_email.contains("@"))
		{
			String takenEmail = "Not a valid email address";
			response.sendRedirect("login.jsp?signupMsg=" + takenEmail);
		}
		else if(checkHandle_rs.next())
		{
			String takenHandle = "That handle is already registered";
			response.sendRedirect("login.jsp?signupMsg=" + takenHandle);
		}
		else if(checkPhone_rs.next())
		{
			String takenPhone = "That phone is already registered";
			response.sendRedirect("login.jsp?signupMsg=" + takenPhone);
		}
		else{
			java.sql.PreparedStatement ps_users_t = conn.prepareStatement("insert into astrauss.users_t (first_name,last_name,user_name,email,pwd,phone) values (?,?,?,?,?,?)");

			ps_users_t.setString (1,signup_firstname);
			ps_users_t.setString (2,signup_lastname); 
			ps_users_t.setString (3,signup_handle);
			ps_users_t.setString (4,signup_email);
			ps_users_t.setString (5,signup_password);
			ps_users_t.setString (6,signup_phone);
	
    		status = ps_users_t.executeUpdate(); 
    	
    		//success
			if(status > 0)
			{
				//do select statement here
				String query = "select * from astrauss.users_t where user_name='" + signup_handle + "' and pwd='" + signup_password + "'"; 
				java.sql.Statement stmt4 = conn.createStatement();

				java.sql.ResultSet rs = stmt4.executeQuery(query);
				String user_id = ""; 
		
				if(rs.next())
	  			{
					user_id = rs.getString("user_id");
					session.setAttribute("user_num", user_id);
	  			} //end if
	  			
				//make the user follow himself
	  			java.sql.PreparedStatement ps_follow_rel = conn.prepareStatement("insert into astrauss.follow_rel (user_f, user_bf) values (?,?)");
				ps_follow_rel.setString (1,user_id);
				ps_follow_rel.setString (2,user_id);
				ps_follow_rel.executeUpdate(); 
		
				response.sendRedirect("twitterHome.jsp?");
			}//close if status  
		}//close else (this runs if none of the info is already in the table)	
    }//close big if 
    
    else 
    {
    	emptyBoxError = "Please fill in all pieces of information!";
    	
    	//fail
		response.sendRedirect("login.jsp?signupMsg=" + emptyBoxError);   
    	
    }//close else
	
	

%>

<input type="hidden" name="key" value="99">
<h1> its a beautiful day in the neighborhood! </h1>



