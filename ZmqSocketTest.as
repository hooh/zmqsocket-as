/*
	Copyright (c) 2011 by Artur Brugeman
	License: GNU GPL v3
*/

package
{
	import flash.display.Sprite;
	import flash.text.*;
	import flash.events.*;
	import ZmqSocket;
	
	public class ZmqSocketTest extends Sprite
	{
		
		public function ZmqSocketTest ()
		{
			var input: TextField = new TextField;
			input.type = TextFieldType.INPUT;
			input.background = true;
			input.border = true;
			input.width = 350;
			input.height = 350;
			addChild (input);
			input.appendText ("Starting\n");
			
			try
			{
				var socket: ZmqSocket = new ZmqSocket ();
			}
			catch (e: Error)
			{
				input.appendText ("Error: " + e.toString ());
				return;
			}

			socket.addEventListener (Event.CONNECT, function (e: Event) 
				{
					input.appendText ("connected!\n");
				});
			
			socket.addEventListener (ZmqSocket.OPEN, function (e: Event)
				{
					input.appendText ("opened\n");
					socket.send (["", "Test"]);
				});

			socket.addEventListener (ZmqSocket.MESSAGE, function (e: Event)
				{
					var msg: Array = socket.recv ();
					input.appendText (msg.length + "\n");
					if (msg.length > 1)
						input.appendText (msg[1] + "\n");

					socket.send (["", "Test"]);
				});

			socket.addEventListener (Event.CLOSE, function (e: Event)
				{
					input.appendText ("closed\n");
				});

			socket.addEventListener (IOErrorEvent.IO_ERROR, function (e: IOErrorEvent)
				{
					input.appendText (e.toString ()+"\n");
				});

			socket.addEventListener (SecurityErrorEvent.SECURITY_ERROR, function (e: SecurityErrorEvent)
				{
					input.appendText (e.toString ()+"\n");
				});

			socket.connect ("localhost", 5555);
		}
	}
}