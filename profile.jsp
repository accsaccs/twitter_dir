<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<%
	String user_num_them = request.getParameter("key2"); //this is the other person (aka person who you're looking at)
	String user_num = (String)session.getAttribute("user_num"); //this is me (/the person who's logged in)
	
	//connect to db
	java.sql.Connection conn = null;
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    String url = "jdbc:mysql://127.0.0.1/astrauss";   //location and name of database
    String userid = "astrauss";
    String password = "happy95";
    conn = DriverManager.getConnection(url, userid, password);      //connect to database
       	 
	String query_info = "select * from astrauss.users_t where user_id='" + user_num_them + "'";
    java.sql.Statement stmt = conn.createStatement();
    java.sql.ResultSet info_rs = stmt.executeQuery(query_info);
    String username = "";
    String fullname = "";
    if(info_rs.next())
    { 
    	username = info_rs.getString("user_name");
    	fullname = info_rs.getString("first_name") + " " + info_rs.getString("last_name");
    }
    
    String query_loggedin = "select user_name from astrauss.users_t where user_id='" + user_num + "'";
    java.sql.ResultSet rs_loggedin = stmt.executeQuery(query_loggedin);
    String loggedin = "";
    if(rs_loggedin.next()) loggedin = rs_loggedin.getString("user_name");
    
    String totalTweets_query = "select count(*) as 'total_tweets' from astrauss.tweet_t, astrauss.users_t WHERE astrauss.tweet_t.user_id=astrauss.users_t.user_id AND astrauss.users_t.user_id='" +  user_num_them + "'";
    java.sql.ResultSet totalTweets_rs = stmt.executeQuery(totalTweets_query);
    String totalTweets = "";
    if(totalTweets_rs.next()) totalTweets = totalTweets_rs.getString("total_tweets");
    
    String following_query = "SELECT COUNT(*) AS 'num_following' FROM users_t, follow_rel WHERE users_t.`user_id`=follow_rel.`user_f`AND users_t.user_id='" + user_num_them + "'";
	java.sql.ResultSet following_rs = stmt.executeQuery(following_query);
	String following = "";
	if(following_rs.next()) following = following_rs.getString("num_following");
	
	String followers_query = "SELECT COUNT(*) AS 'num_followers' FROM users_t, follow_rel WHERE users_t.`user_id`=follow_rel.`user_bf` AND users_t.user_id='" + user_num_them + "'";
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
						<li class="active"><a href="twitterHome.jsp?">Home</a></li>
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
                            <a href="profile.jsp?key2=<%=user_num_them%>">
                                <img class="avatar size32" src="images/pirate_normal.jpg" alt="Gordy">
                                <b class="fullname"> <% out.println(fullname); %> </b>
                                <small class="metadata"> @<% out.println(username); %> </small>
                            </a>
                        </div>
                    </div>
                    <div class="js-mini-profile-stats-container">
                        <ul class="stats">
                            <li><a href="profile.jsp?key2=<%=user_num_them%>"><strong> <% out.println(totalTweets); %> </strong>Tweets</a></li>
                            <li><a href="following_page.jsp?key2=<%=user_num_them%>"><strong> <% out.println(Integer.parseInt(following)-1);; %> </strong>Following</a></li>
                            <li><a href="followers_page.jsp?key2=<%=user_num_them%>"><strong> <% out.println(Integer.parseInt(followers)-1);; %> </strong>Followers</a></li>
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
                            <h2 class="js-timeline-title">Tweets by <% out.println(fullname); %></h2>
                        </div>
                    </div>

                    <!-- new tweets alert -->
                    <div class="stream-item hidden">
                        <div class="new-tweets-bar js-new-tweets-bar well">
                            2 new Tweets
                        </div>
                    </div>

<%
	String tweets_query = "SELECT t.tweet_text 'tweetText', t.create_time 'create_time' FROM tweet_t t, users_t u WHERE u.`user_id` = '" + user_num_them + "' AND t.`user_id` = u.`user_id`";
	java.sql.ResultSet tweets_rs = stmt.executeQuery(tweets_query);
	String tweet_text = "";
	String create_time = "";
	String query_tweet_info = "";
	java.sql.Statement stmt2 = conn.createStatement();
	String minutes = "";

	
%>
                    <!-- all tweets -->
                    <div class="stream home-stream">

                        <!-- start tweet -->
                        <% while(tweets_rs.next()) 
                           {
                        		tweet_text = tweets_rs.getString("tweetText"); 
                        		create_time = tweets_rs.getString("create_time"); 
                        		
                        		String minutes_query = "SELECT ABS(TIMESTAMPDIFF(DAY, now(), '" + create_time + "')) as minutes";
                        		java.sql.ResultSet minutes_rs = stmt2.executeQuery(minutes_query);
                        		if(minutes_rs.next()) minutes = minutes_rs.getString("minutes"); 
                        		
                        		//build the tweet_text_modified string 
								String hashtag_text = "";
								String hashtag_id = "";
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
											hashtag_id = rs_hash_id.getString("hashtag_id");
											tweet_text_modified += "<a href='hash_profile.jsp?hashtag_id=" + hashtag_id + "&key=" + user_num + "' >" + hashtag_text + "</a> ";
										}//close if
									}//close hashtag in word if 
									else
									{
										tweet_text_modified += splittedString[i] + " ";
									}
									// text_tweet_modified = "<a href='hash_list.jsp?hash_id=" + hash_id + "'>" hash_array[i] + "</a"
								}//close for loop 
  
                        %>
                        <div class="js-stream-item stream-item expanding-string-item">
                            <div class="tweet original-tweet">
                                <div class="content">
                                    <div class="stream-item-header">
                                        <small class="time">
                                            <a href="#" class="tweet-timestamp" title="10:15am - 16 Nov 12">
                                                <span class="_timestamp"> <% out.println(minutes + " days"); %> </span>
                                            </a>
                                        </small>
                                        <a class="account-group">
                                            <img class="avatar" src="images/obama.png" alt="Barak Obama">
                                            <strong class="fullname"> <% out.println(fullname); %> </strong>
                                            <span>&rlm;</span>
                                            <span class="username">
                                                <s>@</s>
                                                <b> <% out.println(username); %> </b>
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