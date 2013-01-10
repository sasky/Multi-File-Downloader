package ViewComponents 
{
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author sasky
	 */
	public class DownloadBtn extends Sprite 
	{
		private var _box:Sprite;
		private var _tf:TextField;
		private var _ha:Sprite;
		
		
		public function DownloadBtn(label:String ) 
		{
			_box = new Sprite();
			_box.graphics.beginFill(0x00ff00);
			_box.graphics.drawRect(0, 0, 80, 30);
			_box.graphics.endFill();
			this.addChild(_box);
			
			
			_tf = new TextField();
			_tf.text = label;
			_tf.selectable = false;
			_tf.width = 180;
			_tf.x = 10; _tf.y = 6;
			this.addChild(_tf);
			
			
			
			_ha = new Sprite();
			_ha.graphics.beginFill(0x00ff00,0);
			_ha.graphics.drawRect(0, 0, 80, 30);
			_ha.graphics.endFill();
			_ha.buttonMode = true;
			this.addChild(_ha);
			
			//this.buttonMode = true;
		}
		
		
		public function disable():void
		{
			
			_box.alpha = 0.1;
			_tf.alpha = 0.1;
			_ha.buttonMode = false;
			
		}
		public function enable():void
		{
			_box.alpha = 1;
			_tf.alpha = 1;
			_ha.buttonMode = true;
			
		}
		
	
		
	}

}