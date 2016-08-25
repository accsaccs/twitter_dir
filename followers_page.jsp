<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<%
	String user_num = request.getParameter("key2");
	String user_num_me = request.getParameter("key");
	
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
    String first_name = "";
    String last_name = "";
    String fullname = "";
    if(info_rs.next())
    { 
    	username = info_rs.getString("user_name");
    	first_name = info_rs.getString("first_name");
    	last_name = info_rs.getString("last_name");
    	fullname = first_name + " " + last_name;
    }
    
    String query_loggedin = "select user_name from astrauss.users_t where user_id='" + user_num_me + "'";
    java.sql.ResultSet rs_loggedin = stmt.executeQuery(query_loggedin);
    String loggedin = "";
    if(rs_loggedin.next()) loggedin = rs_loggedin.getString("user_name");
    
    String totalTweets_query = "select count(*) as 'total_tweets' from astrauss.tweet_t, astrauss.users_t WHERE astrauss.tweet_t.user_id=astrauss.users_t.user_id AND astrauss.users_t.user_id='" +  user_num + "'";
    java.sql.ResultSet totalTweets_rs = stmt.executeQuery(totalTweets_query);
    String totalTweets = "";
    if(totalTweets_rs.next()) totalTweets = totalTweets_rs.getString("total_tweets");
    
    String following_query = "SELECT COUNT(*) AS 'num_following' FROM users_t, follow_rel WHERE users_t.`user_id`=follow_rel.`user_f`AND users_t.user_id='" + user_num + "'";
	java.sql.ResultSet following_rs = stmt.executeQuery(following_query);
	String following = "";
	if(following_rs.next()) following = following_rs.getString("num_following");
	
	String followers_query = "SELECT COUNT(*) AS 'num_followers' FROM users_t, follow_rel WHERE users_t.`user_id`=follow_rel.`user_bf` AND users_t.user_id='" + user_num + "'";
	java.sql.ResultSet followers_rs = stmt.executeQuery(followers_query);
	String followers = "";
	if(followers_rs.next()) followers = followers_rs.getString("num_followers");
    
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
					<p class="navbar-text pull-right">Logged in as <a href="#" class="navbar-link"><% out.println(loggedin); %></a>
					</p>
					<ul class="nav">
						<li class="active"><a href="twitterHome.jsp?key=<%=user_num_me%>">Home</a></li>
						<li><a href="queries.html">Test Queries</a></li>
						<li><a href="twitter-signin.html">Main sign-in</a></li>
					</ul>
				</div><!--/ .nav-collapse -->
			</div>
		</div>
	</div>

    <div class="container wrap">
        <div class="row">

            <!-- left column -->
            <div class="span4" id="secondary">
                <div class="module mini-profile">
                    <div class="content">
                        <div class="account-group">
                            <a href="profile.jsp?key=<%=user_num_me%>&key2=<%=user_num%>">
                                <img class="avatar size32" src="images/pirate_normal.jpg" alt="Gordy">
                                <b class="fullname"> <% out.println(fullname); %> </b>
                                <small class="metadata"> @<% out.println(username); %> </small>
                            </a>
                        </div>
                    </div>
                    <div class="js-mini-profile-stats-container">
                        <ul class="stats">
                            <li><a href="profile.jsp?key=<%=user_num_me%>&key2=<%=user_num%>"><strong> <% out.println(totalTweets); %> </strong>Tweets</a></li>
                            <li><a href="following_page.jsp?key=<%=user_num_me%>&key2=<%=user_num%>"><strong> <% out.println(Integer.parseInt(following)-1); %> </strong>Following</a></li>
                            <li><a href="followers_page.jsp?key=<%=user_num_me%>&key2=<%=user_num%>"><strong> <% out.println(Integer.parseInt(followers)-1); %> </strong>Followers</a></li>
                        </ul>
                    </div>
                    
                </div>

                <div class="module other-side-content">
                    <div class="content"
                        <p>Some other content here</p>
                    </div>
                </div>
            </div>

            <!-- right column -->
            <div class="span8 content-main">
                <div class="module">
                    <div class="content-header">
                        <div class="header-inner">
                            <h2 class="js-timeline-title"> People Following <% out.println(first_name); %> </h2>
                        </div>
                    </div>

                    <!-- new tweets alert -->
                    <div class="stream-item hidden">
                        <div class="new-tweets-bar js-new-tweets-bar well">
                            2 new Tweets
                        </div>
                    </div>

<%
	String following_query2 = "SELECT u2.user_id 'user_id', u2.user_name 'user_name', u2.first_name 'first_name', u2.last_name 'last_name', f.user_bf 'following' FROM users_t u, users_t u2, follow_rel f WHERE u.`user_id` = '" + user_num + "' AND f.`user_bf` = u.`user_id` AND f.`user_f` = u2.`user_id`";
	java.sql.ResultSet following_rs2 = stmt.executeQuery(following_query2);
	String user_id2 = "";
	String user_name2 = "";
	String first_name2 = "";
	String last_name2 = "";
	
	java.sql.Statement stmt2 = conn.createStatement();

	
%>
                    <!-- all tweets -->
                    <div class="stream home-stream">

                        <!-- start tweet -->
                        <% while(following_rs2.next()) 
                           {
                           		user_id2 = following_rs2.getString("user_id"); 
                        		user_name2 = following_rs2.getString("user_name"); 
                        		first_name2 = following_rs2.getString("first_name"); 
                        		last_name2 = following_rs2.getString("last_name"); 
                        		
                        		if(Integer.parseInt(user_id2) != Integer.parseInt(user_num))
                        		{
  
                        %>
                        <div class="js-stream-item stream-item expanding-string-item">
                            <div class="tweet original-tweet">
                                <div class="content">
                                    <div class="stream-item-header">
                                        <a class="account-group">
                                            <img class="avatar" src="images/obama.png" alt="Barak Obama">
                                            <strong class="fullname"> <% out.println(first_name2 + " " + last_name2); %> </strong>
                                            <span>&rlm;</span>
                                            <span class="username">
                                                <s>@</s>
                                                <b> <% out.println(user_name2); %> </b>
                                            </span>
                                        </a>
                                    </div>
                                    <p class="js-tweet-text">
                                         <% // out.println(tweet_text); %>
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