package ViewComponents 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author sasky
	 */
	public class CheckBox extends Sprite 
	{
		private var _clicked:Boolean = false;
		private var _check:Shape;
		
		
		public function CheckBox(length:Number ,tickColour:uint , borderColour:uint):void 
		{
			var box:Sprite = new Sprite();
			box.graphics.lineStyle(2, borderColour);
			box.graphics.drawRect(0, 0, length , length);
			box.graphics.endFill();
			
			this.addChild(box);
			// hit area
			var ha:Sprite = new Sprite();
			ha.graphics.beginFill(0xffffff, 0);
			ha.graphics.drawRect(0, 0, length, length);
			ha.graphics.endFill();
			ha.buttonMode = true;
			this.addChild(ha);
			
			ha.addEventListener(MouseEvent.CLICK , onClick);
			
			_check = new Shape();
			_check.graphics.beginFill(tickColour);
			_check.graphics.moveTo(3, 15);
			_check.graphics.lineTo(8, 12);
			_check.graphics.lineTo(17, 21);
			_check.graphics.lineTo(38, -5);
			_check.graphics.lineTo(42, -1);
			_check.graphics.lineTo(18, 31);
			_check.graphics.endFill();
			_check.y = -3;
			_check.x = -2;
			_check.alpha = 0;
			this.addChild(_check);
			
			
			
		}
		public function get clicked():Boolean { return _clicked; }
		
		public function changeState(clicked:Boolean):void
		{
			_clicked  = clicked ? true: false;
			switchCheck(_clicked);
		}
		
		private function onClick(e:MouseEvent):void 
		{
			_clicked  = _clicked ? false : true;
			switchCheck(_clicked);
			
		}
		
		private function switchCheck(clicked:Boolean):void 
		{
			clicked ? _check.alpha = 1 : _check.alpha = 0;
		}
		
		
		
	}

}