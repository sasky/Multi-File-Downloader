package 
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import deng.fzip.FZip;
	import Events.LoadDataEvent;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.media.Sound;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import nl.demonsters.debugger.MonsterDebugger;
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipOutput;
	import org.aszip.saving.Method;
	import org.aszip.zip.ASZip;
	import org.aszip.compression.CompressionMethod;
	import ViewComponents.CheckBox;
	import ViewComponents.DownloadBtn;
	import ViewComponents.InfoBox;
	import ViewComponents.ProgressBar;
	import ViewComponents.TrackComponent;
	import VO.AllTracks;
	import VO.DownLoadTracks;
	import VO.InfoText;
	
	/**
	 * ...
	 * @author sasky
	 */
	public class Main extends Sprite 
	{ 
		// states
		public static const GETTING_AND_PROCESSING_INTIAL_DATA:String = "getting and processing initial data";
		// array of objects containing info about the mp3 files needs to be loaded in as well as the helper/ error statements
		public static const READY_TO_BEGIN_DOWNLOAD:String = "ready to begin download";
		public static const DOWNLOADING_MUSIC:String = "downloading music";
		public static const MAKKING_ARCHIVE:String = "making archive";
		public static const READY_FOR_SAVE:String = "ready for save";
		public static const SAVING_ARCHIVE_TO_DISK:String = "saving archive to disk";
		public static const SAVED_ARCHIVE_TO_DISK:String = "saved archive to disk";
		// errors
		public static const INIT_DATA_FROM_SERVER_ERROR:String = "couldnt get json object from server";
		// TODO errors 
		private var _state :String;
		// vars
		private var _track_data_objects:Vector.<AllTracks>;
		private var _tracks_to_download:Vector.<AllTracks>;
		private var _info_text:InfoText;
		
		// old
		
		
		
		private var _trackComponents:Array;
		private var _tracksToDownload:Array;
		private var _bl:BulkLoader;
		private var _btn:DownloadBtn;
		private var _ba2:ByteArray;
		private var _infoBox:InfoBox;
		private var _downloadBtn:DownloadBtn;
		private var _savingProgressBar:ProgressBar;
		private var _saveBtn:DownloadBtn;
		private var _debugger:MonsterDebugger;
		
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			_state = GETTING_AND_PROCESSING_INTIAL_DATA;
			// button
			_saveBtn = new DownloadBtn("save");
			_saveBtn.disable();
			this.addChild(_saveBtn);
			//Debugger
			_debugger = new MonsterDebugger(this); 
			// load track data object
			try 
			{
				_track_data_objects = assignDataToAllTracks(loadDataFromServer());
				//TODO get info messages from server but for now lets just to this
				_info_text = new InfoText(		"Receiving your tracks from our server" , 
												"Selected the tracks you wish to download" , 
												"Your music is downloading", 
												"creating zip file" , "your tracks are ready! Press the Save button to save them to your hard drive", 
												"saving file, please wait", 
												"Saved successfully, enjoy the music!");
			}
			catch (error:Error) 
			{
				trace('couldnt get json object from server ' + error.message);
			}
			finally
			{
				DataReady();
			}
			
		}
		private function loadDataFromServer():Object
		{
			
			if (ExternalInterface.available)
			{
				var data:Object = ExternalInterface.call("getJsonData");
			
				if (!data) { throw new Error("not track data object from server") };
			}
			return data
		}
		private function assignDataToAllTracks(data:Object):Vector.<AllTracks>
		{
			var mv:Vector.<AllTracks> =  Vector.<AllTracks>([]);
			var a:Array= [];
			for each(var trackObject:Object in data)
			{
				mv.push( new AllTracks(trackObject.id , trackObject.name , trackObject.url , trackObject.weightKb));
				
			}
			
			return mv;
			
		}
		public function DataReady():void 
		{
			_state = READY_TO_BEGIN_DOWNLOAD;
			updateInfoBox();
			//MonsterDebugger.trace(this , _track_data_objects );
			// wait for download btn to be pressed
			if (ExternalInterface.available)
			{
				ExternalInterface.addCallback("downloadBtnClicked" , function(trackIds:Array):void
				{
					MonsterDebugger.trace(this , trackIds );
					startTheDownload(trackIds);
				});
			}
			
		}
		
		private function startTheDownload(trackIds:Array):void 
		{
			_state = DOWNLOADING_MUSIC;
			updateInfoBox();
		
			//get tracks to downLoad
			_tracks_to_download = Vector.<AllTracks>([]);
			_bl = new BulkLoader("bl");
			for each(var trackObject:AllTracks in _track_data_objects)
			{
				for (var i:int = 0 ; i < trackIds.length; i++ )
				{
					if (trackObject.id == trackIds[i])
					{ 
						// these will be the tracks to download
						_bl.add(trackObject.url , { id:trackObject.id , weight:trackObject.weightKb ,type:"binary"} );
						_bl.get(trackObject.id).addEventListener(ProgressEvent.PROGRESS, indProgress);
						_tracks_to_download.push(trackObject);
					}
				}
			}
			_bl.addEventListener(BulkProgressEvent.COMPLETE , onComplete);
			_bl.start();
		}
		private function indProgress(e:ProgressEvent):void 
		{
			MonsterDebugger.trace(this, "indProgress");
			var progress:int  =  Math.ceil((e.bytesLoaded / e.bytesTotal) * 100);
			if (ExternalInterface.available)
			{
				ExternalInterface.call("updateProgressBar" , progress , e.currentTarget.id );
			}
		}
		private function onComplete(e:BulkProgressEvent):void 
		{
			_state = MAKKING_ARCHIVE;
			updateInfoBox();
			// remove the listeners
			for (var k:int = 0 ; k < _bl.itemsTotal ; k++)
			{
				_bl.items[k].removeEventListener(ProgressEvent.PROGRESS, indProgress);
			}
			_bl.removeEventListener(BulkProgressEvent.COMPLETE , onComplete);
			
			
			var fzip:FZip = new FZip();
			// get data from loader
			for each(var trackObject:AllTracks in _tracks_to_download)
			{
				fzip.addFile(trackObject.name + ".mp3" ,ByteArray (_bl.getBinary(trackObject.id)));
			}
			
			_ba2 = getZippedData(fzip);
		}
		public function getZippedData(fzip:FZip):ByteArray 
		{
			try 
			{
				var ba:ByteArray  =new ByteArray();
				fzip.serialize(ba,false);
			}
			catch (error:Error) 
			{
				trace('An error occured while zipping : ' + error.message);
			}
			finally
			{
				saveBtnStage();
			}
			
			return ba;
		}	
		
		private function saveBtnStage():void 
		{
			_state = READY_FOR_SAVE;
			updateInfoBox();
			_saveBtn.enable();
			_saveBtn.addEventListener(MouseEvent.CLICK , onSaveBtnClick);
		}
	
		
		private function onSaveBtnClick(e:MouseEvent):void 
		{
			var fr:FileReference = new FileReference();
			fr.save(_ba2, "tracks.zip");
			fr.addEventListener(Event.COMPLETE , onsave);
			fr.addEventListener(ProgressEvent.PROGRESS , onSaveProgress);
			fr.addEventListener(IOErrorEvent.IO_ERROR , onsaveerror);
			_state = SAVING_ARCHIVE_TO_DISK;
			updateInfoBox();
			
		}
		
		private function onSaveProgress(e:ProgressEvent):void 
		{
			if (ExternalInterface.available)
			{
				var updateProgress:int = (int(Math.ceil((e.bytesLoaded / e.bytesTotal) * 100)));
				ExternalInterface.call("updateSaveProgressBar", updateProgress);
			}
		}
		private function onsaveerror(e:IOErrorEvent):void 
		{
			trace("save error");
		}
		private function onsave(e:Event):void 
		{
			_state = SAVED_ARCHIVE_TO_DISK;
			updateInfoBox();
			//var t:Timer = new Timer(5000, 1);
			//t.addEventListener(TimerEvent.TIMER_COMPLETE , reset);
			//t.start();
			
		}
		
		/*
		private function reset(e:TimerEvent):void 
		{
			e.currentTarget.removeEventListener(TimerEvent.TIMER_COMPLETE , reset);
			_state = READY_TO_BEGIN_DOWNLOAD;
			_savingProgressBar.udateProgress(0);
			updateInfoBox();
			_saveBtn.removeEventListener(MouseEvent.CLICK , onSaveBtnClick);
			_saveBtn.disable();
			
			_downloadBtn.addEventListener(MouseEvent.CLICK , onDownloadBtnClick);
			_downloadBtn.enable();
		}
		*/
		
		private function updateInfoBox():void
		{
			var message:String;
			
			switch (_state )
			{
				case GETTING_AND_PROCESSING_INTIAL_DATA :
				
					message = _info_text.getting_and_processing_intial_data;
					break

					
				case READY_TO_BEGIN_DOWNLOAD :
				
					message = _info_text.ready_to_begin_dowmload;
					break
					
				case DOWNLOADING_MUSIC :
				
					message = _info_text.downloading_music;
					break
					
				case MAKKING_ARCHIVE :
				
					message = _info_text.making_archive;
					break
					
				case READY_FOR_SAVE:
				
					message = _info_text.ready_for_save;
					break
					
				case SAVING_ARCHIVE_TO_DISK:
				
					message = _info_text.saving_archive_to_disk;
					break
					
				case SAVED_ARCHIVE_TO_DISK:
				
					message = _info_text.saved_archive_to_disk;
					break
					
			}
			if (ExternalInterface.available)
			{
				ExternalInterface.call("setInfoText" , message );
			}
		}
		
	}
	
}