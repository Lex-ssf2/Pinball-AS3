package {
  import flash.display.MovieClip;
  import flash.events.Event;
  import flash.utils.getDefinitionByName;
  public class PinballStage extends MovieClip
  {
     public function PinballStage(linkageId:String):void
     {
       var stageGraphic:MovieClip = new (getDefinitionByName(linkageId) as Class)();
       this.addChild(stageGraphic);
     }
  }
}