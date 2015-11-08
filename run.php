<?php
	
	// assumes local bitcoind/geth installed, uses regtest to generate a new block with an odd number
	// of transactions, sends the size proof to the etherum contract via call.js
	
	
	error_reporting(E_ALL);
	ini_set("display_errors", 1);
	
	function run_rpc($r) {
		$min_r = array('jsonrpc' => "1.0", 'id' => 'curltext', 'method' => 'getinfo', 'params' => array());
	
		$r = json_encode(array_merge($min_r, $r));
	    $ch = curl_init();
	
	    curl_setopt($ch, CURLOPT_URL, 'http://127.0.0.1');
	    curl_setopt($ch, CURLOPT_PORT, 18332);
	    curl_setopt($ch, CURLOPT_USERPWD, "bitcoinrpc:9bfD5YLm6k2dyX2ZBz1FaVBjJLzZehxNpKt1hUwTWE77");
	    curl_setopt($ch, CURLOPT_POST, 1);
	    //curl_setopt($ch, CURLOPT_VERBOSE, 1);
	    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	    curl_setopt($ch, CURLOPT_POSTFIELDS, $r);
	    curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-type: application/json', 'Content-length: '.strlen($r)));
	
	    $output = curl_exec($ch);
	    curl_close($ch);
	    
	    return json_decode($output);
	}
	
	function mempool_is_even_or_too_small() {
		// We need the merkle three with an odd number of transactions,
		// thus the mempool needs to be even before calling the block generator func.
		$t = run_rpc(array('method' => 'getmempoolinfo'));
		return $t->result->size == 0 || $t->result->size % 2 == 1 ? true : false;
	}
	
	function single_merkle($a, $b) {
		$a = implode('', array_reverse(str_split(hex2bin($a), 1)));
		$b = implode('', array_reverse(str_split(hex2bin($b), 1)));
		
		$m = hash('sha256', hash('sha256', $a . $b, true), true);
		$m = implode('', array_reverse(str_split($m, 1)));
		return implode('', unpack('H*', $m));
	}
	
	$address = 'mibYD4KqkbhaKhjULycZmjBkxjtm48UaRV';
	$min_log = 3;
	
	error_reporting(E_ALL);
	ini_set("display_errors", 1);
				
	foreach(range(0, 9) as $f)//rand(5, 11)
		run_rpc(array('method' => 'sendtoaddress', 'params' => array($address, 0.0001)));
		
	while(mempool_is_even_or_too_small())
		run_rpc(array('method' => 'sendtoaddress', 'params' => array($address, 0.0001)));
		
	$t = run_rpc(array('method' => 'generate', 'params' => array(1)));
	
	$t = run_rpc(array('method' => 'getblock', 'params' => array($t->result[0])));
	echo "\n\n-----\n\tLAST BLOCK:\n-----\n\n\n";
	var_dump($t);
		
	var_dump(count($t->result->tx));
	
	$levels = log(count($t->result->tx), 2);
	$txcount = count($t->result->tx);
	
	for($i = 0; $i < floor($levels); $i++)
		$ma[$i] = array();
	
	for($i = 0; $i < $txcount; $i+=2)
		$ma[floor($levels)][$i/2] = single_merkle($t->result->tx[$i], $t->result->tx[$i == $txcount - 1 ? $i : $i + 1]);
	
	for($l = floor($levels) - 1; $l >= 0; $l--)
	{
		for($llt = 0; $llt < pow(2, floor($l)); $llt++)
		{
			$lt=$llt*2;
			
			if(!isset($ma[$l+1][$lt]) && !isset($ma[$l+1][$lt+1]))
				break;
			
			if(!isset($ma[$l+1][$lt+1]))
				$ma[$l+1][$lt+1] = $ma[$l+1][$lt];
			
				
			$ma[$l][$lt/2] = single_merkle($ma[$l+1][$lt], $ma[$l+1][$lt+1]);
		}
	}
	echo "\n\n-----\n\tMERKLE TREE:\n-----\n\n\n";
	var_dump($ma);
		
	$return = array();
	
	
	
	$return[] = dechex(floor($levels)); //byte 0-255
	if(strlen($return[0]) == 1)
		$return[0] = '0' . dechex(floor($levels));

	$return[] = $t->result->tx[$txcount - 1];
	$return[] = '00';
	
	$node_id = $txcount - 1;
	
	for($l = floor($levels) - 1; $l >= 0; $l--)
	{
		$node_id = floor($node_id/2) % 2 == 0 ? floor($node_id/2) + 1 : floor($node_id/2) - 1;
		
		$return[] = $ma[$l+1][$node_id];
		$return[] = '0' . decbin(floor($node_id/2) % 2);
	}
	
	$return[] = $ma[0][0];
	$return[] = '00';
	
	//var_dump($return);
	$return = implode('', $return);
	
	echo "\n\n-----\n\tCALL.JS OUTPUT:\n-----\n\n\n";
	
	var_dump(exec("/usr/local/bin/node /w/call.js 0xd95318727df08c496d90dd158555dc5c27f60eb1 0x$return", $exec_output));
	var_dump($exec_output);