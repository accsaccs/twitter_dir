<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<%
	String user_num = request.getParameter("key");
	String hashtag_id = request.getParameter("hashtag_id");
	
	//connect to db
	java.sql.Connection conn = null;
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    String url = "jdbc:mysql://127.0.0.1/astrauss";   //location and name of database
    String userid = "astrauss";
    String password = "happy95";
    conn = DriverManager.getConnection(url, userid, password);      //connect to database
       	 
	String query_info = "select * from astrauss.users_t where user_id='" + user_num + "'";
    java.sql.Statement stmt = conn.createStatement();
    java.sql.ResultSet info_rs = stmt.executeQuery(query_info);
    String username = "";
    String fullname = "";
    if(info_rs.next())
    { 
    	username = info_rs.getString("user_name");
    	fullname = info_rs.getString("first_name") + " " + info_rs.getString("last_name");
    }
    
    String get_hashtag = "select hashtag_text from astrauss.hashtags where `hashtag_id`= '" + hashtag_id + "'";
    java.sql.ResultSet got_hashtag = stmt.executeQuery(get_hashtag);
    String title_hashtag = "";
    if(got_hashtag.next())
    {
    	title_hashtag = "#" + got_hashtag.getString("hashtag_text");
    }
    
%>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title></title>
    <meta name="description" content="">
    <meta name="author" content="">
    <style type="text/css">
    	body {
    		padding-top: 60px;
    		padding-bottom: 40px;
    	}
    	.sidebar-nav {
    		padding: 9px 0;
    	}
    </style>    
    <link rel="stylesheet" href="css/gordy_bootstrap.min.css">
</head>
<body class="user-style-theme1">
	<div class="navbar navbar-inverse navbar-fixed-top">
		<div class="navbar-inner">
			<div class="container">
                <i class="nav-home"></i> <a href="#" class="brand">!Twitter</a>
				<div class="nav-collapse collapse">
					<p class="navbar-text pull-right">Logged in as <a href="#" class="navbar-link"><% out.println(username); %></a>
					</p>
					<ul class="nav">
						<li class="active"><a href="twitterHome.jsp?key=<%=user_num%>">Home</a></li>
						<li><a href="queries.html">Test Queries</a></li>
						<li><a href="twitter-signin.html">Main sign-in</a></li>
					</ul>
				</div><!--/ .nav-collapse -->
			</div>
		</div>
	</div>

    <div class="container wrap">
        <div class="row">

<%
	String hashtags_query = "SELECT h_rel.tweet_id 'tweet_id', t.create_time 'create_time', t.tweet_text 'tweet_text', t.user_id 'user_id' FROM tweet_t t, hashtag_rel h_rel, hashtags h WHERE h.`hashtag_id` = " + hashtag_id + " AND h_rel.`tweet_id` = t.`tweet_id` AND h_rel.`hashtag_id` = h.`hashtag_id`";
	java.sql.ResultSet hashtags_rs = stmt.executeQuery(hashtags_query);
	String tweet_text = "";
	String create_time = "";
	String user_id = "";
	String tweet_fullname = "";
	String tweet_username = "";
	String query_tweet_info = "";
	java.sql.Statement stmt2 = conn.createStatement();
	java.sql.Statement stmt3 = conn.createStatement();
	String minutes = "";
%>  

            <!-- right column -->
            <div class="span8 content-main">
                <div class="module">
                    <div class="content-header">
                        <div class="header-inner">
                            <h2 class="js-timeline-title hash"> <% out.println(title_hashtag); %>  </h2>
                        </div>
                    </div>

                    <!-- new tweets alert -->
                    <div class="stream-item hidden">
                        <div class="new-tweets-bar js-new-tweets-bar well">
                            2 new Tweets
                        </div>
                    </div>

               <!-- all tweets -->
                    <div class="stream home-stream">

                        <!-- start tweet -->
                        <% while(hashtags_rs.next()) 
                           {
                        		tweet_text = hashtags_rs.getString("tweet_text"); 
                        		create_time = hashtags_rs.getString("create_time"); 
                        		user_id = hashtags_rs.getString("user_id"); 
                        		
                        		String minutes_query = "SELECT ABS(TIMESTAMPDIFF(DAY, now(), '" + create_time + "')) as minutes";
                        		java.sql.ResultSet minutes_rs = stmt3.executeQuery(minutes_query);
                        		if(minutes_rs.next()) minutes = minutes_rs.getString("minutes"); 
                        		
                        		
                        		//get the name of the person who tweeted the tweet
                        		query_tweet_info = "select * from users_t where user_id='" + user_id + "'";
								java.sql.ResultSet rs_tweet_info = stmt2.executeQuery(query_tweet_info);
								if(rs_tweet_info.next())
								{
									tweet_fullname = rs_tweet_info.getString("first_name") + " " + rs_tweet_info.getString("last_name");
									tweet_username = rs_tweet_info.getString("user_name");
								}
								
								//build the tweet_text_modified string 
								String hashtag_text = "";
								String hash_id = "";
								String tweet_text_modified = "";
								String []splittedString=tweet_text.split(" ");
								String query_hash_id = "";
								for(int i = 0; i < splittedString.length; i++)
								{
									if(splittedString[i].substring(0,1).equals("#"))
									{
										hashtag_text = splittedString[i]; 
										query_hash_id = "select hashtag_id from hashtags where hashtag_text='" + splittedString[i].substring(1) + "'";
										java.sql.ResultSet rs_hash_id = stmt2.executeQuery(query_hash_id);
										if(rs_hash_id.next())
										{
											hash_id = rs_hash_id.getString("hashtag_id");
											tweet_text_modified += "<a href='hash_profile.jsp?hashtag_id=" + hash_id + "&key=" + user_num + "' >" + hashtag_text + "</a> ";
										}//close if
									}//close hashtag in word if 
									else
									{
										tweet_text_modified += splittedString[i] + " ";
									}
								}//close for loop 
								
                        %>
                        <div class="js-stream-item stream-item expanding-string-item">
                            <div class="tweet original-tweet">
                                <div class="content">
                                    <div class="stream-item-header">
                                        <small class="time">
                                            <a href="#" class="tweet-timestamp" title="10:15am - 16 Nov 12">
                                                <span class="_timestamp"><% out.println(minutes + " days"); %></span>
                                            </a>
                                        </small>
                                        <a class="account-group" href="profile.jsp?key=<%=user_num%>&key2=<%=user_id%>" >
                                            <img class="avatar" src="images/obama.png" alt="Barak Obama">
                                            <strong class="fullname"> <% out.println(tweet_fullname); %> </strong>
                                            <span>&rlm;</span>
                                            <span class="username">
                                                <s>@</s>
                                                <b> <% out.println(tweet_username); %> </b>
                                            </span>
                                        </a>
                                    </div>
                                    <p class="js-tweet-text">
                                        <% out.println(tweet_text_modified); %>
                                            <span class="invisible">http://</span>
                                            <span class="js-display-url"></span>
                                            <span class="invisible"></span>
                                            <span class="tco-ellipsis">
                                                <span class="invisible">&nbsp;</span>
                                            </span>
                                        </a>
                                    </p>
                                </div>
                            </a>
                                <div class="expanded-content js-tweet-details-dropdown"></div>
                            </div>
                        </div><!-- end tweet -->
					<% 
						}
					%>
                       
                    </div>
                    <div class="stream-footer"></div>
                    <div class="hidden-replies-container"></div>
                    <div class="stream-autoplay-marker"></div>
                </div>
                </div>
               
            </div>
        </div>
    </div>
     <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
     <script type="text/javascript" src="js/main-ck.js"></script>
  </body>
</html>