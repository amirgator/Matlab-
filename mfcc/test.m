clc
clear
close all 
% [a,b,c,d,e] = readhtk('M2304.mfcc');
% t=a';
% imagesc(t(2:13,:)); axis xy; colorbar
M=0;
d=50;
t=zeros(10,10*2*d);
input=zeros(M,10*2*d);
ml=100000000;
for i=1:10
    for j=1:2
        s1=num2str(i);
        s2=num2str(j);
        fname=strcat('M',s2,s1,'.mfcc');
        a=readhtk(fname);
        a=a(:);
        dl=ceil(length(a)/d);
        f=dl*d-length(a);
        for k=1:f
            a=[a;0];
        end
        ad=reshape(a,[],d);
        mt=size(ad,1);
        if mt>M
            M=mt;
        end
        if mt<ml
            ml=mt;
        end
        index=5*(2*i+j)-14;
        input(1:size(ad,1),index:index+d-1)=ad;
        t(i,2*d*i-(2*d-1):2*d*i)=1;
    end
end
t=t';
input=input';
nftool
% Solve an Input-Output Fitting problem with a Neural Network
% Script generated by Neural Fitting app
% Created 12-Oct-2017 22:06:39
%
% This script assumes these variables are defined:
%
%   input - input data.
%   t - target data.

% x = input;
% t = t;

% % Choose a Training Function
% % For a list of all training functions type: help nntrain
% % 'trainlm' is usually fastest.
% % 'trainbr' takes longer but may be better for challenging problems.
% % 'trainscg' uses less memory. Suitable in low memory situations.
% trainFcn = 'trainscg';  % Scaled conjugate gradient backpropagation.
% 
% % Create a Fitting Network
% hiddenLayerSize = 25;
% net = fitnet(hiddenLayerSize,trainFcn);
% 
% % Choose Input and Output Pre/Post-Processing Functions
% % For a list of all processing functions type: help nnprocess
% net.input.processFcns = {'removeconstantrows','mapminmax'};
% net.output.processFcns = {'removeconstantrows','mapminmax'};
% 
% % Setup Division of Data for Training, Validation, Testing
% % For a list of all data division functions type: help nndivide
% net.divideFcn = 'dividerand';  % Divide data randomly
% net.divideMode = 'sample';  % Divide up every sample
% net.divideParam.trainRatio = 70/100;
% net.divideParam.valRatio = 15/100;
% net.divideParam.testRatio = 15/100;
% 
% % Choose a Performance Function
% % For a list of all performance functions type: help nnperformance
% net.performFcn = 'mse';  % Mean Squared Error
% 
% % Choose Plot Functions
% % For a list of all plot functions type: help nnplot
% net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
%     'plotregression', 'plotfit'};
% 
% % Train the Network
% [net,tr] = train(net,x,t);
% 
% % Test the Network
% y = net(x);
% e = gsubtract(t,y);
% performance = perform(net,t,y)
% 
% % Recalculate Training, Validation and Test Performance
% trainTargets = t .* tr.trainMask{1};
% valTargets = t .* tr.valMask{1};
% testTargets = t .* tr.testMask{1};
% trainPerformance = perform(net,trainTargets,y)
% valPerformance = perform(net,valTargets,y)
% testPerformance = perform(net,testTargets,y)
% 
% % View the Network
% view(net)
% 
% % Plots
% % Uncomment these lines to enable various plots.
% %figure, plotperform(tr)
% %figure, plottrainstate(tr)
% %figure, ploterrhist(e)
% %figure, plotregression(t,y)
% %figure, plotfit(net,x,t)
% 
% % Deployment
% % Change the (false) values to (true) to enable the following code blocks.
% % See the help for each generation function for more information.
% if (false)
%     % Generate MATLAB function for neural network for application
%     % deployment in MATLAB scripts or with MATLAB Compiler and Builder
%     % tools, or simply to examine the calculations your trained neural
%     % network performs.
%     genFunction(net,'myNeuralNetworkFunction');
%     y = myNeuralNetworkFunction(x);
% end
% if (false)
%     % Generate a matrix-only MATLAB function for neural network code
%     % generation with MATLAB Coder tools.
%     genFunction(net,'myNeuralNetworkFunction','MatrixOnly','yes');
%     y = myNeuralNetworkFunction(x);
% end
% if (false)
%     % Generate a Simulink diagram for simulation or deployment with.
%     % Simulink Coder tools.
%     gensim(net);
% end
% output=net(input);
% om=max(output,[],1);
% o_onehot=zeros(size(output));
% for i=1:size(output,1)
%     for j=1:size(output,2)
%         if output(i,j)==om(j)
%             o_onehot(i,j)=1;
%         end
%     end
% end
% 
