package ViewComponents 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	/**
	 * ...
	 * @author sasky
	 */
	public class InfoBox extends Sprite
	{
		private var _box:Sprite;
		private var _tf:TextField;
		//private var _message:String;
		public function InfoBox() 
		{
			_box = new Sprite();
			_box.graphics.beginFill(0xfff1ac);
			_box.graphics.drawRect(0, 0, 165, 130);
			_box.graphics.endFill();
			this.addChild(_box);
			
			
			_tf = new TextField();
			
			//_tf.selectable = false;
			_tf.multiline = true;
			_tf.wordWrap = true;
			_tf.width = 120;
			_tf.height = 95;
			_tf.x = 10; _tf.y = 6;
			this.addChild(_tf);
		}
		public function updateMessage(message:String):void
		{
			_tf.text = message;
		}
		
	}

}