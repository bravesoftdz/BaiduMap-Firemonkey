unit BaiduMapAPI.NaviService.CommTypes;

interface

uses
  FMX.Maps;

type
  TBNRoutePlanNode = record
    location:TMapCoordinate;  //����
    name:string; //��·�ڵ���
    description:string; //��·�ڵ��ַ����
  end;

  TBNRoutePlanNodes = TArray<TBNRoutePlanNode>;

implementation

end.
