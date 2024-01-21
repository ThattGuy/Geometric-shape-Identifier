function redes_neuronais_c()

clc
imds = imageDatastore(fullfile("NN_Tema1_images","test"),...
"IncludeSubfolders",true,"FileExtensions",".png","LabelSource","foldernames");
numImages = numel(imds.Files);

cont = 0;

for i=1 : numImages
    image = readimage(imds,i);
    image = imresize(image,0.5);
    image = imbinarize(image); %põe a imagem em binário
    binary_matrix = image(:); 
    cont = cont +1;
    if i>1
        main_matrix = [main_matrix binary_matrix];
    else
        main_matrix = binary_matrix;
    end
end

r = cont/6;
target = zeros(6,cont);

linha = 1;
k = r;

for i=1:cont
        target(linha,i) = 1;
        if i == r
            r = r + k;
            linha = linha + 1;
        end
    
end

%net = feedforwardnet; %default

%EXCEL - 1º Quadro
%net = feedforwardnet([50]);
%net = feedforwardnet([40 40 40 40]);
%net = feedforwardnet([50 50 50 50 50 50]);
%net = feedforwardnet([10 10]); % 10 10

% COMPLETAR A RESTANTE CONFIGURACAO
%EXCEL - 2º Quadro
%se não estivesse aqui nada abaixo, é treino default (trainlm)
%net.trainFcn = 'traincgb'; 
%net.TrainParam.epochs = 5000; %assim tira os defaults das 1000

%EXCEL - 3º Quadro
%net.layers{1}.transferFcn = 'netinv';
%net.layers{2}.transferFcn = 'radbasn';
%net.layers{3}.transferFcn = 'satlins';
%net.layers{4}.transferFcn = 'hardlims';
%net.layers{3}.transferFcn = 'logsig';

%EXCEL - 4º Quadro
%net.divideFcn = 'dividerand';
%net.divideFcn='';
%net.divideParam.trainRatio = 0.70;
%net.divideParam.valRatio = 0.15;
%net.divideParam.testRatio = 0.15;
% somar sempre até aos 100%

%treinar a rede
%[net,tr] = train(net, main_matrix, target); %nome_rede = train(nome_rede, input, target)
%save net %load net


load rede.mat;

y = sim(net, main_matrix); % sim(nome_rede, input)

%simular a rede e guardar o resultado na variavel y

plotconfusion(target, y)

%Calcula e mostra a percentagem de classificacoes corretas no total dos exemplos (medidas de desempenho)
r=0;
for i=1:size(y,2)                
  [a b] = max(y(:,i));          
  [c d] = max(target(:,i));  
  if b == d                       
      r = r+1;
  end
end

accuracy = r/size(y,2)*100;
fprintf('\nPrecisão total %0.2f\n\n', accuracy)

% SIMULAR A REDE APENAS NO CONJUNTO DE TESTE
%Tmain = main_matrix(:, tr.testInd);
%Ttarget = target(:, tr.testInd);
%y = sim(net, Tmain);
%fprintf('\nTmain---------\n')
%Tmain
%fprintf('\nTtarget---------\n')
%Ttarget

%r=0;
%for i=1:size(tr.testInd,2)                
%  [a b] = max(y(:,i));          
%  [c d] = max(Ttarget(:,i));  
%  if b == d                       
%      r = r+1;
%  end
%end

%accuracy = r/size(tr.testInd,2)*100;

%fprintf('Precisão de teste %0.2f\n', accuracy)

view(net)

%prompt = '\n\nDeseja guardar a rede? [S/N]\n';
%str = input(prompt,'s');
%if(str == 'S' || str == 's')
%    save rede net tr 
%    fprintf('Rede guardada\n')
%else
%    fprintf('Rede não guardada\n')
%end

end

