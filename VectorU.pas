unit VectorU;

interface

uses Classes;

Type
   TVector = class(TObject)
   private
      FList: TList;
      function GetValues(Idx: Integer): Double;
      procedure SetValues(Idx: Integer; const Value: Double);
      function GetCount: Integer;

   public
      Constructor Create;
      Destructor Destroy; Override;

      procedure Assign(AVector: TVector);
      procedure Add(AVal: Double);
      procedure Clear;

      property Count: Integer read GetCount;
      property Values[Idx: Integer]: Double read GetValues write SetValues; Default;
   end;

implementation

{ TVector }

procedure TVector.Add(AVal: Double);
var
   pd: PDouble;
begin
   New(pd);
   pd^ := AVal;
   FList.Add(pd);
end;

procedure TVector.Assign(AVector: TVector);
var
   pd: PDouble;
   i: Integer;
begin
   Clear;

   For i := 0 to AVector.Count -1 do
   begin
      New(pd);
      pd^ := AVector[i];
      FList.Add(pd);
   end;
end;

procedure TVector.Clear;
var
   pd: PDouble;
begin
   While FList.Count <> 0 do
   begin
      pd := FList[0];
      Dispose(pd);
      FList.Delete(0);
   end;
end;

constructor TVector.Create;
begin
   FList := TList.Create;
end;

destructor TVector.Destroy;
begin
   Clear;
   FList.Free;
   inherited;
end;

function TVector.GetCount: Integer;
begin
   Result := FList.Count;
end;

function TVector.GetValues(Idx: Integer): Double;
var
   pd: PDouble;
begin
   pd := FList[Idx];
   Result := pd^;
end;

procedure TVector.SetValues(Idx: Integer; const Value: Double);
var
   pd: PDouble;
begin
   pd := FList[Idx];
   pd^ := Value;
end;

end.
 