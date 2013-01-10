package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
     public class FlashVarUtil
     {

          public static function getValue(key:String, main:Sprite):String
          {
            var value:String =  main.loaderInfo.parameters[key];
			return value;
          }


          public static function hasKey(key:String,main:Sprite):Boolean
          {
               return FlashVarUtil.getValue(key,main) ? true : false;
          }
    }
}