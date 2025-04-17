CREATE DATABASE microloom
-------------------------------------
CREATE TABLE users(
u_id int identity(1,1) primary key,
email nvarchar(50) unique,
username nvarchar(15) unique,
full_name nvarchar(max),
profile_pic nvarchar(max),
followers bigint,
followings bigint,
bio nvarchar(150),
joining_date date,
gender nvarchar(9),
location nvarchar(20),
pass nvarchar(64) 
)
-------------------------------------
CREATE TABLE posts(
p_id int identity(1,1) primary key,
u_id int references users(u_id) on delete cascade,
post nvarchar(max),
likes bigint,
dislikes bigint,
comments bigint,
shares bigint,
post_time datetime
)
-------------------------------------
CREATE TABLE comments(
c_id int identity(1,1),
p_id int references posts(p_id) ON DELETE CASCADE,
u_id int references users(u_id),
comment nvarchar(max),
likes bigint,
dislikes bigint,
comment_time datetime,
primary key (c_id, p_id, u_id)
)
-------------------------------------
CREATE TABLE follows(
follower_id int references users(u_id),
following_id int references users(u_id),
primary key (follower_id, following_id),
constraint not_equals check (follower_id <> following_id)
)
-------------------------------------
CREATE TABLE reactions(
u_id int references users(u_id),
p_id int references posts(p_id) ON DELETE CASCADE,
reaction nvarchar(8),
primary key (u_id, p_id),
CONSTRAINT reaction CHECK (reaction IN ('Liked', 'Disliked'))
)
-------------------------------------
CREATE TABLE shares(
u_id int references users(u_id),
p_id int references posts(p_id) ON DELETE CASCADE,
sharing_time datetime,
primary key (u_id, p_id)
)
-------------------------------------
CREATE PROCEDURE new_post
@u_id int,
@post nvarchar(max),
@post_time datetime

AS
BEGIN
	INSERT INTO posts VALUES(@u_id, @post, 0, 0, 0, 0, @post_time);
END
-------------------------------------
CREATE PROCEDURE get_posts
@profile_user_id int,
@current_user_id int

AS
BEGIN
	SELECT username, profile_pic, posts.u_id AS u_id, p_id, post, likes, dislikes, comments, shares, post_time, 
	
	CASE
	WHEN exists (SELECT reaction FROM reactions WHERE reactions.u_id = @current_user_id and reactions.p_id = posts.p_id) 
	THEN (SELECT reaction FROM reactions WHERE reactions.u_id = @current_user_id and reactions.p_id = posts.p_id)
	ELSE 'null'
	END AS LikeText,
	
	CASE
	WHEN exists (SELECT * FROM shares WHERE shares.u_id = @current_user_id and shares.p_id = posts.p_id)
	THEN 'Shared'
	ELSE 'null'
	END AS ShareText
	
	FROM 
	users, posts 
	WHERE 
	posts.u_id=users.u_id and posts.u_id = @profile_user_id
	ORDER BY post_time DESC
END
-------------------------------------
CREATE PROCEDURE add_remove_reaction
@status nvarchar(20),
@u_id int,
@p_id int

AS
BEGIN
	IF @status = 'add_like'
		BEGIN
			INSERT INTO reactions VALUES (@u_id, @p_id, 'Liked')
			UPDATE posts SET likes = likes + 1 WHERE p_id = @p_id
			INSERT INTO notifications (u_id, notif_text, link) SELECT p.u_id, u.username + ' liked your post', '/Home/Post.aspx?p_id=' + CAST(@p_id AS nvarchar) FROM posts p JOIN users u ON u.u_id = @u_id WHERE p.p_id = @p_id;
		END
		
	ELSE IF @status = 'add_dislike'
		BEGIN
			INSERT INTO reactions VALUES (@u_id, @p_id, 'Disliked')
			UPDATE posts SET dislikes = dislikes + 1 WHERE p_id = @p_id
			INSERT INTO notifications (u_id, notif_text, link) SELECT p.u_id, u.username + ' disliked your post', '/Home/Post.aspx?p_id=' + CAST(@p_id AS nvarchar) FROM posts p JOIN users u ON u.u_id = @u_id WHERE p.p_id = @p_id;
		END
		
	ELSE IF @status = 'remove_like'
		BEGIN
			DELETE FROM reactions WHERE u_id = @u_id and p_id = @p_id
			UPDATE posts SET likes = likes - 1 WHERE p_id = @p_id
		END
		
	ELSE IF @status = 'remove_dislike'
		BEGIN
			DELETE FROM reactions WHERE u_id = @u_id and p_id = @p_id
			UPDATE posts SET dislikes = dislikes - 1 WHERE p_id = @p_id
		END
		
	ELSE IF @status = 'like_to_dislike'
		BEGIN
			UPDATE reactions SET reaction = 'Disliked' WHERE u_id = @u_id and p_id = @p_id and reaction = 'Liked'
			UPDATE posts SET dislikes = dislikes + 1, likes = likes - 1 WHERE p_id = @p_id
			INSERT INTO notifications (u_id, notif_text, link) SELECT p.u_id, u.username + ' disliked your post', '/Home/Post.aspx?p_id=' + CAST(@p_id AS nvarchar) FROM posts p JOIN users u ON u.u_id = @u_id WHERE p.p_id = @p_id;
		END
		
	ELSE IF @status = 'dislike_to_like'
		BEGIN
			UPDATE reactions SET reaction = 'Liked' WHERE u_id = @u_id and p_id = @p_id and reaction = 'Disliked'
			UPDATE posts SET dislikes = dislikes - 1, likes = likes + 1 WHERE p_id = @p_id
			INSERT INTO notifications (u_id, notif_text, link) SELECT p.u_id, u.username + ' liked your post', '/Home/Post.aspx?p_id=' + CAST(@p_id AS nvarchar) FROM posts p JOIN users u ON u.u_id = @u_id WHERE p.p_id = @p_id;
		END

	SELECT likes, dislikes, comments, shares, 
	CASE
		WHEN exists (SELECT reaction FROM reactions WHERE reactions.u_id = @u_id and reactions.p_id = posts.p_id) 
		THEN (SELECT reaction FROM reactions WHERE reactions.u_id = @u_id and reactions.p_id = posts.p_id)
		ELSE 'null'
	END AS LikeText 

	FROM posts
	WHERE p_id = @p_id
END
-------------------------------------
CREATE PROCEDURE get_shares
@profile_user_id int,
@current_user_id int

AS
BEGIN
	SELECT username, profile_pic, users.u_id AS u_id, posts.p_id AS p_id, post, likes, dislikes, comments, shares, post_time, sharing_time,
	
	CASE
	WHEN exists (SELECT reaction FROM reactions WHERE reactions.u_id = @current_user_id and reactions.p_id = posts.p_id) 
	THEN (SELECT reaction FROM reactions WHERE reactions.u_id = @current_user_id and reactions.p_id = posts.p_id)
	ELSE 'null'
	END AS LikeText,
	
	CASE
	WHEN exists (SELECT * FROM shares WHERE shares.u_id = @current_user_id and shares.p_id = posts.p_id)
	THEN 'Shared'
	ELSE 'null'
	END AS ShareText
	
	FROM 
	users, posts, shares 
	WHERE 
	shares.p_id = posts.p_id and posts.u_id=users.u_id and shares.u_id = @profile_user_id
	ORDER BY sharing_time DESC
END
-------------------------------------
CREATE PROCEDURE add_remove_share
@u_id int,
@p_id int

AS
BEGIN

	IF NOT EXISTS (SELECT * FROM shares WHERE u_id = @u_id and p_id = @p_id)
	BEGIN
		INSERT INTO shares VALUES (@u_id, @p_id, GETDATE()); 
		UPDATE posts SET shares = shares + 1 WHERE p_id = @p_id;
		INSERT INTO notifications (u_id, notif_text, link) SELECT p.u_id, u.username + ' shared your post', '/Home/Post.aspx?p_id=' + CAST(@p_id AS nvarchar) FROM posts p JOIN users u ON u.u_id = @u_id WHERE p.p_id = @p_id;
	END
	
	ELSE
	BEGIN
		DELETE FROM shares WHERE u_id = @u_id and p_id = @p_id;
		UPDATE posts SET shares = shares - 1 WHERE p_id = @p_id
	END
	
	SELECT likes, dislikes, comments, shares, 
	CASE
		WHEN exists (SELECT * FROM shares WHERE u_id = @u_id and p_id = @p_id) 
		THEN 'Shared'
		ELSE 'null'
	END AS ShareText 
	FROM posts
	WHERE p_id = @p_id
	
END
-------------------------------------
CREATE PROCEDURE get_liked_posts
@profile_user_id int,
@current_user_id int

AS
BEGIN
	SELECT username, profile_pic, users.u_id AS u_id, posts.p_id AS p_id, post, likes, dislikes, comments, shares, post_time,
	
	CASE
	WHEN exists (SELECT reaction FROM reactions WHERE reactions.u_id = @current_user_id and reactions.p_id = posts.p_id) 
	THEN (SELECT reaction FROM reactions WHERE reactions.u_id = @current_user_id and reactions.p_id = posts.p_id)
	ELSE 'null'
	END AS LikeText,
	
	CASE
	WHEN exists (SELECT * FROM shares WHERE shares.u_id = @current_user_id and shares.p_id = posts.p_id)
	THEN 'Shared'
	ELSE 'null'
	END AS ShareText
	
	FROM 
	users, posts, reactions 
	WHERE 
	reactions.p_id = posts.p_id and posts.u_id=users.u_id and reactions.u_id = @profile_user_id and reactions.reaction = 'Liked'
END
-------------------------------------
CREATE PROCEDURE get_disliked_posts
@profile_user_id int,
@current_user_id int

AS
BEGIN
	SELECT username, profile_pic, users.u_id AS u_id, posts.p_id AS p_id, post, likes, dislikes, comments, shares, post_time,
	
	CASE
	WHEN exists (SELECT reaction FROM reactions WHERE reactions.u_id = @current_user_id and reactions.p_id = posts.p_id) 
	THEN (SELECT reaction FROM reactions WHERE reactions.u_id = @current_user_id and reactions.p_id = posts.p_id)
	ELSE 'null'
	END AS LikeText,
	
	CASE
	WHEN exists (SELECT * FROM shares WHERE shares.u_id = @current_user_id and shares.p_id = posts.p_id)
	THEN 'Shared'
	ELSE 'null'
	END AS ShareText
	
	FROM 
	users, posts, reactions 
	WHERE 
	reactions.p_id = posts.p_id and posts.u_id=users.u_id and reactions.u_id = @profile_user_id and reactions.reaction = 'Disliked'
END
-------------------------------------
CREATE PROCEDURE get_single_post
@current_user_id int,
@post_id int

AS
BEGIN
	SELECT username, profile_pic, posts.u_id AS u_id, p_id, post, likes, dislikes, comments, shares, post_time, 
	
	CASE
	WHEN exists (SELECT reaction FROM reactions WHERE reactions.u_id = @current_user_id and reactions.p_id = posts.p_id) 
	THEN (SELECT reaction FROM reactions WHERE reactions.u_id = @current_user_id and reactions.p_id = posts.p_id)
	ELSE 'null'
	END AS LikeText,
	
	CASE
	WHEN exists (SELECT * FROM shares WHERE shares.u_id = @current_user_id and shares.p_id = posts.p_id)
	THEN 'Shared'
	ELSE 'null'
	END AS ShareText
	
	FROM 
	users, posts 
	WHERE 
	posts.u_id = users.u_id and p_id = @post_id
END
-------------------------------------
CREATE PROCEDURE get_comments
@p_id int

AS
BEGIN

SELECT comments.u_id as u_id, username, profile_pic, comment
FROM comments, users
WHERE p_id = @p_id  and comments.u_id = users.u_id
ORDER BY comment_time

END
-------------------------------------
CREATE PROCEDURE add_comments
@p_id int,
@u_id int,
@comment nvarchar(max)

AS
BEGIN
	INSERT INTO comments VALUES (@p_id, @u_id, @comment, 0, 0, GETDATE());
	UPDATE posts SET comments = comments + 1 WHERE p_id = @p_id;
	INSERT INTO notifications (u_id, notif_text, link) SELECT p.u_id, u.username + ' commented on your post', '/Home/Post.aspx?p_id=' + CAST(@p_id AS nvarchar) FROM posts p JOIN users u ON u.u_id = @u_id WHERE p.p_id = @p_id;
END
-------------------------------------
CREATE PROCEDURE get_follows
@profile_user_id int,
@current_user_id int

AS
BEGIN

SELECT CASE
WHEN EXISTS (SELECT * from follows WHERE follower_id = @current_user_id and following_id = @profile_user_id)
THEN 'follows'
ELSE 'null'
END AS 'Follow Text'

END
-------------------------------------
CREATE PROCEDURE get_commented_posts
@profile_user_id int,
@current_user_id int

AS
BEGIN
	SELECT username, profile_pic, posts.u_id AS u_id, p_id, post, likes, dislikes, comments, shares, post_time, 
	
	CASE
	WHEN exists (SELECT reaction FROM reactions WHERE reactions.u_id = @current_user_id and reactions.p_id = posts.p_id) 
	THEN (SELECT reaction FROM reactions WHERE reactions.u_id = @current_user_id and reactions.p_id = posts.p_id)
	ELSE 'null'
	END AS LikeText,
	
	CASE
	WHEN exists (SELECT * FROM shares WHERE shares.u_id = @current_user_id and shares.p_id = posts.p_id)
	THEN 'Shared'
	ELSE 'null'
	END AS ShareText
	
	FROM 
	users, posts 
	WHERE 
	posts.u_id=users.u_id and posts.p_id IN (SELECT DISTINCT p_id FROM comments WHERE u_id = @profile_user_id)
	ORDER BY post_time DESC
END
-------------------------------------
CREATE PROCEDURE register_new_user
    @username NVARCHAR(15),
    @full_name NVARCHAR(MAX),
    @email NVARCHAR(50),
    @pass NVARCHAR(64)
AS
BEGIN
    -- Check if username already exists
    IF EXISTS (SELECT u_id FROM users WHERE username = @username)
    BEGIN
		SELECT -1;
        RETURN;  -- Username already exists
    END

    -- Check if email already exists
    IF EXISTS (SELECT u_id FROM users WHERE email = @email)
    BEGIN
		SELECT -2;
        RETURN;  -- Email already exists
    END

    -- Insert new user if no duplicate is found
    INSERT INTO users (email, username, full_name, pass, profile_pic, joining_date, followers, followings) 
    VALUES (@email, @username, @full_name, @pass, '/ProfilePictures/default_pic.jpg', GETDATE(), 0, 0);

    SELECT 1;
    RETURN;  -- Successful registration
END
-------------------------------------
CREATE PROC validate_users
@username nvarchar(15)

AS
BEGIN
	SELECT u_id, pass FROM users WHERE username = @username;
END
-------------------------------------
CREATE PROCEDURE update_details
@u_id int,
@email nvarchar(50),
@full_name nvarchar(max),
@bio nvarchar(150),
@gender nvarchar(9),
@loc nvarchar(20)

AS
BEGIN
	UPDATE users SET email = @email, full_name = @full_name, bio = @bio, gender = @gender, location = @loc WHERE u_id = @u_id;
END
-------------------------------------
CREATE PROCEDURE add_remove_follow
@user_id int,
@profile_id int,
@status nvarchar(10)

AS
BEGIN
	IF @status = 'follow'
		BEGIN
			INSERT INTO follows VALUES (@user_id, @profile_id);
			UPDATE users SET followers = followers + 1 WHERE u_id = @profile_id;
			UPDATE users SET followings = followings + 1 WHERE u_id = @user_id;
			INSERT INTO notifications (u_id, notif_text, link) SELECT @profile_id, username + ' started following you', '/Home/ViewProfile.aspx?u_id=' + CAST(@user_id AS nvarchar) FROM users WHERE u_id = @user_id
		END
		
	IF @status = 'unfollow'
		BEGIN
			DELETE FROM follows WHERE follower_id = @user_id AND following_id = @profile_id;
			UPDATE users SET followers = followers - 1 WHERE u_id = @profile_id;
			UPDATE users SET followings = followings - 1 WHERE u_id = @user_id;
		END
END
-------------------------------------
CREATE TABLE groups(
g_id int identity(1,1) primary key,
group_name nvarchar(50),
group_description nvarchar(150),
group_creation_date datetime,
creator_id int REFERENCES users(u_id),
no_of_members int,
admin_u_id int REFERENCES users(u_id),
no_of_moderators int,
group_visibility bit /*0 is private and 1 is public*/
)
-------------------------------------
CREATE TABLE group_members(
g_id int REFERENCES groups(g_id),
u_id int REFERENCES users(u_id),
PRIMARY KEY (u_id, g_id)
)
-------------------------------------
CREATE TABLE group_moderators(
g_id int REFERENCES groups(g_id),
u_id int REFERENCES users(u_id),
PRIMARY KEY (u_id, g_id)
)
-------------------------------------
CREATE TABLE group_posts(
p_id int identity(1,1) primary key,
g_id int REFERENCES groups(g_id),
u_id int REFERENCES users(u_id),
post nvarchar(max),
likes bigint,
dislikes bigint,
comments bigint,
shares bigint,
post_time datetime
)
-------------------------------------
CREATE PROC get_home_page_posts
@current_user int
AS
BEGIN
SELECT posts.p_id AS p_id, posts.u_id AS u_id, users.username AS username, posts.post AS post, users.profile_pic AS profile_pic, posts.likes AS likes, posts.dislikes AS dislikes, posts.comments AS comments, posts.shares AS shares, posts.post_time AS post_time,

CASE
	WHEN exists (SELECT reaction FROM reactions WHERE reactions.u_id = @current_user and reactions.p_id = posts.p_id) 
	THEN (SELECT reaction FROM reactions WHERE reactions.u_id = @current_user and reactions.p_id = posts.p_id)
	ELSE 'null'
	END AS LikeText,
	
CASE
	WHEN exists (SELECT * FROM shares WHERE shares.u_id = 1 and shares.p_id = posts.p_id)
	THEN 'Shared'
	ELSE 'null'
	END AS ShareText

FROM posts
JOIN follows ON posts.u_id = follows.following_id
JOIN users ON posts.u_id = users.u_id
WHERE follows.follower_id = @current_user 
ORDER BY posts.post_time DESC;
END
-------------------------------------
CREATE TABLE notifications(
notif_id int identity(1,1) primary key,
u_id int REFERENCES users(u_id),
notif_text nvarchar(max),
link nvarchar(max)
)
-------------------------------------
CREATE PROCEDURE check_user_existence
    @username NVARCHAR(15),
    @email NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM users WHERE username = @username)
    BEGIN
        SELECT -1;  -- Username already exists
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM users WHERE email = @email)
    BEGIN
        SELECT -2;  -- Email already exists
        RETURN;
    END

    SELECT 0;  -- Username and email do not exist
END;
-------------------------------------
CREATE PROCEDURE DeleteUser @user_id INT  
AS  
BEGIN  
    SET NOCOUNT ON;  

    -- Begin transaction for safety
    BEGIN TRANSACTION;

    -- Decrease follower count for users the deleted user was following
    UPDATE users  
    SET followers = followers - 1  
    WHERE u_id IN (SELECT following_id FROM follows WHERE follower_id = @user_id);

    -- Decrease following count for users who were following the deleted user
    UPDATE users  
    SET followings = followings - 1  
    WHERE u_id IN (SELECT follower_id FROM follows WHERE following_id = @user_id);

    -- Delete follows (both follower and following relations)
    DELETE FROM follows WHERE follower_id = @user_id OR following_id = @user_id;  

    -- Delete notifications related to the user
    DELETE FROM notifications WHERE u_id = @user_id;  

    -- Remove the user's reactions and update post like/dislike counts
    UPDATE posts  
    SET likes = likes - 1  
    WHERE p_id IN (SELECT p_id FROM reactions WHERE u_id = @user_id AND reaction = 'Liked');  

    UPDATE posts  
    SET dislikes = dislikes - 1  
    WHERE p_id IN (SELECT p_id FROM reactions WHERE u_id = @user_id AND reaction = 'Disliked');  

    DELETE FROM reactions WHERE u_id = @user_id;  

    -- Remove the user's shares and update post share counts
    UPDATE posts  
    SET shares = shares - 1  
    WHERE p_id IN (SELECT p_id FROM shares WHERE u_id = @user_id);  

    DELETE FROM shares WHERE u_id = @user_id;  

    -- Remove the user's comments and update post comment counts
    UPDATE posts  
    SET comments = comments - (SELECT COUNT(*) FROM comments WHERE p_id = posts.p_id AND u_id = @user_id)  
    WHERE p_id IN (SELECT p_id FROM comments WHERE u_id = @user_id);  

    DELETE FROM comments WHERE u_id = @user_id;  

    -- Delete the user's posts (will also remove related comments, reactions, and shares due to ON DELETE CASCADE)
    DELETE FROM posts WHERE u_id = @user_id;  

    -- Finally, delete the user
    DELETE FROM users WHERE u_id = @user_id;  

    -- Commit transaction
    COMMIT TRANSACTION;
END;
-------------------------------------
