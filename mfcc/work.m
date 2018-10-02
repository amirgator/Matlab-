clc
clear
a = zeros(10, 10000, 39);
s = zeros(10,1);

for i=1:10
    s1=num2str(i);
    fname=strcat('M1',s1,'.mfcc');
    s(i) = size(readhtk(fname), 1);
    a(i,1:s(i),:)=readhtk(fname);
    
    fname=strcat('M2',s1,'.mfcc');
    temp = s(i) + 1;
    s(i) = s(i) + size(readhtk(fname), 1);
    a(i,temp:s(i),:)=readhtk(fname);
end

mintime = min(s);
input = a(:, 1:mintime, 1:13);
in = reshape(input, 10, mintime*13)';
clear input a s;

% Solve an Input-Output Fitting problem with a Neural Network
% Script generated by Neural Fitting app
% Created 12-Oct-2017 22:06:39
%
% This script assumes these variables are defined:
%
%   input - input data.
%   t - target data.

x = reshape(in(1:65000, :), 13000, []);
t = zeros(10,50);
e = eye(10);
for i = 1:10
    for j = 1:5
        t(:, 5*(i-1)+j) = e(:,i);
    end
end
clear in e temp mintime i j s1 fname


% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainscg';  % Scaled conjugate gradient backpropagation.

% Create a Fitting Network
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize,trainFcn);

% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess
net.input.processFcns = {'removeconstantrows','mapminmax'};
net.output.processFcns = {'removeconstantrows','mapminmax'};

% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivide
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
net.performFcn = 'mse';  % Mean Squared Error

% Choose Plot Functions
% For a list of all plot functions type: help nnplot
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotregression', 'plotfit'};

% Train the Network
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);
e = gsubtract(t,y);
performance = perform(net,t,y)

% Recalculate Training, Validation and Test Performance
trainTargets = t .* tr.trainMask{1};
valTargets = t .* tr.valMask{1};
testTargets = t .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,y)
valPerformance = perform(net,valTargets,y)
testPerformance = perform(net,testTargets,y)

% View the Network
view(net)

% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, ploterrhist(e)
%figure, plotregression(t,y)
%figure, plotfit(net,x,t)

% Deployment
% Change the (false) values to (true) to enable the following code blocks.
% See the help for each generation function for more information.
if (false)
    % Generate MATLAB function for neural network for application
    % deployment in MATLAB scripts or with MATLAB Compiler and Builder
    % tools, or simply to examine the calculations your trained neural
    % network performs.
    genFunction(net,'myNeuralNetworkFunction');
    y = myNeuralNetworkFunction(x);
end
if (false)
    % Generate a matrix-only MATLAB function for neural network code
    % generation with MATLAB Coder tools.
    genFunction(net,'myNeuralNetworkFunction','MatrixOnly','yes');
    y = myNeuralNetworkFunction(x);
end
if (false)
    % Generate a Simulink diagram for simulation or deployment with.
    % Simulink Coder tools.
    gensim(net);
end

close all
output=net(x);
om=max(output,[],1);
o_onehot=zeros(size(output));
for i=1:size(output,1)
    for j=1:size(output,2)
        if output(i,j)==om(j)
            o_onehot(i,j)=1;
        end
    end
end
sum(sum(abs(o_onehot-t)))/100
net(x(:,2))