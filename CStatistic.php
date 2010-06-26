<?php
/*
	CStatistics - statistics module
*/
?>
<?php
	class CStatistics
	{
		private $db;

		public function __construct(CDatabase &$database)
		{
			$this->db = &$database;
		}

		public function GetDB()
		{
			return $this->db;
		}

		public function SuggestedConcepts() // calculate top 10 concept authors for suggested concepts
		{
			$db = $this->db;
			$statistics = array();

			$result = $db->Query('SELECT `Author`, COUNT(`Author`) as `count` FROM `concepts` WHERE (`State` = "waiting") OR (`State` = "interesting") GROUP BY `Author` ORDER BY `count` DESC, `Author` ASC LIMIT 0, 10');

			if (!$result) return false;

			while( $data = $result->Next() ) $statistics[] = $data;

			return $statistics;
		}

		public function ImplementedConcepts() // calculate top 10 concept authors for implemented concepts
		{
			$db = $this->db;
			$statistics = array();

			$result = $db->Query('SELECT `Author`, COUNT(`Author`) as `count` FROM `concepts` WHERE `State` = "implemented" GROUP BY `Author` ORDER BY `count` DESC, `Author` ASC LIMIT 0, 10');

			if (!$result) return false;

			while( $data = $result->Next() ) $statistics[] = $data;

			return $statistics;
		}

		public function VictoryTypes() // calculate game victory types statistics
		{
			$db = $this->db;

			// fill statistics with default values
			$statistics = array('Construction', 'Destruction', 'Resource', 'Timeout', 'Draw', 'Surrender', 'Abort', 'Abandon');
			$statistics = array_combine($statistics, array_fill(0, count($statistics), 0));

			// get number of different victory types
			$result = $db->Query('SELECT `EndType`, COUNT(`EndType`) as `count` FROM `replays_head` WHERE (`EndType` != "Pending") GROUP BY `EndType`');

			if (!$result) return false;

			while( $data = $result->Next() ) $statistics[$data['EndType']] = $data['count'];

			// get number of total games games
			$result = $db->Query('SELECT COUNT(`GameID`) as `total` FROM `replays_head` WHERE (`EndType` != "Pending")');

			if (!$result) return false;
			if (!$result->Rows()) return false;

			$data = $result->Next();
			$total_games = $data['total'];
			$rounded = array();
			$i = 0;

			// calculate percentage, restructure data
			foreach ($statistics as $statistic => $value)
			{
				$rounded[$i]['type'] = $statistic;
				$rounded[$i]['count'] = ($total_games > 0) ? round(($value / $total_games) * 100, 2) : 0;
				$i++;
			}

			return $rounded;
		}

		public function GameModes() // calculate game modes statistics
		{
			$db = $this->db;

			// get number of hidden card games
			$result = $db->Query('SELECT COUNT(`GameID`) as `hidden` FROM `replays_head` WHERE (`EndType` != "Pending") AND (FIND_IN_SET("HiddenCards", `GameModes`) > 0)');

			if (!$result) return false;
			if (!$result->Rows()) return false;

			$data = $result->Next();
			$statistics['hidden'] = $data['hidden'];

			// get number of friendly play games
			$result = $db->Query('SELECT COUNT(`GameID`) as `friendly` FROM `replays_head` WHERE (`EndType` != "Pending") AND (FIND_IN_SET("FriendlyPlay", `GameModes`) > 0)');

			if (!$result) return false;
			if (!$result->Rows()) return false;

			$data = $result->Next();
			$statistics['friendly'] = $data['friendly'];

			// get number of total games games
			$result = $db->Query('SELECT COUNT(`GameID`) as `total` FROM `replays_head` WHERE (`EndType` != "Pending")');

			if (!$result) return false;
			if (!$result->Rows()) return false;

			$data = $result->Next();
			$total_games = $data['total'];

			// calculate percentage
			foreach ($statistics as $statistic => $value) $statistics[$statistic] = round(($value / $total_games) * 100, 2);

			return $statistics;
		}

		public function VersusStats($player1, $player2) // calculate versus statistics for the two specified players from player1 perspecive
		{
			$db = $this->db;
			$statistics = array();

			// wins statistics
			$result = $db->Query('SELECT `EndType`, COUNT(`EndType`) as `count` FROM `replays_head` WHERE (`EndType` != "Pending") AND ((`Player1` = "'.$db->Escape($player1).'" AND `Player2` = "'.$db->Escape($player2).'") OR (`Player1` = "'.$db->Escape($player2).'" AND `Player2` = "'.$db->Escape($player1).'")) AND `Winner` = "'.$db->Escape($player1).'" GROUP BY `EndType` ORDER BY `count` DESC');

			if (!$result) return false;
			$wins_total = 0;

			if ($result->Rows())
			{
				while( $data = $result->Next() )
				{
					$statistics['wins'][] = $data;
					$wins_total+= $data['count'];
				}

				// calculate percentage
				foreach ($statistics['wins'] as $i => $data) $statistics['wins'][$i]['ratio'] = round(($data['count'] / $wins_total) * 100, 1);
			}
			$statistics['wins_total'] = $wins_total;

			// loss statistics
			$result = $db->Query('SELECT `EndType`, COUNT(`EndType`) as `count` FROM `replays_head` WHERE (`EndType` != "Pending") AND ((`Player1` = "'.$db->Escape($player1).'" AND `Player2` = "'.$db->Escape($player2).'") OR (`Player1` = "'.$db->Escape($player2).'" AND `Player2` = "'.$db->Escape($player1).'")) AND `Winner` = "'.$db->Escape($player2).'" GROUP BY `EndType` ORDER BY `count` DESC');

			if (!$result) return false;
			$losses_total = 0;

			if ($result->Rows())
			{
				while( $data = $result->Next() )
				{
					$statistics['losses'][] = $data;
					$losses_total+= $data['count'];
				}

				// calculate percentage
				foreach ($statistics['losses'] as $i => $data) $statistics['losses'][$i]['ratio'] = round(($data['count'] / $losses_total) * 100, 1);
			}
			$statistics['losses_total'] = $losses_total;

			// other statistics (draws, aborts...)
			$result = $db->Query('SELECT `EndType`, COUNT(`EndType`) as `count` FROM `replays_head` WHERE (`EndType` != "Pending") AND ((`Player1` = "'.$db->Escape($player1).'" AND `Player2` = "'.$db->Escape($player2).'") OR (`Player1` = "'.$db->Escape($player2).'" AND `Player2` = "'.$db->Escape($player1).'")) AND `Winner` = "" GROUP BY `EndType` ORDER BY `count` DESC');

			if (!$result) return false;
			$other_total = 0;

			if ($result->Rows())
			{
				while( $data = $result->Next() )
				{
					$statistics['other'][] = $data;
					$other_total+= $data['count'];
				}

				// calculate percentage
				foreach ($statistics['other'] as $i => $data) $statistics['other'][$i]['ratio'] = round(($data['count'] / $other_total) * 100, 2);
			}

			$statistics['other_total'] = $other_total;

			// average game duration
			$result = $db->Query('SELECT ROUND(IFNULL(AVG(`Turns`), 0), 1) as `Turns`, ROUND(IFNULL(AVG(`Rounds`), 0), 1) as `Rounds` FROM `replays_head` WHERE (`EndType` != "Pending") AND ((`Player1` = "'.$db->Escape($player1).'" AND `Player2` = "'.$db->Escape($player2).'") OR (`Player1` = "'.$db->Escape($player2).'" AND `Player2` = "'.$db->Escape($player1).'"))');

			if (!$result) return false;

			$data = $result->Next();
			$statistics['turns'] = $data['Turns'];
			$statistics['rounds'] = $data['Rounds'];

			return $statistics;
		}

		public function GameStats($player) // calculate overall game statistics for the specified player
		{
			$db = $this->db;
			$statistics = array();

			// wins statistics
			$result = $db->Query('SELECT `EndType`, COUNT(`EndType`) as `count` FROM `replays_head` WHERE (`EndType` != "Pending") AND (`Player1` = "'.$db->Escape($player).'" OR `Player2` = "'.$db->Escape($player).'") AND `Winner` = "'.$db->Escape($player).'" GROUP BY `EndType` ORDER BY `count` DESC');

			if (!$result) return false;
			$wins_total = 0;

			if ($result->Rows())
			{
				while( $data = $result->Next() )
				{
					$statistics['wins'][] = $data;
					$wins_total+= $data['count'];
				}

				// calculate percentage
				foreach ($statistics['wins'] as $i => $data) $statistics['wins'][$i]['ratio'] = round(($data['count'] / $wins_total) * 100, 1);
			}
			$statistics['wins_total'] = $wins_total;

			// loss statistics
			$result = $db->Query('SELECT `EndType`, COUNT(`EndType`) as `count` FROM `replays_head` WHERE (`EndType` != "Pending") AND (`Player1` = "'.$db->Escape($player).'" OR `Player2` = "'.$db->Escape($player).'") AND `Winner` != "'.$db->Escape($player).'" AND `Winner` != "" GROUP BY `EndType` ORDER BY `count` DESC');

			if (!$result) return false;
			$losses_total = 0;

			if ($result->Rows())
			{
				while( $data = $result->Next() )
				{
					$statistics['losses'][] = $data;
					$losses_total+= $data['count'];
				}

				// calculate percentage
				foreach ($statistics['losses'] as $i => $data) $statistics['losses'][$i]['ratio'] = round(($data['count'] / $losses_total) * 100, 1);
			}
			$statistics['losses_total'] = $losses_total;

			// other statistics (draws, aborts...)
			$result = $db->Query('SELECT `EndType`, COUNT(`EndType`) as `count` FROM `replays_head` WHERE (`EndType` != "Pending") AND (`Player1` = "'.$db->Escape($player).'" OR `Player2` = "'.$db->Escape($player).'") AND `Winner` = "" GROUP BY `EndType` ORDER BY `count` DESC');

			if (!$result) return false;
			$other_total = 0;

			if ($result->Rows())
			{
				while( $data = $result->Next() )
				{
					$statistics['other'][] = $data;
					$other_total+= $data['count'];
				}

				// calculate percentage
				foreach ($statistics['other'] as $i => $data) $statistics['other'][$i]['ratio'] = round(($data['count'] / $other_total) * 100, 2);
			}

			$statistics['other_total'] = $other_total;

			// average game duration
			$result = $db->Query('SELECT ROUND(IFNULL(AVG(`Turns`), 0), 1) as `Turns`, ROUND(IFNULL(AVG(`Rounds`), 0), 1) as `Rounds` FROM `replays_head` WHERE (`EndType` != "Pending") AND (`Player1` = "'.$db->Escape($player).'" OR `Player2` = "'.$db->Escape($player).'")');

			if (!$result) return false;

			$data = $result->Next();
			$statistics['turns'] = $data['Turns'];
			$statistics['rounds'] = $data['Rounds'];

			return $statistics;
		}

		public function Skins() // calculate skin related statistics
		{
			$db = $this->db;

			// get skins data from external file
			$skin_db = new SimpleXMLElement('templates/skins.xml', 0, TRUE);
			$skin_db->registerXPathNamespace('am', 'http://arcomage.netvor.sk');
			$skins_data = $skin_db->xpath("/am:skins/am:skin");
			$skins = array();

			foreach ($skins_data as $skin) // fill array with default values for all skins
			{
				$skin_id = (int)$skin->value;
				$skins[$skin_id]['name'] = (string)$skin->name;
				$skins[$skin_id]['count'] = 0;
			}

			$total = 0; // total number of skins
			
			// get number of different skins (only active and offline players are taken into account)
			$result = $db->Query('SELECT `Skin`, COUNT(`Skin`) as `count` FROM `settings` JOIN `logins` USING (`Username`) WHERE (UNIX_TIMESTAMP(`Last Query`) >= UNIX_TIMESTAMP() - 60*60*24*7*1) GROUP BY `Skin`');

			if (!$result) return false;
			if (!$result->Rows()) return false;

			while( $data = $result->Next() )
			{
				$skins[$data['Skin']]['count'] = $data['count'];
				$total+= $data['count'];
			}

			// calculate percentage
			foreach ($skins as $skin_id => $skin) $skins[$skin_id]['count'] = round(($skin['count'] / $total) * 100, 2);

			return $skins;
		}

		public function Backgrounds() // calculate background related statistics
		{
			$db = $this->db;

			// get backgrounds data from external file
			$bg_db = new SimpleXMLElement('templates/backgrounds.xml', 0, TRUE);
			$bg_db->registerXPathNamespace('am', 'http://arcomage.netvor.sk');
			$bg_data = $bg_db->xpath("/am:backgrounds/am:background");
			$backgrounds = array();

			foreach ($bg_data as $background) // fill array with default values for all backgrounds
			{
				$bg_id = (int)$background->value;
				$backgrounds[$bg_id]['name'] = (string)$background->name;
				$backgrounds[$bg_id]['count'] = 0;
			}

			$total = 0; // total number of backgrounds

			// get number of different backgrounds (only active and offline players are taken into account)
			$result = $db->Query('SELECT `Background`, COUNT(`Background`) as `count` FROM `settings` JOIN `logins` USING (`Username`) WHERE (UNIX_TIMESTAMP(`Last Query`) >= UNIX_TIMESTAMP() - 60*60*24*7*1) GROUP BY `Background`');

			if (!$result) return false;
			if (!$result->Rows()) return false;

			while( $data = $result->Next() )
			{
				$backgrounds[$data['Background']]['count'] = $data['count'];
				$total+= $data['count'];
			}

			// calculate percentage
			foreach ($backgrounds as $bg_id => $background) $backgrounds[$bg_id]['count'] = round(($background['count'] / $total) * 100, 2);

			return $backgrounds;
		}

		public function Cards($condition, $list_size) // calculate card statistics according to specified paramaters
		{
			global $carddb;

			$db = $this->db;
			$result = $db->Query('SELECT `CardID` FROM `statistics` WHERE `CardID` > 0 ORDER BY `'.$db->Escape($condition).'` DESC, `CardID` ASC');
			if (!$result) return false;

			$cards = array();
			while( $data = $result->Next() )
				$cards[] = $data['CardID'];

			$cards_data = $carddb->GetData($cards);
			$separated = array('Common' => array(), 'Uncommon' => array(), 'Rare' => array());
			$statistics = array(
			'Common' => array('top' => array(), 'bottom' => array()), 
			'Uncommon' => array('top' => array(), 'bottom' => array()), 
			'Rare' => array('top' => array(), 'bottom' => array()));

			// separate card list by card rarity
			foreach ($cards_data as $data) $separated[$data['class']][] = $data;

			// make top and bottom lists for each rarity type
			foreach ($separated as $rarity => $list)
			{
				$statistics[$rarity]['top'] = ($list_size == 'full') ? $list : array_slice($list, 0, $list_size);
				$statistics[$rarity]['bottom'] = ($list_size == 'full') ? array_reverse($list) : array_slice(array_reverse($list), 0, $list_size);
			}

			return $statistics;
		}

		public function CardStatistics($card_id) // return statistics for specified card
		{
			$db = $this->db;
			$result = $db->Query('SELECT `Played`, `Discarded`, `Drawn`, `PlayedTotal`, `DiscardedTotal`, `DrawnTotal` FROM `statistics` WHERE `CardID` = "'.$db->Escape($card_id).'"');
			if (!$result) return false;
			if (!$result->Rows()) $data = array('Played' => 0, 'Discarded' => 0, 'Drawn' => 0, 'PlayedTotal' => 0, 'DiscardedTotal' => 0, 'DrawnTotal' => 0);
			else $data = $result->Next();

			return $data;
		}

		public function UpdateCardStats($card_id, $action) // update card statistics (used when card is played, drawn or discarded)
		{
			$db = $this->db;

			if ($action == "play") $action_q = 'Played';
			elseif ($action == "discard") $action_q = 'Discarded';
			elseif ($action == "draw") $action_q = 'Drawn';
			else return false; // invalid action

			// check if the card is already present in the database
			$result = $db->Query('SELECT 1 FROM `statistics` WHERE `CardID` = "'.$card_id.'"');

			if (!$result) return false;
			if (!$result->Rows()) // add new record when necessary
			{
				$result = $db->Query('INSERT INTO `statistics` (`CardID`) VALUES ("'.$card_id.'")');
				if (!$result) return false;
			}

			// update card statistics
			$result = $db->Query('UPDATE `statistics` SET `'.$action_q.'` = `'.$action_q.'` + 1, `'.$action_q.'Total` = `'.$action_q.'Total` + 1 WHERE `CardID` = "'.$card_id.'"');
			if (!$result) return false;

			return true;
		}
	}
?>
