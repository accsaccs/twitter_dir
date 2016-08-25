<%@page language="java" %>
<%@page import="java.util.*" %>
<%@page import="java.sql.*" %>
<%@page import="com.mysql.jdbc.*" %>

<%
     
      try {
		
		String tweet_text = request.getParameter("tweet_text"); //suck in html ; store in java var
		String user_id = request.getParameter("user_id"); //suck in html ; store in java var
		int status_tweet = 0;
		int status_hashtag = 0;
		int status_hashRel = 0;
		
		if(tweet_text.length() > 0)
		{
			//connect to db
			java.sql.Connection conn = null;
        	Class.forName("com.mysql.jdbc.Driver").newInstance();
        	String url = "jdbc:mysql://127.0.0.1/astrauss";   //location and name of database
        	String userid = "astrauss";
        	String password = "happy95";
        	conn = DriverManager.getConnection(url, userid, password);      //connect to database
       	 
       	 	//insert the tweet 
        	java.sql.PreparedStatement ps_tweet = conn.prepareStatement("insert into astrauss.tweet_t (user_id,tweet_text,create_time) values (?,?,NOW())");
			ps_tweet.setString (1,user_id);
			ps_tweet.setString (2,tweet_text);
			
			status_tweet = ps_tweet.executeUpdate(); 
			
			if(tweet_text.contains("#"))
			{
				//get hashtag from tweet
				String hashtag_text = "";
				String []splittedString=tweet_text.split(" ");
				for(int i = 0; i < splittedString.length; i++)
				{
					if(splittedString[i].substring(0,1).equals("#"))
					{
						hashtag_text = splittedString[i].substring(1); 
						
						//check to see if hashtag is already in the hashtag table
						java.sql.Statement stmt3 = conn.createStatement();
						String check_hashtag_query = "select * from astrauss.hashtags where hashtag_text='" + hashtag_text + "'"; 
						java.sql.ResultSet check_hashtag_rs = stmt3.executeQuery(check_hashtag_query);
						if(check_hashtag_rs.next())
						{
							status_hashtag = 1;
						}
						else
						{
        					//insert hashtag into hashtag table 
        					java.sql.PreparedStatement ps_hashtag = conn.prepareStatement("insert into astrauss.hashtags (hashtag_text) values (?)");
							ps_hashtag.setString (1,hashtag_text);
							status_hashtag = ps_hashtag.executeUpdate();
						}//close else
						
						//enter in the tweet-hashtag relationship in the hashtag_rel table 
						if(status_hashtag > 0)
						{	
							java.sql.Statement stmt = conn.createStatement();
							java.sql.Statement stmt2 = conn.createStatement();
					
							String hashtagID_query = "select hashtag_id from astrauss.hashtags where hashtag_text='" + hashtag_text + "'"; 
							String tweetID_query = "select tweet_id from astrauss.tweet_t where tweet_text='" + tweet_text + "'"; 
					
							java.sql.ResultSet hashtagID_rs = stmt.executeQuery(hashtagID_query);
							java.sql.ResultSet tweetID_rs = stmt2.executeQuery(tweetID_query);
					
							String hashtag_id = ""; 
							String tweet_id = ""; 
		
							if(hashtagID_rs.next())
	  						{
								hashtag_id = hashtagID_rs.getString("hashtag_id");
	  						} //end if
	  				
	  						if(tweetID_rs.next())
	  						{
								tweet_id = tweetID_rs.getString("tweet_id");
	  						} //end if
	  						
	  						//check to see if the rel already exists 
							String check_hashrel_query = "select * from hashtag_rel where hashtag_id = '" + hashtag_id + "' and tweet_id = '" + tweet_id + "'";
	  					 	java.sql.ResultSet check_hashrel_rs = stmt3.executeQuery(check_hashrel_query);
	  					 	if(!check_hashrel_rs.next())
	  					 	{
	  					 		java.sql.PreparedStatement ps_hashRel = conn.prepareStatement("insert into astrauss.hashtag_rel (hashtag_id, tweet_id) values (?,?)");
								ps_hashRel.setString (1,hashtag_id);
								ps_hashRel.setString (2,tweet_id);
							
								status_hashRel = ps_hashRel.executeUpdate(); 
	  					 	}
	  					 	
						}//close hashtagRel if 
						
					}//close splitstring if 
				}//close splitstring for 
	
			}//close hashtag if 			
			
			
			if(status_tweet > 0)
			{
				response.sendRedirect("twitterHome.jsp?key=" + user_id);
			}//close redirect if
        
		}
		
	  
      } //close try 
      
      catch (Exception e) 
      {
         out.println(e);
      } //close catch
%>


