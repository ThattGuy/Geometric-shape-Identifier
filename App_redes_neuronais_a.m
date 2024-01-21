function [net, tr, accuracy_Total] = App_redes_neuronais_a(func_treino)

clc

imds = imageDatastore(fullfile("NN_Tema1_images","start"),...
"IncludeSubfolders",true,"FileExtensions",".png","LabelSource","foldernames");
numImages = numel(imds.Files)

cont = 0;
for i=1 : numImages
    image = readimage(imds,i);
    image = imresize(image,0.5);
    image = imbinarize(image); %põe a imagem a 0's e 1's
    binary_matrix = image(:); %põe todos os bits numa coluna
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

%criar a rede chamada net
net = feedforwardnet;
net.divideFcn='';

%Numero de epocas de treino: 100
%net.trainParam.epochs = 100;
net.trainFcn= func_treino; 

%treinar a rede
[net,tr] = train(net, main_matrix, target); %nome_rede = train(nome_rede, input, target)

%simular a rede e guardar o resultado na variavel y
y = sim(net, main_matrix); % sim(nome_rede, input)

% Mostrar resultado
fprintf('Saida do y:\n');
disp(y);
fprintf('Saida desejada:\n');
disp(target);

% visualizar a arquitetura da rede criada
%view(net);


r=0;
for i=1:size(y,2)                
  [a, b] = max(y(:,i));          
  [c, d] = max(target(:,i));  
  if b == d                       
      r = r+1;
  end
end

accuracy_Total = r/size(y,2)*100;
% fprintf('\nPrecisao total %f\n\n', accuracy_Total);

end