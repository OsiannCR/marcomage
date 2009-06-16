<?php

	/* --------------------------- *
	 * | MARCOMAGE ACCESS RIGHTS | *
	 * --------------------------- */

	$admin_rights = array(
	"create_post" => true, 
	"create_thread" => true, 
	"del_all_post" => true, 
	"del_all_thread" => true, 
	"lock_thread" => true, 
	"edit_own_post" => true, 
	"edit_all_post" => true, 
	"edit_all_thread" => true, 
	"edit_own_thread" => true, 
	"move_post" => true, 
	"move_thread" => true, 
	"chng_priority" => true, 
	"messages" => true, 
	"chat" => true, 
	"create_card" => true, 
	"edit_own_card" => true, 
	"edit_all_card" => true, 
	"delete_own_card" => true, 
	"delete_all_card" => true, 
	"send_challenges" => true, 
	"accept_challenges" => true, 
	"change_own_avatar" => true, 
	"change_all_avatar" => true, 
	"login" => true,
	"see_all_messages" => true, 
	"system_notification" => true, 
	"change_rights" => true);
	
	$moderator_rights = array(
	"create_post" => true, 
	"create_thread" => true, 
	"del_all_post" => true, 
	"del_all_thread" => true, 
	"lock_thread" => true, 
	"edit_own_post" => true, 
	"edit_all_post" => true, 
	"edit_all_thread" => true, 
	"edit_own_thread" => true, 
	"move_post" => true, 
	"move_thread" => true, 
	"chng_priority" => true, 
	"messages" => true, 
	"chat" => true, 
	"create_card" => true, 
	"edit_own_card" => true, 
	"edit_all_card" => true, 
	"delete_own_card" => true, 
	"delete_all_card" => true, 
	"send_challenges" => true, 
	"accept_challenges" => true, 
	"change_own_avatar" => true, 
	"change_all_avatar" => false, 
	"login" => true,
	"see_all_messages" => false, 
	"system_notification" => false, 
	"change_rights" => false);
	
	$user_rights = array(
	"create_post" => true, 
	"create_thread" => true, 
	"del_all_post" => false, 
	"del_all_thread" => false, 
	"lock_thread" => false, 
	"edit_own_post" => true, 
	"edit_all_post" => false, 
	"edit_all_thread" => false, 
	"edit_own_thread" => true, 
	"move_post" => false, 
	"move_thread" => false, 
	"chng_priority" => false, 
	"messages" => true, 
	"chat" => true, 
	"create_card" => true, 
	"edit_own_card" => true, 
	"edit_all_card" => false, 
	"delete_own_card" => true, 
	"delete_all_card" => false, 
	"send_challenges" => true, 
	"accept_challenges" => true, 
	"change_own_avatar" => true, 
	"change_all_avatar" => false, 
	"login" => true,
	"see_all_messages" => false, 
	"system_notification" => false, 
	"change_rights" => false);
	
	$squashed_rights = array(
	"create_post" => true, 
	"create_thread" => false, 
	"del_all_post" => false, 
	"del_all_thread" => false, 
	"lock_thread" => false, 
	"edit_own_post" => false, 
	"edit_all_post" => false, 
	"edit_all_thread" => false, 
	"edit_own_thread" => false, 
	"move_post" => false, 
	"move_thread" => false, 
	"chng_priority" => false, 
	"messages" => true, 
	"chat" => true, 
	"create_card" => false, 
	"edit_own_card" => false, 
	"edit_all_card" => false, 
	"delete_own_card" => false, 
	"delete_all_card" => false, 
	"send_challenges" => false, 
	"accept_challenges" => true, 
	"change_own_avatar" => false, 
	"change_all_avatar" => false, 
	"login" => true,
	"see_all_messages" => false, 
	"system_notification" => false, 
	"change_rights" => false);
	
	$limited_rights = array(
	"create_post" => false, 
	"create_thread" => false, 
	"del_all_post" => false, 
	"del_all_thread" => false, 
	"lock_thread" => false, 
	"edit_own_post" => false, 
	"edit_all_post" => false, 
	"edit_all_thread" => false, 
	"edit_own_thread" => false, 
	"move_post" => false, 
	"move_thread" => false, 
	"chng_priority" => false, 
	"messages" => true, 
	"chat" => false, 
	"create_card" => false, 
	"edit_own_card" => false, 
	"edit_all_card" => false, 
	"delete_own_card" => false, 
	"delete_all_card" => false, 
	"send_challenges" => false, 
	"accept_challenges" => true, 
	"change_own_avatar" => false, 
	"change_all_avatar" => false, 
	"login" => true,
	"see_all_messages" => false, 
	"system_notification" => false, 
	"change_rights" => false);
	
	$banned_rights = array(
	"create_post" => false, 
	"create_thread" => false, 
	"del_all_post" => false, 
	"del_all_thread" => false, 
	"lock_thread" => false, 
	"edit_own_post" => false, 
	"edit_all_post" => false, 
	"edit_all_thread" => false, 
	"edit_own_thread" => false, 
	"move_post" => false, 
	"move_thread" => false, 
	"chng_priority" => false, 
	"messages" => false, 
	"chat" => false, 
	"create_card" => false, 
	"edit_own_card" => false, 
	"edit_all_card" => false, 
	"delete_own_card" => false, 
	"delete_all_card" => false, 
	"send_challenges" => false, 
	"accept_challenges" => false, 
	"change_own_avatar" => false, 
	"change_all_avatar" => false, 
	"login" => false,
	"see_all_messages" => false, 
	"system_notification" => false, 
	"change_rights" => false);
	
	$access_rights = array(
	"admin" => $admin_rights, 
	"moderator" => $moderator_rights, 
	"user" => $user_rights, 
	"squashed" => $squashed_rights, 
	"limited" => $limited_rights, 
	"banned" => $banned_rights);

?>
