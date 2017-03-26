clear variables
accuracyNB = Assgnment2()

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
X = result;
[row col] = size(X);


for x=1:row
   if X(x,col)==2
      X(x,col)=1;
   else
       X(x,col)=0;
   end
end

Tdlen = round(row*2/3);
Traindata = zeros(Tdlen,col);
Testdata = zeros(row-Tdlen,col);
Traindataorig = X([1:Tdlen],:);
Testdata = X([Tdlen+1:row],:);

values = [.01 .02 .03 .125 .625 1];

[fullrow fullcol] = size(values);

for fulliter=1:fullcol
W = [0 0 0 0 0 0 0 0 0 0];
 %  as =  values(1,fulliter);
 Tdlen = round(row*2/3);
Tdlen = round(Tdlen*values(1,fulliter));
Traindata = Traindataorig([1:Tdlen],:);

[rowtrain coltrain] = size(Traindata);
Traindatax = Traindata(:,[2:coltrain]);

% prediction = zeros(rowtrain,2);
% prediction(:,1) = Traindata(:,coltrain);



L_rate = 0.01;
iteration =50;

e = size(iteration,1);

% 
% values = [.675]
% 
% [fullrow fullcol] = size(values);
% 
% for fulliter=1:fullcol
%     
% mul = values(1,fulliter)
% 
% % Tdlen = round(row*mul);
% len = round(mul*rowtrain)
% Traindatax = zeros(len,col);
%Traindatax = Traindatax([1:len],:);

%[rtt ctt] = size(Traindatax)
prediction = zeros(rowtrain,1)
prediction(:,1) = Traindata(:,coltrain)


%data = zeros(1,9);
for iter = 1:iteration
    sum_error=0;
    for i=1:rowtrain
        data1 = Traindatax(i,:)
        [rowd cold] = size(data1);
        yhat = W(1,1);
       
        for j=1:cold-1
            yhat = yhat+W(1,j+1)*data1(1,j);
        end
        % yhat value
        yhat = 1.0/(1.0+exp(-yhat))
        prediction(i,2) = round(yhat);
        error = data1(1,cold) - yhat
        sum_error = sum_error+(error*error);
        W(1,1) = W(1,1)+L_rate*error*yhat*(1-yhat)
        for k=1:cold-1
            W(1,k+1) = W(1,k+1) + L_rate * error * yhat * (1-yhat)*data1(1,k);
        end
        
    end
    e(1,iter) = error;
end


%training error
success=0;
failure=0;
[pr pc] = size(Traindatax);
for i=1:pr
if (prediction(i,1)==prediction(i,2))
    success=success+1;
else
    failure = failure+1;
end
end

trainaccuracy = success/rowtrain

success
failure
% test data

Testdata1 = Testdata(:,[2:coltrain]);
[testr testc] = size(Testdata1);


testoutput = zeros(testr,2);
%old value
testoutput(:,1) = Testdata(:,testc+1);
for i=1:testr
     data2 = Testdata1(i,:);
     [rowd cold] = size(data2);
    yhat = W(1,1);
        for j=1:cold-1
            yhat = yhat+W(1,j+1)*data2(1,j);
        end
         
        yhat = 1.0/(1.0+exp(-yhat))
        yhat;
    testoutput(i,2) = round(yhat);
end

%testing error
success=0;
failure=0;
[pr pc] = size(Testdata);
for i=1:pr
if (testoutput(i,1)==testoutput(i,2))
    success=success+1;
else
    failure = failure+1;
end
end


testaccuracy = success/testr
 accu(:,fulliter) = testaccuracy;

end


accuracyLR = accu

h1 = figure;
plot(values,accuracyLR);
hold on
plot(values,accuracyNB);
xlabel('fraction of training data');
ylabel('Accuracy');