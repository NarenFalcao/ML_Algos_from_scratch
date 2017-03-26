function accu1 = Assgnment2()
clear variables

result = [];
 fid=fopen('breast-cancer-wisconsin.data.txt');
 tline = fgetl(fid);
 while tline ~= -1
     if isempty(strfind(tline, '?'))
      celldata=textscan(tline,[repmat('%f',1,11)], 'delimiter',',');
      matdata = cell2mat(celldata);
      result = [result ; matdata];
     else
     %    tline
     end
     tline = fgetl(fid);
end

fclose(fid);





% fileID=fopen('breast-cancer-wisconsin.data.txt');
% cellsFromFile = textscan(fileID,[repmat('%f',1,11)], 'delimiter',',');
% X = cell2mat(cellsFromFile) 
X = result;
[row col] = size(X);

for x=1:row
   if X(x,col)==2
      X(x,col)=1;
   else
       X(x,col)=-1;
   end
end

Tdlen = round(row*2/3);
Traindata = zeros(Tdlen,col);
Testdata = zeros(row-Tdlen,col);


Traindata1 = X([1:Tdlen],:);
Testdata = X([Tdlen+1:row],:);

[rtwothird ctwothird] = size(Traindata1)

values = [.01 .02 .03 .125 .625 1]

[fullrow fullcol] = size(values);

for fulliter=1:fullcol
    
mul = values(1,fulliter)

% Tdlen = round(row*mul);
len = round(mul*rtwothird)
Traindata = zeros(len,col);


Traindata = Traindata1([1:len],:);
%Testdata = X([Tdlen+1:row],:);

[rowtrain coltrain] = size(Traindata);


newmat = zeros(coltrain,coltrain-1*2);
count=1;
class1sum =  sum(Traindata(1:end,11)==1)+1;
class2sum =  sum(Traindata(1:end,11)==-1)+1;
l=1;
% first and second column newmat means -> first column -> x=1 and y=1, x=2
% and y=1.. x=10 and y=1 -> second col -> x=1 and y=2.. for first feature.
% similarly for 9 features
Col = zeros(rowtrain,coltrain);
for x=2:coltrain-1
    Col(:,1)= Traindata(:,x);
    Col(:,2) = Traindata(:,col);
   for y=1:10
      xicounttrue= sum(Col(1:end,1)==y & Col(1:end,2)==1)+1;
      xicountfalse= sum(Col(1:end,1)==y & Col(1:end,2)==-1)+1;
      a = xicounttrue/class1sum;
      b = xicountfalse/class2sum;
      newmat(count,1) =  a;
      newmat(count,2) =  b;
      
      truemat(y,x-1) = a;
      falsemat(y,x-1)=b;
      count = count+1;
   end
   l=l+2;
end

%test data

[rowtest coltest] = size(Testdata);

for i=1:rowtest
    trueprob = 1;
    falseprob =1;
    Data = Testdata(i,:);
    [rowd cold] = size(Data);
    for j = 2:cold-2
        trueprob =  trueprob*truemat(Data(1,j),j-1);
       falseprob =  falseprob*falsemat(Data(1,j),j-1);
    end
    %with prior
    trueprob = trueprob*(class1sum/class1sum+class2sum);
    falseprob = falseprob*(class1sum/class1sum+class2sum);
    
    if(trueprob>falseprob)
    Testdata(i,12) = 1;
    else
    Testdata(i,12) = -1;
    end
end

%accuracy
success=0;
failure=0;
for i=1:rowtest
    if Testdata(i,11) == Testdata(i,12)
        success=success+1;
    else
        failure = failure+1;
    end 
end

success
failure

accuracy = success/rowtest;


accu(:,fulliter) = accuracy;

end
accu1 = accu

end


