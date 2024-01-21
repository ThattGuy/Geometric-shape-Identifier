function Save_Rede_Neuronal(nome_Ficheiro, rede, target)
    cd Saves/
    tipo = '.mat';
    nome_Ficheiro = append(nome_Ficheiro, tipo);
    save provisorio rede target

    d = dir ('*.mat');
    for i=1:size(d)
        if strcmp(d(i).name,'provisorio.mat')
            movefile(d(i).name, nome_Ficheiro);
        end
    end
    cd ..;
end