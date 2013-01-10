package ViewComponents 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author sasky
	 */
	public class TrackComponent extends Sprite 
	{
		
		private var _id:int;
		private var _progessBar:ProgressBar;
		private var _checkbox:CheckBox;
		private var _nameOfTrack:String;
		// postion vars 
		private var _Xoffset:Number = 10;
		
		public function TrackComponent(nameOfTrack:String , id:int ) 
		{
			_id = id; _nameOfTrack = nameOfTrack;
			//1.) track name
			var tf:TextField = new TextField();
			tf.text = _nameOfTrack;
			tf.width = 280;
			tf.x = _Xoffset; tf.y = 0;
			this.addChild(tf);
			//2.) Progress Bar
			_progessBar = new ProgressBar(200, 30, 0xff0000, 0x000000);
			_progessBar.x = _Xoffset ; _progessBar.y  = 25;
			this.addChild(_progessBar);
			//3.) checkBox
			_checkbox = new CheckBox(30, 0xff0000, 0x000000);
			_checkbox.x = 220 + _Xoffset; _checkbox.y = 25;
			this.addChild(_checkbox);
		}
		
		public function includeForDownload():Boolean 
		{ 
			return _checkbox.clicked;
		}
		
		public function get id():int{ return _id; }
		
		public function get nameOfTrack():String { return _nameOfTrack; }
		
		
		public function setDwonLoadPosition(pos:int):void
		{
			_progessBar.udateProgress(pos);
		}
		public function changeCheckBox(clicked:Boolean):void
		{
			_checkbox.changeState(clicked);
		}
	}

}