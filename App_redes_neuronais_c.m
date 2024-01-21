function [accuracy_Total] = App_redes_neuronais_c(nome_rede)

clc
imds = imageDatastore(fullfile("NN_Tema1_images","test"),...
"IncludeSubfolders",true,"FileExtensions",".png","LabelSource","foldernames");
numImages = numel(imds.Files);

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

% if isempty(nome_rede)
%     load rede.mat;
% else
%     
% end

if isempty(nome_rede)
    disp('sim')
    
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

accuracy_Total = r/size(y,2)*100;
%fprintf('\nPrecisão total %0.2f\n\n', accuracy)

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

end

