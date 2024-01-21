function redes_neuronais_a()

clc

imds = imageDatastore(fullfile("NN_Tema1_images","start"),...
"IncludeSubfolders",true,"FileExtensions",".png","LabelSource","foldernames");
numImages = numel(imds.Files)

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


%count_rows=height(main_matrix);
%fprintf('Count rows:\n');
%count_rows

%criar a rede chamada net
net = feedforwardnet;
net.divideFcn='';

%Numero de epocas de treino: 100
%net.trainParam.epochs = 100;
net.trainFcn='traingd'; %trainlm

%valores quando resize 90%:
%traingdx 10/0
%trainc 40% (demora muito)
%traincgb 40 e 60 (rápida)
%traincgf 30/20
%traincgp 10/10
%traingd 10/0
%traingda 10/0
%traingdm 20/10
%trainoss 50/10
%trainr 10/10
%trainrp 50/40/50
%trains 70/30/70
%trainscg 10/50/0

%treinar a rede
[net,tr] = train(net, main_matrix, target); %nome_rede = train(nome_rede, input, target)

%simular a rede e guardar o resultado na variavel y
y = sim(net, main_matrix); % sim(nome_rede, input)
%plotconfusion(target, y) %alinea B

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

accuracy = r/size(y,2)*100;
fprintf('\nPrecisao total %f\n\n', accuracy);

end