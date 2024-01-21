function [net, tr, accuracy_Total, accuracy_Teste] = App_redes_neuronais_c_todas_as_pastas(func_treino, train_value, test_value, val_value, num_neuronios, num_camadasEscondidas, funcao_ativacao_1, funcao_ativacao_2, funcao_ativacao_3, funcao_ativacao_4)

clc
 
imds1 = imageDatastore(fullfile('NN_Tema1_images','start'),...
"IncludeSubfolders",true,"FileExtensions",".png","LabelSource","foldernames");
numImages1 = numel(imds1.Files);

imds2 = imageDatastore(fullfile('NN_Tema1_images','test'),...
"IncludeSubfolders",true,"FileExtensions",".png","LabelSource","foldernames");
numImages2 = numel(imds2.Files);

imds3 = imageDatastore(fullfile('NN_Tema1_images','train'),...
"IncludeSubfolders",true,"FileExtensions",".png","LabelSource","foldernames");
numImages3 = numel(imds3.Files);

numImages = numImages1 + numImages2 + numImages3;

cont = 0;
for i=1 : numImages
    
    if i<= numImages1
        image = readimage(imds1,i);
        image = imresize(image,0.5);
        image = imbinarize(image); %põe a imagem a 0's e 1's
        binary_matrix = image(:); %põe todos os bits numa coluna
    cont = cont +1;
    end
    
    if i<= numImages2
        image = readimage(imds2,i);
        image = imresize(image,0.5);
        image = imbinarize(image); %põe a imagem a 0's e 1's
        binary_matrix = image(:); %põe todos os bits numa coluna
    cont = cont +1;
    end
    
    if i<= numImages3
        image = readimage(imds3,i);
        image = imresize(image,0.5);
        image = imbinarize(image); %põe a imagem a 0's e 1's
        binary_matrix = image(:); %põe todos os bits numa coluna
    cont = cont +1;
    end
        
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

str = num2str(num_neuronios);
str_final = str;

switch num_camadasEscondidas
    case '2'
        str_final = append(str, ' ', str);
    case '3'
        str_final = append(str, ' ', str, ' ', str);
end

valor = str2num(str_final);

net = feedforwardnet(valor);

num = str2num(num_camadasEscondidas);

net.trainFcn = func_treino;

for i = 1 : (num + 1)
    switch i
        case 1
            net.layers{i}.transferFcn = funcao_ativacao_1;
        case 2
            net.layers{i}.transferFcn = funcao_ativacao_2;
        case 3
            net.layers{i}.transferFcn = funcao_ativacao_3;
        case 4
            net.layers{i}.transferFcn = funcao_ativacao_4;
    end
end

net.divideFcn = 'dividerand';
net.divideParam.trainRatio = train_value;
net.divideParam.valRatio = val_value;
net.divideParam.testRatio = test_value;

%treinar a rede
[net,tr] = train(net, main_matrix, target); %nome_rede = train(nome_rede, input, target)
 
y = sim(net, main_matrix); % sim(nome_rede, input)

%simular a rede e guardar o resultado na variavel y

plotconfusion(target, y) %alinea B

%Calcula e mostra a percentagem de classificacoes corretas no total dos exemplos (medidas de desempenho)
r=0;
for i=1:size(y,2)                
  [a b] = max(y(:,i));          
  [c d] = max(target(:,i));  
  if b == d                       
      r = r+1;
  end
end

accuracy_Total = r/size(y,2)*100;
%fprintf('\nPrecisao total %f\n\n', accuracy_Total)

% SIMULAR A REDE APENAS NO CONJUNTO DE TESTE
Tmain = main_matrix(:, tr.testInd);
Ttarget = target(:, tr.testInd);
y = sim(net, Tmain);

r=0;
for i=1:size(tr.testInd,2)                
  [a b] = max(y(:,i));          
  [c d] = max(Ttarget(:,i));  
  if b == d                       
      r = r+1;
  end
end

accuracy_Teste = r/size(tr.testInd,2)*100;

%fprintf('Precisao teste %f\n', accuracy_Teste)

end