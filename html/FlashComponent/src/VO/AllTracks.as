package VO 
{
	/**
	 * ...
	 * @author sasky
	 */
	public class AllTracks 
	{
		private var _id:int;
		private var _name:String;
		private var _url:String;
		private var _weightKb:int;
		/**
		 * Object for storing track data
		 * 
		 * @param id 			id of this track 
		 * @param name			name of the track exactly as it is named in its directly excluding the '.mp3' extension
		 * @param url 			relative url from the html page containing this file to the path of the mp3 file or 
		 * 						a absolute url as long as the mp3 files are on the same server
		 * @param weightKb		the approximate size in kilobytes of the mp3 file rounded to the nearest kb
		 */
			
		
		public function AllTracks(id:int, name:String , url:String, weightKb:int):void
		{
			_id = id;
			_name = name;
			_url = url;
			_weightKb = weightKb;
		}
		
		public function get id():int { return _id; }
		
		public function get name():String { return _name; }
		
		public function get url():String { return _url; }
		
		public function get weightKb():int { return _weightKb; }
	}

}