<?php

	/* -------------------------------- *
	 * | MARCOMAGE CONFIGURATION FILE | *
	 * -------------------------------- */

	// database configuration
	$server = "localhost";
	$username = "arcomage";
	$password = "";
	$database = "arcomage";

	// constants
	define("MAX_GAMES", 15);
	define("DECK_SLOTS", 8);
	define("GAME_SLOT_COST", 200); // bonus game slot cost
	define("DECK_SLOT_COST", 300); // bonus deck slot cost
	define("FOIL_COST", 500); // foil version card cost
	define("MESSAGE_LENGTH", 1000);
	define("CHALLENGE_LENGTH", 250);
	define("CHAT_LENGTH", 300); // chat message length
	define("SYSTEM_NAME", "MArcomage"); // user name for system notification
	define("NUM_THREADS", 4); // number of threads per section in the forum main page
	define("THREADS_PER_PAGE", 30);
	define("POSTS_PER_PAGE", 20);
	define("POST_LENGTH", 4000);
	define("PLAYERS_PER_PAGE", 50);
	define("MESSAGES_PER_PAGE", 15);
	define("CARDS_PER_PAGE", 20);
	define("DECKS_PER_PAGE", 30);
	define("EFFECT_LENGTH", 500);
	define("HOBBY_LENGTH", 300);
	define("REPLAYS_PER_PAGE", 20); // game replays

	// game configuration
	// normal mode
	$game_config['normal']['init_tower'] = 30; // starting tower height
	$game_config['normal']['max_tower'] = 100; // maximum tower height
	$game_config['normal']['init_wall'] = 25; // starting wall height
	$game_config['normal']['max_wall'] = 150; // maximum wall height
	$game_config['normal']['res_victory'] = 400; // sum of all resources
	$game_config['normal']['time_victory'] = 250; // maximum number of rounds

	// long mode
	$game_config['long']['init_tower'] = 45; // starting tower height
	$game_config['long']['max_tower'] = 150; // maximum tower height
	$game_config['long']['init_wall'] = 38; // starting wall height
	$game_config['long']['max_wall'] = 225; // maximum wall height
	$game_config['long']['res_victory'] = 600; // sum of all resources
	$game_config['long']['time_victory'] = 375; // maximum number of rounds

?>
