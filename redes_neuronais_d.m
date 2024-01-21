function redes_neuronais_d()

clc

figura = ["circle" "kite" "parallelogram" "square" "trapezoid" "triangle" ];

imds = imageDatastore('C:\Users\Asus\Desktop\Trabalho CR\test.png');

load rede.mat;
      
image = readimage(imds,1);
image = imresize(image,0.5);
image = imbinarize(image); %põe a imagem a 0's e 1's
binary_matrix = image(:); %põe todos os bits numa coluna

[val, idx] = max(net(binary_matrix)); %[valor maior, index]

fprintf('\nFigura reconhecida pela rede neuronal: %s\n', figura(idx));

end