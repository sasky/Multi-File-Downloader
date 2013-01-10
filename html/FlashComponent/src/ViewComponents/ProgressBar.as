package ViewComponents 
{
	
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author sasky
	 */
	public class ProgressBar extends Sprite 
	{
		private var _progress:Number;
		private var _inset:Number = 3;
		private var _progessShape:Shape;
		public function ProgressBar(length:Number , width:Number, colour:uint,borderColour:uint):void 
		{
			var border:Shape = new Shape();
			border.graphics.lineStyle(2, borderColour);
			border.graphics.drawRect(0, 0, length, width  );
			border.graphics.endFill();
			this.addChild(border);
			
			_progessShape = new Shape();
			_progessShape.graphics.beginFill(colour);
			_progessShape.graphics.drawRect(0 + _inset, 0 +_inset, length - (_inset*2) , width - (_inset*2) );
			_progessShape.graphics.endFill();
			_progessShape.scaleX = 0;
			this.addChild(_progessShape );
		}
		public function udateProgress(progress:Number):void
		{
			if (progress > 0 && progress <= 100)
			{
				_progessShape.scaleX = progress / 100;
				
			}
		}
		
	}

}