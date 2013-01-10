package  
{
	import com.adobe.serialization.json.JSON;
	import Events.LoadDataEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import com.adobe.serialization.json.JSON;
	import nl.demonsters.debugger.MonsterDebugger;
	import VO.AllTracks;
	import VO.InfoText;
	
	/**
	 * ...
	 * @author sasky
	 */
	public class LoadData 
	{
		public var _allTracksData:Vector.<AllTracks>;
		private var _infoTextData:InfoText;
		private var _dataReady:Boolean = false;
		private var _debugger:MonsterDebugger;
		public var data:Object;
		private var _main:Main;
		
		
		public function LoadData(m:Main):void
		{

			
			_main = m
			_allTracksData  = assignDataToAllTracks(loadDataFromServer());
			_infoTextData = tempInfoText();
			dataReady();
		}
		
		private function assignDataToAllTracks(data:Object):Vector.<AllTracks>
		{
			var mv:Vector.<AllTracks> =  Vector.<AllTracks>([]);
			var a:Array= [];
			for each(var trackObject:Object in data)
			{
				mv.push( new AllTracks(trackObject.id , trackObject.name , trackObject.url , trackObject.weightKb));
				a.push( new AllTracks(trackObject.id , trackObject.name , trackObject.url , trackObject.weightKb));
			}
			
			return mv;
			
		}
		
		private function tempData():void 
		{
			_allTracksData = tempMusic();
			_infoTextData = tempInfoText();
			
		}
		private function tempMusic():Vector.<AllTracks>
		{
			var mv:Vector.<AllTracks> =  Vector.<AllTracks>([
			/*
					new AllTracks(15 , "How Circumcision Works" , "../music/How Circumcision Works.mp3",1410) ,
						new AllTracks(16 , "How the Rules of War Work" , "../music/How the Rules of War Work.mp3",1180) ,
						new AllTracks(17, "Sole-Plutonium" , "../music/Sole-Plutonium.mp3",672) ,
						new AllTracks(18 , "The MySpace Story (So Far)" , "../music/The MySpace Story (So Far).mp3",1150) ,
				*/		
						new AllTracks(1 , "01 Zero" , "../music/2009 - It's Blitz! (Deluxe Version)/01 Zero.mp3",819) ,
						new AllTracks(2 , "02 Heads Will Roll" , "../music/2009 - It's Blitz! (Deluxe Version)/02 Heads Will Roll.mp3",682) ,
						new AllTracks(3 , "03 Soft Shock" , "../music/2009 - It's Blitz! (Deluxe Version)/03 Soft Shock.mp3",719) ,
						new AllTracks(4 , "04 Skeletons" , "../music/2009 - It's Blitz! (Deluxe Version)/04 Skeletons.mp3",930) ,
						new AllTracks(5 , "05 Dull Life" , "../music/2009 - It's Blitz! (Deluxe Version)/05 Dull Life.mp3", 766) /*,
						
						new AllTracks(6 , "06 Shame And Fortune" , "../music/2009 - It's Blitz! (Deluxe Version)/06 Shame And Fortune.mp3",653) ,
						new AllTracks(7 , "07 Runaway" , "../music/2009 - It's Blitz! (Deluxe Version)/07 Runaway.mp3",964) ,
						new AllTracks(8 , "08 Dragon Queen" , "../music/2009 - It's Blitz! (Deluxe Version)/08 Dragon Queen.mp3",746) ,
						new AllTracks(9 , "09 Hysteric" , "../music/2009 - It's Blitz! (Deluxe Version)/09 Hysteric.mp3",710) ,
						new AllTracks(10 , "10 Little Shadow" , "../music/2009 - It's Blitz! (Deluxe Version)/10 Little Shadow.mp3",728) ,
						new AllTracks(11 , "11 Soft Shock (acoustic)" , "../music/2009 - It's Blitz! (Deluxe Version)/11 Soft Shock (acoustic).mp3",633) ,
						new AllTracks(12 , "12 Skeletons (acoustic)" , "../music/2009 - It's Blitz! (Deluxe Version)/12 Skeletons (acoustic).mp3",648) ,
						new AllTracks(13 , "13 Hysteric (acoustic)" , "../music/2009 - It's Blitz! (Deluxe Version)/13 Hysteric (acoustic).mp3",714) ,
						new AllTracks(14 , "14 Little Shadow (acoustic)" , "../music/2009 - It's Blitz! (Deluxe Version)/14 Little Shadow (acoustic).mp3", 537)*/ ]);
			return mv;
		}
		
		private function tempInfoText():InfoText
		{
			var inftxt:InfoText = new InfoText(	"Receiving your tracks from our server" , 
												"Selected the tracks you wish to download" , 
												"Your music is downloading", 
												"creating zip file" , "your tracks are ready! Press the Save button to save them to your hard drive", 
												"saving file, please wait", 
												"Saved successfully, enjoy the music!");
			return inftxt
		}
		
		
		
		private function loadDataFromServer():Object
		{
			
			if (ExternalInterface.available)
			{
				var data:Object = ExternalInterface.call("getJsonData");
			}
			if (!data) { throw new Error("not track data object from server") };
			return data
			
		}
		
		private function dataReady():void 
		{
			_dataReady = true;
			// I dont know what the fuck is going on with the events so here is my work around
			//dispatchEvent(new Event(Event.COMPLETE));
			_main.DataReady();
			
		}
		public function populateTrackData():Vector.<AllTracks>
		{
			if (_dataReady)
			{
				// return data array
				return _allTracksData;
			} 
			else 
			{
				throw new Error("this function populateTrackDateArray() may only be called after this class has dispatched a complete event");
			}
		}
		public function populateInfoText():InfoText
		{
			if (_dataReady)
			{
				// return info
				return _infoTextData;
			} 
			else 
			{
				throw new Error("this function populateInfoText() may only be called after this class has dispatched a complete event");
			}
		}
		
		
		
	}

}