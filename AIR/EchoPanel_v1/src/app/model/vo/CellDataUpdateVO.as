package app.model.vo
{

public class CellDataUpdateVO
{
	public var id:String;
	public var cellData:Array;
	
	public function CellDataUpdateVO ( $id:String, $ar:Array ):void
	{
		id = $id;
		cellData = $ar;
	}
}

}