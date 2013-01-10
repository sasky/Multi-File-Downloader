package  
{
	/**
	 * ...
	 * @author sasky
	 */
	public class DataObject 
	{
		public var id:int;
		public var name:String;
		public var url:String;
		public var weightKb:int;
		public function DataObject(id:int, name:String , url:String,weightKb:int):void
		{
			this.id = id;
			this.name = name;
			this.url = url;
			this.weightKb = weightKb;
		}
		
		
	}

}