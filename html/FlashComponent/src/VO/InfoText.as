package VO 
{
	/**
	 * ...
	 * @author sasky
	 */
	public class InfoText 
	{
		// state info
		private var _getting_and_processing_intial_data:String; 
		private var _ready_to_begin_dowmload:String; 
		private var _downloading_music:String;
		private var _making_archive:String ; 
		private var _ready_for_save:String ;  
		private var _saving_archive_to_disk:String;  
		private var _saved_archive_to_disk:String; 
		// errors
		//TODO
		public function InfoText(	getting_and_processing_intial_data:String ,
									ready_to_begin_dowmload:String ,
									downloading_music:String ,
									making_archive:String ,
									ready_for_save:String ,
									saving_archive_to_disk:String ,
									saved_archive_to_disk:String ):void
		{
			_getting_and_processing_intial_data = getting_and_processing_intial_data;
			_ready_to_begin_dowmload			= ready_to_begin_dowmload;
			_downloading_music					= downloading_music;
			_making_archive						= making_archive;
			_ready_for_save						= ready_for_save;
			_saving_archive_to_disk				= saving_archive_to_disk ; 
			_saved_archive_to_disk 				= saved_archive_to_disk;
			
		}
		
		public function get getting_and_processing_intial_data():String { return _getting_and_processing_intial_data; }
		
		public function get ready_to_begin_dowmload():String { return _ready_to_begin_dowmload; }
		
		public function get downloading_music():String { return _downloading_music; }
		
		public function get making_archive():String { return _making_archive; }
		
		public function get ready_for_save():String { return _ready_for_save; }
		
		public function get saving_archive_to_disk():String { return _saving_archive_to_disk; }
		
		public function get saved_archive_to_disk():String { return _saved_archive_to_disk; }
		
	}

}