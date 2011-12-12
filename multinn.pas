unit MultiNN;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin,VectorU;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    cbBinary: TCheckBox;
    cbActivationFunction: TComboBox;
    nrLayers: TLabel;
    lbTheta: TEdit;
    lbOutput: TEdit;
    GParameter: TEdit;
    AParameter: TEdit;
    GroupBox1: TGroupBox;
    InputFunctionOut: TEdit;
    InputFunction: TComboBox;
    InputFuncLabel: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    lbGParameter: TLabel;
    lbAParameter: TLabel;
    lbNrInputs: TLabel;
    seNr: TSpinEdit;
    seNr1: TSpinEdit;
    procedure cbBinaryChange(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit6Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GroupBox1Click(Sender: TObject);
    procedure Input1Change(Sender: TObject);
  private
    { private declarations }
    DinamicInputs: TList;
    DinamicWeights: TList;
    DinamicInputsLabels : TList;
    DinamicWeightsLabels : TList;
  public
    { public declarations }
    function linearCombine(w,x : TVector):double;
    function treshold(v:double):double;
    function sigmoid (v, g: double):double;
    function tanh(v:double):double;
    function linear(a,v:double):double;
    function piecewiseLinear(v:double):double;
    function signum(v:double):double;
    function rampa(v:double):double;
  end; 

var
  Form1: TForm1;
  n : Integer ;   // Number of inputs
  w,x : TVector;
  binary : boolean;
  l : Integer;    // Number of hidden layers

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Edit6Change(Sender: TObject);
begin
end;

procedure TForm1.Edit1Change(Sender: TObject);
var i : integer;
begin

  for i:=0 to DinamicInputs.Count-1 do
      begin
           TEdit(DinamicInputs[i]).Show;
           TLabel(DinamicInputsLabels[i]).Show;
           TEdit(DinamicWeights[i]).Show;
           TLabel(DinamicWeightsLabels[i]).Show;
      end

end;

procedure TForm1.cbBinaryChange(Sender: TObject);
begin
 binary := cbBinary.Checked;
end;

procedure TForm1.FormCreate(Sender: TObject);
var i : integer;
    tmpEdit : Tedit;
    tmpLabel : Tlabel;
begin
  n := 2 ;
  l := 2 ;
  DinamicInputs:= TList.Create();
  DinamicWeights:= TList.Create();
  DinamicInputsLabels := TList.Create();
  DinamicWeightsLabels := TList.Create();
  w := TVector.Create();
  x := TVector.Create();
  for i:=0 to n-1 do
   begin
     tmpEdit:=TEdit.Create(self);
     tmpEdit.Text := '0';
     tmpEdit.Left := 71;
     tmpEdit.Top := 80 +30*i;
     tmpEdit.Height:= 27;
     tmpEdit.Visible:= false;
     tmpEdit.Parent := Form1;
     tmpEdit.OnEditingDone:= @Input1Change;
     DinamicInputs.Add(tmpEdit);

     tmpLabel:=TLabel.Create(self);
     tmpLabel.Caption := 'Input '+IntToStr(i+1);
     tmpLabel.Left := 20;
     tmpLabel.Top := 80 +30*i;
     tmpLabel.Height:= 27;
     tmpLabel.Visible:= false;
     tmpLabel.Parent := Form1;
     DinamicInputsLabels.Add(tmpLabel);


     tmpEdit:=TEdit.Create(self);
     tmpEdit.Text := '0';
     tmpEdit.Left := 230;
     tmpEdit.Top := 80 +30*i;
     tmpEdit.Height:= 27;
     tmpEdit.Visible:= false;
     tmpEdit.Parent := Form1;
     DinamicWeights.Add(tmpEdit);


     tmpLabel:=TLabel.Create(self);
     tmpLabel.Caption := '*Weight '+IntToStr(i+1);
     tmpLabel.Left := 150;
     tmpLabel.Top := 80 +30*i;
     tmpLabel.Height:= 27;
     tmpLabel.Visible:= false;
     tmpLabel.Parent := Form1;
     DinamicWeightsLabels.Add(tmpLabel);
  end;

end;



procedure TForm1.GroupBox1Click(Sender: TObject);
begin

end;

procedure TForm1.Input1Change(Sender: TObject);
var u,y,v : double;
var m ,j : integer;
var g ,a , theta: double;
var tmpStr:String;
begin
    theta := StrToFloat(lbTheta.Text);
    g := StrToFloat(GParameter.Text);
    a := StrToFloat(AParameter.Text);;
    m:= n;
    for j:=0 to m-1 do
         begin
         tmpStr :=  TEdit(DinamicInputs[j]).Text;
         x.Add(StrToFloat(tmpStr));
         w.Add(StrToFloat(TEdit(DinamicWeights[j]).Text));
         end;
    u := linearCombine(w,x);
    InputFunctionOut.Caption:= FloatToStr(u);
    v := u - theta;
    if cbActivationFunction.ItemIndex = 0 then  y := treshold (v);
    if cbActivationFunction.ItemIndex = 1 then  y := piecewiseLinear (v);
    if cbActivationFunction.ItemIndex = 2 then
                                          begin
                                          y := sigmoid (v,g);
                                          if binary then
                                            if y < 0.5 then y := 0
                                                     else y := 1;
                                          end;
    if cbActivationFunction.ItemIndex = 3 then
                                          begin
                                          y := tanh (v);
                                          if binary then
                                            if y < 0 then y := -1
                                                     else y := 1;
                                          end ;

    if cbActivationFunction.ItemIndex = 4 then  y := Linear(a,v);
    if cbActivationFunction.ItemIndex = 5 then
                                          begin
                                          y := Rampa(v);
                                          if binary then
                                            if y < 0 then y := -1
                                                     else y := 1;

                                          end;
    if cbActivationFunction.ItemIndex = 6 then  y := signum (v);

    lbOutput.Text := FloatToStr(y)
end;

function TForm1.linearCombine(w,x : TVector):double;
  var j,m:integer;
  begin
  m:= StrToInt(seNr.Text)-1;
  if  InputFunction.ItemIndex =0 then
      begin
      result := 0;
      for j:=0 to m do
      begin
          result:= result + w[j] * x[j];  //Sum
       end;
      end;
  if  InputFunction.ItemIndex =1  then   //Product
      begin
      result := 1;
      for j:=0 to m do
      begin
          result:= result * w[j] * x[j];
       end;
      end;

      if  InputFunction.ItemIndex =3  then   //Max
      begin
      result := 0;
      for j:=0 to m do
      begin
           if    w[j] * x[j] > result then   result:=  w[j] * x[j];
       end;
      end;

       if  InputFunction.ItemIndex =2  then   //Min
      begin
      result := w[j] * x[j];
      for j:=0 to m do
      begin
           if    w[j] * x[j] < result then   result:=  w[j] * x[j];
       end;
      end;


end;

function TForm1.treshold(v:double):double;
begin
  if v >= 0 then
     result :=1
  else
     result :=0;

end;
function TForm1.sigmoid (v, g: double):double;
begin
     result := 1 / (1 + exp(0 - (g*v)));
end;

function TForm1.piecewiseLinear(v:double):double;
begin
  if v >= 0.5 then
     result :=1
  else if v > -0.5 then
     result :=v
  else
     result :=0;
end;
function TForm1.Linear(a,v:double):double;
begin
  result := v*a;

end;

function TForm1.tanh(v:double):double;
begin
   result := (exp(v)- exp(0-v))/(exp(v)+exp(0-v))
end;

function TForm1.signum(v:double):double;
begin
  if v >= 0 then
     result :=1
  else
     result :=-1;
end;


function TForm1.rampa(v:double):double;
begin
  if v >= 1 then
     result :=1
  else
     if v < -1 then
     result :=-1
     else
     result := v;
end;


end.

